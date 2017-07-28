{-# LANGUAGE Strict, FlexibleContexts, MultiParamTypeClasses #-}
module Latro.Typecheck where

import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import qualified Data.Map.Strict as Map
import Data.List (sort, sortBy, sortOn)
import Data.Maybe (fromMaybe, isJust, isNothing, mapMaybe)
import qualified Data.Set as Set
import Debug.Trace (trace, traceM)
import qualified Latro.AlphaConvert as AlphaConvert
import Latro.Ast
import Latro.Common
import Latro.Compiler
import Latro.Errors
import Latro.Semant
import Latro.Semant.Display ()
import Text.Printf (printf)


reportErrorAt a = reportPosOnFail a "Typecheck"
withFailPos' p = withFailPos p "Typecheck"


traceIt :: Show a => a -> a
traceIt v = trace (show v) v


showHum :: (Show k, Show v) => Map.Map k v -> String
showHum =
  Map.foldlWithKey
    (\str key val -> str ++ "\n" ++ show key ++ " --> " ++ show val)
    ""


-- Debugging
traceMetaEnv :: Checked ()
traceMetaEnv = do
  traceM "META ENV:  "
  metaEnv <- getsTC metaEnv
  traceM $ showHum metaEnv

traceVarEnv :: Checked ()
traceVarEnv = do
  traceM "VAR ENV:  "
  varEnv <- getsTC varEnv
  traceM $ showHum varEnv

tracePolyEnv :: Checked ()
tracePolyEnv = do
  traceM "POLY Env:  "
  polyEnv <- getsTC polyEnv
  traceM $ showHum polyEnv

traceFieldIndices :: Checked ()
traceFieldIndices = do
  traceM "Field indices:  "
  fiEnv <- getsTC fieldIndexEnv
  traceM $ showHum fiEnv


-- A new var env needs to close over all
-- bindings in the existing env, so
-- the update function is the identity function
markVarEnv :: Checked VarEnv
markVarEnv =
  getsTC varEnv


restoreVarEnv :: VarEnv -> Checked ()
restoreVarEnv varEnv =
  modifyTC (\tcEnv -> tcEnv { varEnv = varEnv })


exportTy :: UniqId -> TyCon -> Checked ()
exportTy id tyCon =
  modifyTC (\tcEnv -> tcEnv { typeEnv = Map.insert id tyCon (typeEnv tcEnv) })


bindVar :: UniqId -> Ty -> Checked ()
bindVar id ty =
  modifyTC (\tcEnv -> tcEnv { varEnv = Map.insert id ty (varEnv tcEnv) })


bindVarIfNotBound :: UniqId -> Ty -> Checked ()
bindVarIfNotBound id ty =
  modifyTC (\tcEnv -> tcEnv { varEnv = Map.insertWith (\new old -> old) id ty (varEnv tcEnv) })


bindPat :: UniqId -> Ty -> Checked ()
bindPat id ty =
  modifyTC (\tcEnv -> tcEnv { patEnv = Map.insert id ty (patEnv tcEnv) })


bindPoly :: UniqId -> Ty -> Checked ()
bindPoly id ty =
  modifyTC (\tcEnv -> tcEnv { polyEnv = Map.insert id ty (polyEnv tcEnv) })


bindMeta :: UniqId -> Ty -> Checked ()
bindMeta id (TyMeta straints otherMetaId) = do
  newMeta <- freshMeta >>= \(TyMeta _ id) -> return $ TyMeta straints id
  modifyTC (\tcEnv ->
              let env = metaEnv tcEnv
                  metaEnv' = Map.insert id newMeta env
                  metaEnv'' = Map.insert otherMetaId newMeta metaEnv'
              in
                tcEnv { metaEnv = metaEnv'' })

bindMeta id ty =
  modifyTC (\tcEnv -> tcEnv { metaEnv = Map.insert id ty (metaEnv tcEnv) })


bindFieldIndex :: UniqId -> Int -> Checked ()
bindFieldIndex id ind = do
  modifyTC (\tcEnv -> tcEnv { fieldIndexEnv = Map.insert id ind (fieldIndexEnv tcEnv) })


bindProtoDec :: ProtocolId -> [MethodId] -> Checked ()
bindProtoDec id methodIds =
  modifyTC (\tcEnv -> tcEnv { protoEnv = Map.insert id methodIds (protoEnv tcEnv) })


bindMethodId :: MethodId -> ProtocolId -> Checked ()
bindMethodId methodId protoId =
  modifyTC (\tcEnv -> tcEnv { methodEnv = Map.insert methodId protoId (methodEnv tcEnv) })


bindDictParam :: ProtocolId -> Ty -> UniqId -> Checked ()
bindDictParam protoId ty paramId =
  modifyTC (\tcEnv -> tcEnv { dictParamEnv = Map.insert (protoId, ty) paramId (dictParamEnv tcEnv) })


isMethod :: UniqId -> Checked Bool
isMethod id = do
  mEnv <- getsTC methodEnv
  return $ isJust $ Map.lookup id mEnv


isOverloaded :: Ty -> Bool
isOverloaded ty = not $ null $ context ty


mtApp :: TyCon -> Ty
mtApp tyCon = TyApp tyCon []


-- Shortcuts for primitive types
tyInt :: Ty
tyInt = mtApp TyConInt

tyBool :: Ty
tyBool = mtApp TyConBool


tyStr :: Ty
tyStr = TyApp TyConList [tyChar]

tyChar :: Ty
tyChar = mtApp TyConChar

tyUnit :: Ty
tyUnit = mtApp TyConUnit

tyList :: Ty -> Ty
tyList elemTy = TyApp TyConList [elemTy]

tyTuple :: [Ty] -> Ty
tyTuple elemTys = TyApp TyConTuple elemTys

tyMain :: Ty
tyMain = TyApp TyConArrow [tyList tyStr, tyUnit]


makeFresh :: RawId -> Checked UniqId
makeFresh raw = do
  tcAlphaEnv <- getsTC tcAlphaEnv
  let (uniqId, tcAlphaEnv') = AlphaConvert.freshId (UserId raw) tcAlphaEnv
  modifyTC (\tcEnv -> tcEnv { tcAlphaEnv = tcAlphaEnv' })
  return uniqId


freshId :: Checked UniqId
freshId = makeFresh "t"


freshMeta :: Checked Ty
freshMeta = do
  (UniqId n raw) <- makeFresh "meta"
  return $ TyMeta [] $ UniqId n $ printf "meta@%i" n


lookupOrFail :: Map.Map UniqId a -> UniqId -> Checked a
lookupOrFail table id =
  let result = Map.lookup id table
  in hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) result


envLookup :: Ord k => (TCEnv -> Map.Map k a) -> k -> Checked (Maybe a)
envLookup getTable key = do
  table <- getsTC getTable
  return $ Map.lookup key table


envLookupOrFail :: (TCEnv -> Map.Map UniqId a) -> UniqId -> Checked a
envLookupOrFail getTable id = do
  result <- envLookup getTable id
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) result


lookupFieldIndex :: UniqId -> UniqId -> Checked Int
lookupFieldIndex tyId id = do
  fieldIndices <- getsTC fieldIndexEnv
  lookupOrFail fieldIndices id


lookupMeta :: UniqId -> Checked (Maybe Ty)
lookupMeta id = do
  result <- envLookup metaEnv id
  case result of
    Just ty -> do { ty' <- subst ty; return $ Just ty' }
    _ -> return result


isFreeMeta :: Ty -> Checked Bool
isFreeMeta (TyMeta _ id) = do
  ty <- lookupMeta id
  return $ isNothing ty


markPolyEnv :: Checked (Map.Map UniqId Ty)
markPolyEnv = getsTC polyEnv


restorePolyEnv :: Map.Map UniqId Ty -> Checked ()
restorePolyEnv env = modifyTC (\tcEnv -> tcEnv { polyEnv = env })


markMetaEnv :: Checked (Map.Map UniqId Ty)
markMetaEnv = getsTC metaEnv


restoreMetaEnv :: Map.Map UniqId Ty -> Checked ()
restoreMetaEnv env = modifyTC (\tcEnv -> tcEnv { metaEnv = env })


lookupPoly :: UniqId -> Checked (Maybe Ty)
lookupPoly = envLookup polyEnv


lookupTyIn :: Env TyCon -> UniqId -> Checked TyCon
lookupTyIn table id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id table


lookupVarIn :: TEnv -> UniqId -> Checked Ty
lookupVarIn table id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id table


lookupPatIn :: TEnv -> UniqId -> Checked Ty
lookupPatIn table id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id table


lookupPat :: SourcePos -> UniqId -> Checked Ty
lookupPat p id = do
  patFuns <- getsTC patEnv
  lookupPatIn patFuns id `reportErrorAt` p


tryLookupPat :: SourcePos -> UniqId -> Checked (Maybe Ty)
tryLookupPat p id = (liftM Just) (lookupPat p id) `catchError` (\err -> return Nothing)


lookupTy :: UniqId -> Checked TyCon
lookupTy id = do
  typeEnv <- getsTC typeEnv
  lookupTyIn typeEnv id


lookupTyQual :: UniqAst QualifiedId -> Checked TyCon
lookupTyQual (Id p id) = lookupTy id `reportErrorAt` p


lookupVar :: UniqId -> Checked Ty
lookupVar id = do
  maybeTy <- envLookup varEnv id
  case maybeTy of
    Nothing -> freshMeta
    Just ty -> return ty


combineConstraints :: [ProtocolId] -> [ProtocolId] -> [ProtocolId]
combineConstraints a b =
  Set.toList $ Set.union (Set.fromList a) (Set.fromList b)


context :: Ty -> [(Ty, ProtocolId)]
context ty =
  case ty of
    TyApp tyCon tyArgs -> concatMap context tyArgs
    TyPoly _ ctx ty -> ctx ++ context ty
    TyOverloaded ctx ty -> ctx ++ context ty
    _ -> []


stripContext :: Ty -> Ty
stripContext (TyOverloaded _ ty) = ty
stripContext ty = ty


addToContext :: Context -> Ty -> Context
addToContext ctx meta@(TyMeta straints id) =
  map (\protoId -> (meta, protoId)) straints ++ ctx

addToContext ctx tyVar@(TyVar straints id) =
  map (\protoId -> (tyVar, protoId)) straints ++ ctx

addToContext ctx (TyApp TyConArrow arrowTys) =
  concatMap (addToContext ctx) arrowTys ++ ctx

addToContext ctx (TyApp tyCon tyArgs) =
  concatMap (addToContext ctx) tyArgs ++ ctx

addToContext ctx ty = ctx


liftContext :: Ty -> Ty
liftContext (TyPoly tyVarIds ctx innerTy) =
  TyPoly tyVarIds (addToContext ctx innerTy) innerTy

liftContext ty = ty


findConstraintsFor :: Ty -> Context -> [ProtocolId]
findConstraintsFor _ [] = []
findConstraintsFor ty ((cty, cProtoId) : ctx')
  | ty == cty = cProtoId : findConstraintsFor ty ctx'
  | otherwise = findConstraintsFor ty ctx'


-- Given a type with some context, distribute all constraints
-- in the context to any occurrences of their respective types.
-- This should be idempotent and we should also always
-- retain the "structure" of the original type, e.g. this
-- will not remove any context information -- only augment
-- individual type-var references to include class constraints
distContext :: Context -> Ty -> Ty
distContext ctx (TyOverloaded ctx' ty) = TyOverloaded ctx' $ distContext (ctx ++ ctx') ty
distContext ctx (TyPoly tyParamIds ctx' ty) = TyPoly tyParamIds ctx' $ distContext (ctx ++ ctx') ty

distContext ctx (TyApp tyCon tyArgs) =
  TyApp tyCon $ map (distContext ctx) tyArgs

distContext ctx ty@(TyVar straints id) =
  TyVar (combineConstraints straints (findConstraintsFor ty ctx)) id

distContext ctx ty@(TyMeta straints id) =
  TyMeta (combineConstraints straints (findConstraintsFor ty ctx)) id

distContext _ ty@TyRef{} = ty


distributeContext :: Ty -> Ty
distributeContext (TyOverloaded ctx ty) = TyOverloaded ctx $ distContext ctx ty
distributeContext (TyPoly tyParamIds ctx ty) = TyPoly tyParamIds ctx $ distContext ctx ty
distributeContext ty = ty


metaOccursInTyCon :: Ty -> TyCon -> Bool
metaOccursInTyCon tyMeta@(TyMeta _ metaId) tyCon =
  case tyCon of
    TyConTyFun _ ty -> metaOccursIn tyMeta ty
    TyConUnique _ tyCon -> metaOccursInTyCon tyMeta tyCon
    _ -> False

metaOccursIn :: Ty -> Ty -> Bool
metaOccursIn tyMeta@(TyMeta _ metaId) ty =
  case ty of
    TyApp tyCon argTys   -> metaOccursInTyCon tyMeta tyCon || any (metaOccursIn tyMeta) argTys
    TyPoly _ ctx ty      -> any (metaOccursIn tyMeta) (fst (unzip ctx)) || metaOccursIn tyMeta ty
    TyVar{}              -> False
    TyMeta _ otherMetaId -> metaId == otherMetaId
    TyRef _              -> False
    TyOverloaded ctx ty  -> any (metaOccursIn tyMeta) (fst (unzip ctx)) || metaOccursIn tyMeta ty

metaOccursIn _ _ = False


expand :: Ty -> Checked Ty
expand (TyApp (TyConTyFun tyParamIds ty) tyArgs) = do
  mapM_ (uncurry bindPoly) $ zip tyParamIds tyArgs
  ty' <- subst ty
  expand ty'
expand (TyApp (TyConUnique _ tyCon) tyArgs) =
  expand (TyApp tyCon tyArgs)
expand meta@(TyMeta _ id) = do
  maybeTy <- lookupMeta id
  case maybeTy of
    Just ty -> expand ty
    _ -> return meta

expand ty = return ty


-- generalize: Lift all free metavariables
-- up to poly type params, yielding a poly type
-- Note that applying this function to any
-- type will yield a poly type, so monomorphic
-- types will become poly types with empty
-- type param lists

allMetasInTyCon :: TyCon -> [Ty]
allMetasInTyCon (TyConTyFun _ ty) = allMetasIn ty
allMetasInTyCon (TyConUnique _ tyCon) = allMetasInTyCon tyCon
allMetasInTyCon _ = []


allMetasIn :: Ty -> [Ty]
allMetasIn ty =
  case ty of
    TyApp tyCon tyArgs  -> allMetasInTyCon tyCon ++ concatMap allMetasIn tyArgs
    TyPoly _ ctx ty     -> (concatMap allMetasIn $ fst $ unzip ctx) ++ allMetasIn ty
    TyVar{}             -> []
    meta@(TyMeta _ id)  -> [meta]
    TyRef _             -> []
    TyOverloaded ctx ty -> (concatMap allMetasIn $ fst $ unzip ctx) ++ allMetasIn ty


referencedMetas :: Ty -> Checked [Ty]
referencedMetas meta@(TyMeta _ metaId) = do
  result <- lookupMeta metaId
  transitiveRefs <- case result of
    Just ty ->
      case ty of
        TyMeta{}    -> referencedMetas ty
        _           -> return []
    _ -> return []
  return (meta : transitiveRefs)


allMetasInEnv :: Checked [Ty]
allMetasInEnv = do
  varEnv <- getsTC varEnv
  let allTys = snd $ unzip $ Map.toList varEnv
      metaTys  = filter (\ty -> case ty of
                                  TyMeta{} -> True
                                  _        -> False)
                        allTys
  allBoundMetaSets <- mapM referencedMetas metaTys
  return $ concat allBoundMetaSets


freeMetas :: Ty -> Checked [Ty]
freeMetas ty =
  let occurringMetas = allMetasIn ty
  in do allMetas <- allMetasInEnv
        let occursSet = Set.fromList occurringMetas
            envSet = Set.fromList allMetas
            freeSet = Set.difference occursSet envSet
        return $ Set.toList freeSet


trimUnusedPolyParams :: Ty -> Ty
trimUnusedPolyParams (TyPoly [] _ ty) = ty
trimUnusedPolyParams (TyPoly tyParamIds ctx ty) =
    case tyParamIds' of
      [] -> ty
      _  -> TyPoly tyParamIds' ctx ty
  where
    allTyConVarIds tyCon =
      case tyCon of
        TyConTyVar id   -> [id]
        TyConTyFun _ ty -> allTyVarIds ty
        _               -> []
    allTyVarIds ty =
      case ty of
        TyApp tyCon tys -> allTyConVarIds tyCon ++ concatMap allTyVarIds tys
        TyPoly _ ctx ty -> allTyVarIds ty ++ (concatMap allTyVarIds $ fst $ unzip ctx)
        TyVar _ id      -> [id]
        _               -> []
    allCtxTyVarIds (ty, _) = allTyVarIds ty
    paramIdSet = Set.fromList tyParamIds
    usedParamIdSet = Set.fromList (allTyVarIds ty ++ concatMap allCtxTyVarIds ctx)
    tyParamIds' = Set.toList $ Set.intersection paramIdSet usedParamIdSet

trimUnusedPolyParams ty = ty


generalize :: Ty -> Checked Ty
generalize t = do
    -- traceM $ printf "Generalizing %s" $ showSexp ty
    ty' <- subst ty
    frees <- freeMetas ty'
    tyParamIds <- mapM (const freshId) frees
    let metasAndTyParamIds = zip frees tyParamIds
    mapM_ (\(TyMeta straints metaId, paramId) -> bindMeta metaId $ TyVar straints paramId)
          metasAndTyParamIds
    ty'' <- subst ty'
    ctx' <- mapM (\(ty, protoId) -> do { ty' <- subst ty; return (ty', protoId) }) ctx
    case tyParamIds of
      [] -> return ty''
      _ -> 
        let poly = distributeContext $ trimUnusedPolyParams $ TyPoly tyParamIds ctx' ty''
        in return $ liftContext poly
  where
    (ctx, ty) = case t of
                  TyOverloaded ctx innerTy -> (ctx, innerTy)
                  _                        -> ([], t)


instantiate :: Ty -> Checked Ty
instantiate (TyPoly tyParamIds ctx ty) = do
  oldPolyEnv <- markPolyEnv
  mapM_ (\paramId -> do { meta <- freshMeta; bindPoly paramId meta })
        tyParamIds
  ctx' <- mapM (\(ty, protoId) -> do
                  ty' <- subst ty
                  return (ty', protoId))
          ctx
  ty' <- subst ty
  restorePolyEnv oldPolyEnv
  case ctx' of
    [] -> return ty'
    _  -> return $ distributeContext $ TyOverloaded ctx' ty'

instantiate ty = return ty


substTyCon :: TyCon -> Checked TyCon
substTyCon (TyConTyFun varIds ty) = do
  ty' <- subst ty
  return $ TyConTyFun varIds ty'

substTyCon tyCon = return tyCon


subst :: Ty -> Checked Ty
subst ty =
  -- traceM $ printf "Substing %s" $ showSexp ty
  case ty of
    meta@(TyMeta _ id) -> do
      maybeTy <- lookupMeta id
      case maybeTy of
        Just ty -> subst ty
        _ -> return meta

    TyApp (TyConTyFun [] tyRef@(TyRef _)) [] -> subst tyRef

    TyApp tyCon@(TyConTyFun tyParamIds ty) tyArgs
      | length tyParamIds == length tyArgs ->
        do mapM_ (uncurry bindPoly) $ zip tyParamIds tyArgs
           subst ty >>= subst
      | otherwise ->
        throwError $ ErrPartialTyConApp tyCon tyArgs

    TyApp tyCon tyArgs -> do
      tyCon' <- substTyCon tyCon
      tyArgs' <- mapM subst tyArgs
      return $ TyApp tyCon' tyArgs'

    var@(TyVar _ id) -> do
      maybeTy <- lookupPoly id
      case maybeTy of
        Just ty -> return ty
        _ -> return var

    TyPoly tyParamIds ctx ty -> do
      ctx' <- mapM (\(ty, protoId) -> do { ty' <- subst ty; return (ty', protoId) }) ctx
      ty' <- subst ty
      return $ TyPoly tyParamIds ctx' ty'

    TyOverloaded ctx ty -> do
      ctx' <- mapM (\(ty, protoId) -> do { ty' <- subst ty; return (ty', protoId) }) ctx
      ty' <- subst ty
      return $ TyOverloaded ctx' ty'

    TyRef (Id _ id) -> do
      tyCon <- lookupTy id
      tyCon' <- substTyCon tyCon
      return $ TyApp tyCon' []

    _ -> throwError $ ErrInterpFailure $ "Inexhaustive case in 'subst' for type: " ++ show ty


checkConstraints :: TyCon -> [TyConstraint] -> Checked ()
checkConstraints _ [] = return ()
checkConstraints tyCon (TyConstraint protoId : straints) =
  throwError $ ErrDoesNotImplementProtocol tyCon protoId


-- Helper for type mismatches (we don't want
-- to expose types with free metavariables to the
-- user, so we generalize before reporting a
-- type error)
unifyFail :: Ty -> Ty -> Checked Ty
unifyFail a b = do
  a' <- generalize a
  b' <- generalize b
  throwError $ ErrCantUnify a b


unify :: Ty -> Ty -> Checked Ty
unify tya tyb = do
  -- traceM $ "UNIFY " ++ show tya ++ " ---> " ++ show tyb
  oldPolyEnv <- markPolyEnv
  oldMetaEnv <- markMetaEnv
  case (tya, tyb) of
    (a@(TyApp (TyConUnique ida _) tyArgsA), TyApp (TyConUnique idb _) tyArgsB) ->
      if ida == idb
        then do mapM_ (uncurry unify) $ zip tyArgsA tyArgsB
                return a
        else unifyFail tya tyb

    (a@(TyApp tyconA tyArgsA), b@(TyApp tyconB tyArgsB))
      | tyconA == tyconB ->
        do mapM_ (uncurry unify) $ zip tyArgsA tyArgsB
           return a

    (TyApp (TyConTyFun paramVarIds ty) tyArgs, tyb) -> do
      mapM_ (uncurry bindPoly) $ zip paramVarIds tyArgs
      ty' <- subst ty
      unify ty' tyb

    (tya, TyApp (TyConTyFun paramVarIds ty) tyArgs) -> do
      mapM_ (uncurry bindPoly) $ zip paramVarIds tyArgs
      ty' <- subst ty
      unify tya ty'

    -- TODO: context reduction is needed here
    (TyPoly [] ctx tya, tyb) -> unify (distContext ctx tya) tyb

    (TyPoly aParamIds ctxA aty, TyPoly bParamIds ctxB bty) ->
      let paramIds = zip bParamIds aParamIds
      in do mapM_ (\(bParamId, aParamId) ->
                      let tva = TyVar [] aParamId
                          tvb = TyVar [] bParamId
                          straintsA = findConstraintsFor tva ctxA
                          straintsB = findConstraintsFor tvb ctxB
                          straints  = combineConstraints straintsA straintsB
                      in bindPoly bParamId $ TyVar straints aParamId)
                  paramIds
            bty' <- subst bty
            unify aty bty'

    (meta@(TyMeta straintsA metaId), ty) -> do
      metaTy <- lookupMeta metaId
      case metaTy of
        Just mty -> unify mty ty
        _ ->
          case ty of
            TyApp (TyConTyFun _ _) _ -> do
              expanded <- expand ty
              unify meta expanded
            TyMeta straintsB rhMetaId ->
              if metaId == rhMetaId
              then return $ TyMeta (combineConstraints straintsA straintsB) metaId
              else let ty' = TyMeta (combineConstraints straintsA straintsB) rhMetaId
                   in do maybeRhMetaTy <- lookupMeta rhMetaId
                         case maybeRhMetaTy of
                           Just rhMetaTy -> unify meta rhMetaTy
                           _ -> do bindMeta metaId ty'
                                   return ty'
            _ ->
              if meta `metaOccursIn` ty
              then throwError $ ErrCircularType meta ty
              else do
                bindMeta metaId ty
                return ty

    (ta@(TyVar straintsA a), tb@(TyVar straintsB b)) ->
      if a == b
      then do ty <- lookupPoly a
              return $ fromMaybe (TyVar (combineConstraints straintsA straintsB) a) ty
      else throwError $ ErrCantUnify ta tb

    (ty, meta@(TyMeta _ _)) -> unify meta ty
    (ta@(TyRef a), tb@(TyRef b)) ->
      if a == b
      then do tyCon <- lookupTyQual a
              return $ TyApp tyCon []
      else unifyFail ta tb

    (tyRef@(TyRef _), ty) -> unify ty tyRef
    (ty, TyRef qid) -> do
      tyb <- lookupTyQual qid
      unify ty $ TyApp tyb []

    (tyA, TyOverloaded ctxB tyB) -> do
      ty' <- unify tyA tyB
      return $ TyOverloaded ctxB ty'

    (TyOverloaded ctxA tyA, tyB) -> do
      ty' <- unify tyA tyB
      return $ TyOverloaded ctxA ty'

    (ta, tb) -> unifyFail ta tb


unifyAll :: [Ty] -> Checked Ty
unifyAll [] = freshMeta
unifyAll [ty] = return ty
unifyAll (ta:tb:tys) = do
  ty' <- unify ta tb
  unifyAll (ty':tys)


-- Convert a "syntax-level type" into a
-- tycon
tcTycon :: UniqAst SynTy -> Checked TyCon
tcTycon sty =
  case sty of
    SynTyInt _ -> return TyConInt
    SynTyBool _ -> return TyConBool
    SynTyString _ -> throwError $ ErrNotATyCon sty
    SynTyChar _ -> return TyConChar
    SynTyUnit _ -> return TyConUnit
    SynTyRef _ qid synTyArgs -> lookupTyQual qid


-- A "syntax-level type" is just an
-- AST representing a type
tcTy :: UniqAst SynTy -> Checked Ty
tcTy (SynTyPrim p tyId) = throwError (ErrPrimTypeUnknown $ getRawId tyId) `reportErrorAt` p
tcTy (SynTyInt _) = return tyInt
tcTy (SynTyBool _) = return tyBool
tcTy (SynTyChar _) = return tyChar
tcTy (SynTyUnit _) = return tyUnit
tcTy (SynTyArrow _ paramTys retTy) = do
  paramTys' <- mapM tcTy paramTys
  retTy' <- tcTy retTy
  return $ TyApp TyConArrow $ paramTys' ++ [retTy']

tcTy (SynTyTuple _ tyArgs) = do
  tyArgs' <- mapM tcTy tyArgs
  return $ TyApp TyConTuple tyArgs'

tcTy (SynTyList _ tyArg) = do
  tyArg' <- tcTy tyArg
  return $ TyApp TyConList [tyArg']

tcTy (SynTyRef _ qid synTyArgs) = do
  tyCon <- lookupTyQual qid
  case tyCon of
    TyConTyVar id'                -> return $ TyVar [] id'
    _ -> do
      tyArgs <- mapM tcTy synTyArgs
      return $ TyApp tyCon tyArgs


tcAdtAlt :: UniqAst AdtAlternative -> Checked (UniqId, [Ty])
tcAdtAlt (AdtAlternative _ id _ synTys) = do
  argTys <- mapM tcTy synTys
  return (id, argTys)


makeAdtCtor :: UniqAst AdtAlternative -> Ty -> Ty -> [Ty] -> Checked (Typed IL)
makeAdtCtor (AdtAlternative p ctorId ctorInd synTys) adtTy ctorTy argTys = do
  paramIds <- mapM (const freshId) synTys
  let paramDs = map (\(paramId, synTy, ty) -> (paramId, nodeData synTy, ty))
                    $ zip3 paramIds synTys argTys
      paramRefs = map (\(paramId, pp, pty) -> (ILRef (OfTy pp pty) paramId)) paramDs
      argPatEs = map (\(paramId, paramTy) -> PatExpId (OfTy p paramTy) paramId) $ zip paramIds argTys
      ctorFun = ILFun (OfTy p ctorTy) paramIds (ILMakeAdt (OfTy p adtTy) ctorId ctorInd paramRefs)
  return $ ILAssign (OfTy p tyUnit) (ILPatId (OfTy p ctorTy) ctorId) ctorFun


tcTyDec :: UniqAst TypeDec -> Checked (TyCon, [Typed IL])
tcTyDec (TypeDecTy _ id tyParamIds (SynTyInt _)) = return (TyConInt, [])
tcTyDec (TypeDecTy _ id tyParamIds (SynTyBool _)) = return (TyConBool, [])
tcTyDec (TypeDecTy _ id tyParamIds (SynTyChar _)) = return (TyConChar, [])
tcTyDec (TypeDecTy _ id tyParamIds (SynTyUnit _)) = return (TyConUnit, [])
tcTyDec (TypeDecTy _ id tyParamIds synTy@(SynTyRef _ qid synTyArgs)) = do
  mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  tyArgs <- mapM tcTy synTyArgs
  ty <- tcTy synTy
  let tycon = TyConTyFun tyParamIds ty
  exportTy id tycon
  return (tycon, [])

tcTyDec (TypeDecTy _ id tyParamIds synTy@(SynTyTuple _ stys)) = do
  mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  elemTys <- mapM tcTy stys
  let tycon = TyConTyFun tyParamIds $ TyApp TyConTuple elemTys
  exportTy id tycon
  return (tycon, [])

tcTyDec (TypeDecTy _ id tyParamIds (SynTyList _ sty)) = do
  mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  elemTy <- tcTy sty
  let tycon = TyConTyFun tyParamIds $ TyApp TyConList [elemTy]
  exportTy id tycon
  return (tycon, [])

-- We desugar struct types into simple product types, with getter
-- functions for each field using the following rule:
--
-- type ID = { TY0 FID0; TY1 FID1; };
--
-- -->
--
-- type ID = ID TY0 TY1;
--
-- FID0 => fun(ID) : TY0;
-- FID0(x) { get-adt-field(ID, 0); };
--
-- FID1 => fun(ID) : TY1;
-- FID1(x) { get-adt-field(x, 1); };
tcTyDec (TypeDecTy p id tyParamIds (SynTyStruct _ fields)) =
  let (fieldNames, fieldSynTys) = unzip fields
  in do
    -- Bind a 'name' type for recursive definitions
    exportTy id $ TyConTyFun tyParamIds $ TyRef $ Id p id
    -- Bind a 'tyvar' tycon for each type parameter
    mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
    fieldTys <- mapM tcTy fieldSynTys
    let alt = AdtAlternative p id 0 fieldSynTys
        adtDec = TypeDecAdt p id tyParamIds [alt]
    (adtTyCon, es) <- tcTyDec adtDec
    let adtTy = TyApp adtTyCon [TyApp TyConTuple fieldTys]
    getters <- mapMi (\index (fName, fTy) ->
                        let getterTy = TyApp TyConArrow [adtTy, fTy]
                        in do bindFieldIndex fName index
                              bindVar fName getterTy
                              paramId <- freshId
                              return $
                                ILAssign
                                  (OfTy p tyUnit)
                                  (ILPatId (OfTy p getterTy) fName)
                                  (ILFun
                                    (OfTy p getterTy)
                                    [paramId]
                                    (ILGetAdtField (OfTy p adtTy) (ILRef (OfTy p adtTy) paramId) index)))
                (zip fieldNames fieldTys)
    return (adtTyCon, es ++ getters)

tcTyDec (TypeDecAdt p id tyParamIds alts) = do
  -- Bind a 'name' type for recursive definitions
  exportTy id $ TyConUnique id $ TyConTyFun tyParamIds $ TyRef $ Id p id
  -- Bind a 'tyvar' tycon for each type parameter
  mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  altNamesTys <- mapM tcAdtAlt alts
  let (names, tys) = unzip altNamesTys
      altsTys = zip alts tys
      ctorTups = map (TyApp TyConTuple) tys
      adtTyCon = TyConUnique id $ TyConTyFun tyParamIds $ TyApp (TyConAdt names) ctorTups
  -- Add a function binding for each constructor,
  -- and return a function expression for each one
  ctorEs <- mapM (\(alt@(AdtAlternative altPos ctorName _ _), argTys) ->
                    let ctorTy = TyPoly tyParamIds [] $ TyApp TyConArrow (argTys ++ [TyApp adtTyCon (map (TyVar []) tyParamIds)])
                    in do bindVar ctorName ctorTy
                          bindPat ctorName ctorTy
                          makeAdtCtor alt (TyApp adtTyCon argTys) ctorTy argTys)
                 altsTys
  return (adtTyCon, ctorEs)


tcPatExp :: Untyped ILPat -> Checked (Ty, Typed ILPat)
tcPatExp (ILPatInt p n) = return (tyInt, ILPatInt (OfTy p tyInt) n)
tcPatExp (ILPatBool p b) = return (tyBool, ILPatBool (OfTy p tyBool) b)
tcPatExp (ILPatStr p s) = return (tyStr, ILPatStr (OfTy p tyStr) s)
tcPatExp (ILPatChar p s) = return (tyChar, ILPatChar (OfTy p tyChar) s)
tcPatExp (ILPatTuple p es) = do
  (eTys, es') <- mapAndUnzipM tcPatExp es
  let ty = TyApp TyConTuple eTys
  return (ty, ILPatTuple (OfTy p ty) es')

tcPatExp (ILPatAdt p id es) = do
  patFunTy <- lookupPat p id
  (eTys, es') <- mapAndUnzipM tcPatExp es
  retTyMeta@(TyMeta [] retTyMetaId) <- freshMeta
  let gotTy = TyApp TyConArrow $ eTys ++ [retTyMeta]
  patFunTy' <- instantiate patFunTy
  (TyApp TyConArrow eTys) <- unify patFunTy' gotTy `reportErrorAt` p
  let (retTy:_) = reverse eTys
  return (retTy, ILPatAdt (OfTy p retTy) id es')

tcPatExp (ILPatList p es) = do
  (eTys, es') <- mapAndUnzipM tcPatExp es
  patElemTy <- unifyAll eTys `reportErrorAt` p
  let ty = TyApp TyConList [patElemTy]
  return (ty, ILPatList (OfTy p ty) es')

tcPatExp (ILPatCons p eHd eTl) = do
  (hdTy, eHd') <- tcPatExp eHd
  (tlTy, eTl') <- tcPatExp eTl
  ty <- unify tlTy (TyApp TyConList [hdTy]) `reportErrorAt` (ilNodeData eTl)
  return (ty, ILPatCons (OfTy p ty) eHd' eTl')

-- If the identifier matches a bound ADT constructor name,
-- we assume this is an ADT pattern on a 0-argument constructor.
-- Otherwise the identifier shadows anything that is already bound.
tcPatExp (ILPatId p id) = do
  maybePatTy <- tryLookupPat p id
  case maybePatTy of
    Just _ -> tcPatExp $ ILPatAdt p id []
    _      ->
      do ty <- freshMeta
         bindVar id ty
         return (ty, ILPatId (OfTy p ty) id)

tcPatExp (ILPatWildcard p) = do
  ty <- freshMeta
  return (ty, ILPatWildcard (OfTy p ty))


addBindingsForPat :: Untyped ILPat -> Ty -> Checked ()
addBindingsForPat (ILPatTuple _ patEs) (TyApp TyConTuple tyArgs) =
  let componentEsTys = zip patEs tyArgs
  in mapM_ (uncurry addBindingsForPat) componentEsTys

addBindingsForPat (ILPatAdt _ _ es) (TyApp (TyConUnique _ _) argTys) =
  mapM_ (uncurry addBindingsForPat) $ zip es argTys

addBindingsForPat (ILPatList _ elemEs) (TyApp TyConList [tyArg]) =
  let addBindingsForPatWithTy = flip addBindingsForPat tyArg
  in mapM_ addBindingsForPatWithTy elemEs

addBindingsForPat (ILPatList _ elemEs) (TyPoly [tyParamId] _ (TyApp TyConList [tyArg])) =
  let elemTy = TyPoly [tyParamId] [] tyArg
      addBindingsForPatWithTy = flip addBindingsForPat elemTy
  in mapM_ addBindingsForPatWithTy elemEs

addBindingsForPat (ILPatList _ []) (TyMeta _ _) = return ()

addBindingsForPat (ILPatCons _ hdE tlE) ty@(TyApp TyConList [tyArg]) = do
  addBindingsForPat hdE tyArg
  addBindingsForPat tlE ty

addBindingsForPat (ILPatId _ id) ty = bindVar id ty
addBindingsForPat (ILPatWildcard _) _ = return ()
addBindingsForPat (ILPatInt _ _) _ = return ()
addBindingsForPat (ILPatBool _ _) _ = return ()
addBindingsForPat (ILPatStr _ _) _ = return ()
addBindingsForPat (ILPatChar _ _) _ = return ()

addBindingsForPat patE ty =
  throwError $ ErrPatMatchBindingFail patE ty


-- Map each function parameter to a fresh id,
-- if this is an function syn ty
freshMethodParamIds :: UntypedUniq SynTy -> Checked [UniqId]
freshMethodParamIds (SynTyArrow _ paramTys _) = mapM (\_ -> makeFresh "arg") paramTys


-- Replace all occurrences of the first type id with the second,
-- in the given synTy
replaceTyIdIn :: UniqId -> UniqId -> UntypedUniq SynTy -> UntypedUniq SynTy
replaceTyIdIn oldTyId newTyId (SynTyArrow p paramTys retTy) =
  SynTyArrow p (map replace paramTys) $ replace retTy
  where
    replace = replaceTyIdIn oldTyId newTyId

replaceTyIdIn oldTyId newTyId (SynTyList p elemTy)
  = SynTyList p $ replaceTyIdIn oldTyId newTyId elemTy

replaceTyIdIn oldTyId newTyId (SynTyRef p qid@(Id ip tyRefId) synTyArgs)
  | tyRefId == oldTyId = SynTyRef p (Id ip newTyId) $ map replace synTyArgs
  | otherwise          = SynTyRef p qid $ map replace synTyArgs
  where
    replace = replaceTyIdIn oldTyId newTyId


methodSelector :: Typed IL -> MethodId -> Checked (Typed IL)
methodSelector dictIl methodId = do
  protoId <- envLookupOrFail methodEnv methodId
  methods <- liftM sort $ envLookupOrFail protoEnv protoId
  fId <- makeFresh "f"
  let d = ilNodeData dictIl
  let ilPat = ILPatTuple d (map (\targetMethodId -> if targetMethodId == methodId
                                                    then ILPatId d fId
                                                    else ILPatWildcard d
                                )
                            methods)
  return $ ILSwitch d dictIl [ILCase d ilPat $ ILRef d fId]


insertDictionaryParams :: Typed IL -> Ty -> Checked (Typed IL)
insertDictionaryParams funDef@(ILFunDef fty id paramIds bodyE) ty
    | not (null ctx) =
      do dictParamIds <- mapMi (\i (cty, cProtoId) ->
                                  do paramId <- makeFresh ("d" ++ show i)
                                     bindDictParam cProtoId cty paramId
                                     return paramId)
                               ctx
         return $ ILFunDef fty id dictParamIds $ ILFun fty paramIds bodyE
    | otherwise = return funDef
  where ctx = context ty


tc :: Untyped IL -> Checked (Ty, Typed IL)
tc (ILUnit p) = return (mtApp TyConUnit, ILUnit (OfTy p (mtApp TyConUnit)))
tc (ILFail p msg) = do
  ty <- freshMeta
  return (ty, ILFail (OfTy p ty) msg)

tc (ILMain p [paramId] bodyE) = do
  oldVarEnv <- markVarEnv
  bindVar paramId $ tyList tyStr
  (bodyTy, bodyE') <- tc bodyE
  unify bodyTy tyUnit `reportErrorAt` p
  restoreVarEnv oldVarEnv
  main <- resolve $ ILMain (OfTy p tyMain) [paramId] bodyE'
  return (tyUnit, main)

tc ilMain@ILMain{} = throwError (ErrWrongMainArity ilMain) `reportErrorAt` ilNodeData ilMain

tc (ILRef p id) = do
  ty <- lookupVar id `reportErrorAt` p
  ty' <- instantiate ty
  -- If a method, return a method placeholder
  isAMethod <- isMethod id
  if isAMethod
  then do metas <- freeMetas ty'
          let meta = head metas
          return (ty', ILPlaceholder (OfTy p ty') $ PlaceholderMethod id meta)
  else
    if isOverloaded ty'
    then let ctx = context ty'
             phs = map (\(cty, cProtoId) -> ILPlaceholder (OfTy p tyUnit) $ PlaceholderDict cProtoId cty) ctx
         in return (ty', (ILApp (OfTy p ty') (ILRef (OfTy p ty') id) phs))
    else
      return (ty', ILRef (OfTy p ty') id)

tc (ILStr p s) = return (tyStr, ILStr (OfTy p tyStr) s)
tc (ILChar p s) = return (tyChar, ILChar (OfTy p tyChar) s)
tc (ILBool p b) = return (tyBool, ILBool (OfTy p tyBool) b)
tc (ILInt p n) = return (tyInt, ILInt (OfTy p tyInt) n)

tc (ILCons p headE listE) = do
  (tyListE, listE') <- tc listE
  (tyHeadE, headE') <- tc headE
  tyListE' <- instantiate tyListE
  listTy <- case tyListE' of
              TyApp TyConList _ ->
                unify tyListE' (TyApp TyConList [tyHeadE]) `reportErrorAt` p >>= subst
              _ -> -- Failure case, we unify expecting a (ListOf(<headTy>)) to fail
                unify (TyApp TyConList [tyHeadE]) tyListE' `reportErrorAt` p
  return (listTy, ILCons (OfTy p listTy) headE' listE')


tc (ILApp p ratorE randEs) = do
  (fty, ratorE') <- tc ratorE
  (randTys, randEs') <- mapAndUnzipM tc randEs
  retTyMeta@(TyMeta [] retTyMetaId) <- freshMeta
  fty' <- withFailPos' p $ unify fty $ TyApp TyConArrow $ randTys ++ [retTyMeta]
  let (TyApp TyConArrow arrowTys) = stripContext fty'
      ty = case reverse arrowTys of
              []      -> tyUnit
              retTy:_ -> retTy
      arity = length arrowTys - 1
      argLen = length randEs
  if arity /= argLen
  then throwError (ErrWrongArity ratorE' arity argLen) `reportErrorAt` p
  else do ty' <- subst ty
          -- fty'' <- subst fty'
          -- traceM ("tc ILApp, fty'': " ++ show fty'')
          -- if isOverloaded fty''
          -- then let ctx = context fty''
          --          phs = map (\(cty, cProtoId) -> ILPlaceholder (OfTy p tyUnit) $ PlaceholderDict cProtoId cty) ctx
          --      in return (ty', ILApp (OfTy p ty') (ILApp (OfTy p fty'') ratorE' phs) randEs')
          -- else
          return (ty', ILApp (OfTy p ty') ratorE' randEs')

tc (ILPrim p prim) = do
    primTy <- case prim of
                PrimPrintln -> do
                  paramMeta <- freshMeta
                  return $ TyApp TyConArrow [paramMeta, tyUnit]
                PrimReadln -> return $ TyApp TyConArrow [tyStr]
                PrimCharEq -> return $ TyApp TyConArrow [tyChar, tyChar, tyBool]
                PrimCharToInt -> return $ TyApp TyConArrow [tyChar, tyInt]
                PrimIntAdd -> intArithTy
                PrimIntSub -> intArithTy
                PrimIntDiv -> intArithTy
                PrimIntMul -> intArithTy
                PrimIntMod -> intArithTy
                PrimIntEq -> intCmpTy
                PrimIntLt -> intCmpTy
                PrimIntLeq -> intCmpTy
                PrimIntGt -> intCmpTy
                PrimIntGeq -> intCmpTy
                PrimUnknown id -> throwError (ErrPrimUnknown id) `reportErrorAt` p
    return (primTy, ILPrim (OfTy p primTy) prim)
  where intArithTy = return $ TyApp TyConArrow [tyInt, tyInt, tyInt]
        intCmpTy   = return $ TyApp TyConArrow [tyInt, tyInt, tyBool]

tc (ILAssign p patE (ILFun funP paramIds bodyE)) =
  case patE of
    ILPatId patP id -> do
      paramMetas <- mapM (const freshMeta) paramIds
      bodyTyMeta <- freshMeta
      let paramsAndTys = zip paramIds paramMetas
          fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
      oldVarEnv <- markVarEnv
      mapM_ (uncurry bindVar) paramsAndTys
      (bodyTy, bodyE') <- tc bodyE
      unify bodyTyMeta bodyTy
      restoreVarEnv oldVarEnv
      fty' <- generalize fty
      bindVar id fty'
      patEMeta <- freshMeta
      return (tyUnit, ILAssign (OfTy p tyUnit)
                               (ILPatId (OfTy patP patEMeta) id)
                               (ILFun (OfTy funP fty') paramIds bodyE'))
    _ ->
      throwError ErrInvalidFunPattern

tc (ILAssign p patE rhe) = do
  oldVarEnv <- markVarEnv
  (rheTy, rhe') <- tc rhe
  (patTy, patE') <- tcPatExp patE
  unify patTy rheTy `reportErrorAt` p
  rheTy' <- generalize rheTy
  addBindingsForPat patE rheTy'
  return (tyUnit, ILAssign (OfTy p tyUnit) patE' rhe')

tc (ILTuple p es) = do
  eMetas <- mapM (const freshMeta) es
  (tys, es') <- mapAndUnzipM tc es
  ty <- unify (TyApp TyConTuple tys) (TyApp TyConTuple eMetas) `reportErrorAt` p
  return (ty, ILTuple (OfTy p ty) es')

tc (ILSwitch p e clauses) = do
  (tyE, e') <- tc e
  (cTys, clauses') <-
    mapAndUnzipM (\(ILCase cp patE ce) ->
                      do oldVarEnv <- markVarEnv
                         (pty, patE') <- tcPatExp patE
                         pty' <- unify tyE pty `reportErrorAt` ilNodeData patE
                         (retTy, ce') <- tc ce
                         restoreVarEnv oldVarEnv
                         return (retTy, ILCase (OfTy cp retTy) patE' ce'))
                  clauses
  ty <- unifyAll cTys `reportErrorAt` p >>= instantiate
  return (ty, ILSwitch (OfTy p ty) e' clauses')

tc (ILList p es) = do
  (tys, es') <- mapAndUnzipM tc es
  elemTy <- unifyAll tys `reportErrorAt` p
  let ty = TyApp TyConList [elemTy]
  return (ty, ILList (OfTy p ty) es')

tc (ILFun p paramIds bodyE) = do
  paramMetas <- mapM (\paramId -> do { ty <- freshMeta; bindVar paramId ty; return ty }) paramIds
  bodyTyMeta <- freshMeta
  let fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
  oldVarEnv <- markVarEnv
  (bodyTy, bodyE') <- tc bodyE
  unify bodyTyMeta bodyTy `reportErrorAt` p
  restoreVarEnv oldVarEnv
  fty' <- subst fty
  return (fty', ILFun (OfTy p fty') paramIds bodyE')

-- make-adt is only generated by the typechecker and should never
-- consume it
tc (ILMakeAdt p id i es) = throwError $ ErrNotImplemented "tc for ILMakeAdt"

tc (ILStruct p id fieldInitEs) = do
  ty <- tcTy $ SynTyRef p (Id p id) []
  initIndices <- mapM (\f@(ILFieldInit fid _) -> do
                          ind <- lookupFieldIndex id fid
                          return (f, ind))
                      fieldInitEs
  let sorted = fst $ unzip $ sortBy (\a b -> compare (snd a) (snd b)) initIndices
  let initEs = map (\(ILFieldInit _ e) -> e) sorted
  tc $ ILApp p (ILRef p id) initEs

-- We must bind the name before typechecking
-- the right-hand side (otherwise recursive
-- applications will fail)
-- We do this by binding the name in the
-- var environment to the type:
--
-- App(Arrow, [meta1, ..., metaN])
--
-- Where meta1 ... meta(N-1) are (fresh) metavariables
-- for parameters, and metaN is a fresh metavariable
-- representing the return type.
-- We also prohibit pattern-match bindings
-- for functions here (require simple identifier patterns)
tc (ILFunDef p id paramIds bodyE) = do
  paramMetas <- mapM (const freshMeta) paramIds
  bodyTyMeta <- freshMeta
  let paramsAndTys = zip paramIds paramMetas
      fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
  oldVarEnv <- markVarEnv
  mapM_ (uncurry bindVar) paramsAndTys
  bindVarIfNotBound id fty
  (bodyTy, bodyE') <- tc bodyE
  retTy <- unify bodyTyMeta bodyTy
  restoreVarEnv oldVarEnv
  fty' <- generalize fty
  -- traceM ("(" ++ show id ++ ") fty': " ++ show fty')
  bindVar id fty'
  let funDef = ILFunDef (OfTy p fty') id paramIds bodyE'
  funDef' <- insertDictionaryParams funDef fty'
  -- Can resolve here.  For every placeholder,
  -- the meta in the placeholder type can be checked
  -- to see what it's bound to in the meta env.
  -- If it's bound to a TyVar, we must look up the
  -- entry in the dict param env (it will resolve to a dict param).
  -- Otherwise it should be in the impl env since this meta
  -- should be bound to a concrete type.
  -- If neither of these conditions hold an ambiguity.
  funDef'' <- resolve funDef' 
  return (tyUnit, funDef'')

-- Monomorphic case
tc (ILWithAnn p (TyAnn _ id [] synTy straints) e)
  | not (null straints) = throwError (ErrInvalidConstraints id) `reportErrorAt` p
  | otherwise = do
      oldMetaEnv <- markMetaEnv
      givenTy <- tcTy synTy
      (_, e') <- tc e
      inferredTy <- lookupVar id `reportErrorAt` ilNodeData e
      givenTy' <- instantiate givenTy
      inferredTy' <- instantiate inferredTy
      ty <- unify givenTy' inferredTy' `reportErrorAt` p

      restoreMetaEnv oldMetaEnv
      generalize ty >>= bindVar id
      return (ty, e')

-- Polymorphic case
tc (ILWithAnn p (TyAnn _ id tyParamIds synTy straints) e) = do
  oldMetaEnv <- markMetaEnv
  mapM_ (\tyParamId -> exportTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  let ctx = map (\(Constraint _ tyId protoId) -> (TyVar [] tyId, protoId)) straints
  givenTy <- tcTy synTy
  let givenTy' = distributeContext $ TyPoly tyParamIds ctx givenTy
  (_, e') <- tc e
  inferredTy <- lookupVar id `reportErrorAt` ilNodeData e
  givenTy'' <- instantiate givenTy'
  inferredTy' <- instantiate inferredTy
  ty <- unify givenTy'' inferredTy' `reportErrorAt` p

  restoreMetaEnv oldMetaEnv
  generalize ty >>= bindVar id
  return (ty, e')


tc (ILProtoDec p protoId tyParamId straints tyAnns) = do
    bindProtoDec protoId $ map bindingId tyAnns
    mapM bindMethod tyAnns
    modifyTC (\tcEnv -> tcEnv { impEnv = Map.insert protoId Map.empty (impEnv tcEnv) })

    return (tyUnit, ILBegin (OfTy p tyUnit) [])
  where
    bindMethod (TyAnn tp methodId _ synTy _) = do
      freshTyParamId <- makeFresh "a"
      bindMethodId methodId protoId
      exportTy freshTyParamId $ TyConTyVar freshTyParamId
      let synTy' = replaceTyIdIn tyParamId freshTyParamId synTy
      methodTy <- tcTy synTy'
      let funTy = distributeContext $ TyPoly [freshTyParamId] [(TyVar [] freshTyParamId, protoId)] methodTy
      bindVar methodId funTy

tc (ILProtoImp p synTy protoId straints bodyEs) = do
    tyCon       <- (liftM simplify . tcTycon) synTy
    instanceEnv <- envLookupOrFail impEnv protoId `reportErrorAt` p
    let maybeImp = Map.lookup tyCon instanceEnv
    case maybeImp of
      Just _ -> throwError $ ErrProtocolAlreadyImplemented protoId tyCon
      _ -> do
        methods <- liftM (snd . unzip) $ mapM (tcProtoMethod protoId tyCon) bodyEs'
        let dictTy = tyTuple []
            dict = foldl (addMethodToDict protoId tyCon) (ILTuple (OfTy p dictTy) []) methods
        theImpEnv <- getsTC impEnv
        let instanceEnv' = Map.insert tyCon dict instanceEnv
            theImpEnv'   = Map.insert protoId instanceEnv' theImpEnv
        modifyTC (\tcEnv -> tcEnv { impEnv = theImpEnv' })

        return (tyUnit, ILBegin (OfTy p tyUnit) methods)
  where
    bodyEs' = sortBindings bodyEs

tc (ILBegin p es) = do
  (ty, es') <- tcEs es
  return (ty, ILBegin (OfTy p ty) es')

tc e = throwError $ ErrInterpFailure $ printf "In function tc: %s" $ show e


tcEs :: [Untyped IL] -> Checked (Ty, [Typed IL])
tcEs [] = return (mtApp TyConUnit, [])
tcEs es = do
  (tys, es') <- mapAndUnzipM tc es
  return (last tys, es')


sortBindings :: [IL a] -> [IL a]
sortBindings es = sortOn ilBindingId es


addMethodToDict :: ProtocolId -> TyCon -> IL a -> IL a -> IL a
addMethodToDict protoId tyCon (ILTuple p es) methodIL =
  ILTuple p (es ++ [ILRef p $ ilBindingId methodIL])


protoMethodImplId :: ProtocolId -> TyCon -> UniqId -> Checked UniqId
protoMethodImplId protoId implementingTyCon methodId =
  makeFresh (show protoId ++ "." ++ show methodId ++ "@" ++ show implementingTyCon)


tcProtoMethod :: ProtocolId -> TyCon -> Untyped IL -> Checked (Ty, Typed IL)
tcProtoMethod protoId implementingTyCon (ILFunDef p id paramIds bodyE) = do
  isAMethod <- isMethod id
  unless isAMethod $ throwError $ ErrUnknownMethodId id protoId
  funId <- protoMethodImplId protoId implementingTyCon id
  (_, funDef@(ILFunDef _ _ _ bodyE')) <- tc $ ILFunDef p funId paramIds bodyE
  funTy <- (lookupVar >=> instantiate) funId
  declaredMethodTy <- (lookupVar >=> instantiate) id
  unify declaredMethodTy funTy `reportErrorAt` p
  return (tyUnit, ILFunDef (OfTy p funTy) funId paramIds bodyE')

tcProtoMethod protoId implementingTyCon (ILWithAnn p (TyAnn _ annId tyParamIds synTy straints) (ILFunDef fp fid paramIds bodyE)) = do
  isAMethod <- isMethod annId
  unless isAMethod $ throwError $ ErrUnknownMethodId annId protoId
  declaredMethodTy <- lookupVar annId
  funId <- protoMethodImplId protoId implementingTyCon annId
  let def = ILWithAnn p (TyAnn p funId tyParamIds synTy straints) $ ILFunDef fp funId paramIds bodyE
  (_, def') <- tc def
  funTy <- lookupVar funId
  declaredMethodTy' <- instantiate declaredMethodTy
  unify declaredMethodTy' funTy `reportErrorAt` p
  return (tyUnit, def')

tcProtoMethod protoId _ _ = throwError $ ErrInterpFailure $ "Unsupported definition form in protocol implementation for " ++ show protoId


tcTyDecs :: [UntypedUniq TypeDec] -> Checked [Typed IL]
tcTyDecs tyDecs = do
    ilSeqs <- mapM (\(id, tyDec) -> do
                (tyCon, ilSeq) <- tcTyDec tyDec
                exportTy id tyCon --TODO: this seems redundant
                return ilSeq)
              idsAndTyDecs
    return $ concat ilSeqs
  where
    idsAndTyDecs = mapMaybe (\tyDec -> do { id <- getTypeDecId tyDec; return (id, tyDec) }) tyDecs


tcCompUnit :: Untyped ILCompUnit -> Bool -> Checked (Ty, Typed ILCompUnit)
tcCompUnit (ILCompUnit p tyDecs es) bindForwardReferences = do
  when bindForwardReferences $ mapM_ makeSymTables tyDecs
  ilFromTyDecs <- tcTyDecs tyDecs
  (ty, es') <- tcEs es
  ty' <- generalize ty
  return (ty', ILCompUnit (OfTy p ty') [] (ilFromTyDecs ++ es'))


makeSymTables :: UntypedUniq TypeDec -> Checked ()
makeSymTables tyDec =
    case id of
      Just id -> exportTy id $ TyConTyFun tyParams $ TyRef $ Id p id
      _       -> return ()
  where id = getTypeDecId tyDec
        tyParams = getTypeDecParams tyDec
        p = nodeData tyDec


simplify :: TyCon -> TyCon
simplify (TyConTyFun [] (TyApp tyCon [])) = simplify tyCon
simplify tyCon = tyCon


fullyAppliedMonoTyCon :: Ty -> Maybe TyCon
fullyAppliedMonoTyCon (TyApp (TyConTyFun [] (TyApp tyCon [])) []) = Just tyCon
fullyAppliedMonoTyCon (TyApp tyCon []) = Just tyCon
fullyAppliedMonoTyCon _ = Nothing


class ResolveOverloads a d where
  resolve :: a d -> Checked (a d)


instance ResolveOverloads ILCase CheckedData where
  resolve (ILCase d patE body) = do
    body' <- resolve body
    return $ ILCase d patE body'


resolveDict :: Ty -> ProtocolId -> Checked (Typed IL)
resolveDict ty protoId = do
  theDictParamEnv <- getsTC dictParamEnv
  -- traceM $ showHum theDictParamEnv
  -- traceM ("There are " ++ show (Map.size theDictParamEnv) ++ " entries in the dict param env")
  ty' <- subst ty
  let maybeDictParamId = Map.lookup (protoId, ty') theDictParamEnv
  case maybeDictParamId of
    Just dictParamId -> return $ ILRef (OfTy mtSourcePos tyUnit) dictParamId
    _                ->
      do thisProtoImpEnv <- envLookupOrFail impEnv protoId
         -- traceM "thisProtoImpEnv:"
         -- traceM $ showHum thisProtoImpEnv
         -- traceM ("ty': " ++ show ty')
         let maybeTyCon = fullyAppliedMonoTyCon ty'
         -- traceM ("maybeTyCon: " ++ show maybeTyCon)
         case maybeTyCon of
           Just tyCon ->
             let maybeDictIl = Map.lookup (simplify tyCon) thisProtoImpEnv
             in case maybeDictIl of
                  Just dictIl -> return dictIl
                  _           -> throwError $ ErrCannotResolveProtocolImp ty protoId
           _          ->
              throwError $ ErrCannotResolveProtocolImp ty protoId


instance ResolveOverloads IL CheckedData where
  resolve (ILPlaceholder (OfTy p _) (PlaceholderMethod methodId ty)) = do
    ty' <- subst ty
    protoId <- envLookupOrFail methodEnv methodId
    dictIl <- resolveDict ty' protoId `reportErrorAt` p
    methodSelector dictIl methodId

  resolve (ILPlaceholder (OfTy p pty) (PlaceholderDict protoId ty)) = do
    resolveDict ty protoId `reportErrorAt` p

  resolve (ILCons d a b) = do
    a' <- resolve a
    b' <- resolve b
    return $ ILCons d a' b'

  resolve (ILApp d rator rands) = do
    rator' <- resolve rator
    rands' <- mapM resolve rands
    return $ ILApp d rator' rands'

  resolve (ILFunDef d funId paramIds bodyE) = do
    bodyE' <- resolve bodyE
    return $ ILFunDef d funId paramIds bodyE'

  resolve (ILFun d paramIds bodyE) = do
    bodyE' <- resolve bodyE
    return $ ILFun d paramIds bodyE'

  resolve (ILMain d argIds bodyE) = do
    bodyE' <- resolve bodyE
    return $ ILMain d argIds bodyE'

  resolve (ILBegin d es) = do
    es' <- mapM resolve es
    return $ ILBegin d es'

  resolve (ILSwitch d e cases) = do
    e' <- resolve e
    cases' <- mapM resolve cases
    return $ ILSwitch d e' cases' 

  resolve e = return e


instance ResolveOverloads ILCompUnit CheckedData where
  resolve (ILCompUnit d typeDecs es) = do
    es' <- mapM resolve es
    return $ ILCompUnit d typeDecs es'


type Checked a = CompilerPass CompilerEnv a


getTC :: Checked TCEnv
getTC = gets tcEnv


getsTC :: (TCEnv -> a) -> Checked a
getsTC f = gets (f . tcEnv)


putTC :: TCEnv -> Checked ()
putTC tcEnv = modify (\cEnv -> cEnv { tcEnv = tcEnv })


modifyTC :: (TCEnv -> TCEnv) -> Checked ()
modifyTC f = modify (\cEnv -> cEnv { tcEnv = f (tcEnv cEnv) })


runTypecheck :: Untyped ILCompUnit -> Checked (Ty, Typed ILCompUnit)
runTypecheck cu = do
  (ty, typedIL) <- tcCompUnit cu True
  (ty', typedIL') <- tcCompUnit cu False
  -- typedIL'' <- resolve typedIL'
  return (ty', typedIL')
