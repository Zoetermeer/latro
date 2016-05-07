{-# LANGUAGE BangPatterns #-}
module Types where

import AlphaConvert
import Common
import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State.Strict
import Data.Either.Utils (maybeToEither)
import Data.List
import qualified Data.Map.Strict as Map
import Data.Maybe (fromMaybe, isNothing)
import qualified Data.Set as Set
import Debug.Trace (trace, traceM, traceShowId, traceShowM)
import Errors
import Semant
import Text.Printf (printf)


traceIt :: Show a => a -> a
traceIt v = trace (show v) v


type VarEnv = Map.Map UniqId Ty


data TCEnv = TCEnv
  { curModule :: TCModule
  , varEnv :: VarEnv
  , alphaEnv :: AlphaEnv
  , polyEnv :: Map.Map UniqId Ty
  , metaEnv :: Map.Map UniqId Ty
  , inTopLevelScope :: Bool
  }
  deriving (Eq)


mtEnv :: AlphaEnv -> TCEnv
mtEnv alphaEnv =
  TCEnv
    { curModule = mtTCModule
    , varEnv = Map.empty
    , alphaEnv = alphaEnv
    , polyEnv = Map.empty
    , metaEnv = Map.empty
    , inTopLevelScope = True
    }

showHum :: Map.Map UniqId Ty -> String
showHum map =
  Map.foldlWithKey
    (\str key val -> str ++ "\n" ++ show key ++ " --> " ++ show val)
    ""
    map

type Checked a = ExceptT Err (State TCEnv) a


-- Debugging
traceMetaEnv :: Checked ()
traceMetaEnv = do
  traceM "META ENV:  "
  metaEnv <- gets metaEnv
  traceM $ showHum metaEnv

traceVarEnv :: Checked ()
traceVarEnv = do
  traceM "VAR ENV:  "
  varEnv <- gets varEnv
  traceM $ showHum varEnv

tracePolyEnv :: Checked ()
tracePolyEnv = do
  traceM "POLY Env:  "
  polyEnv <- gets polyEnv
  traceM $ showHum polyEnv


-- Convenience methods for manipulating the environment
newContextWith :: (TCEnv -> TCEnv) -> Checked TCEnv
newContextWith fupdate = do
  oldEnv <- get
  modify fupdate
  return oldEnv


pushNewModuleContext :: Checked TCEnv
pushNewModuleContext =
  newContextWith (\tcEnv -> tcEnv { curModule = mtTCModule })


-- A new var env needs to close over all
-- bindings in the existing env, so
-- the update function is the identity function
markVarEnv :: Checked VarEnv
markVarEnv =
  gets varEnv


restoreVarEnv :: VarEnv -> Checked ()
restoreVarEnv varEnv =
  modify (\tcEnv -> tcEnv { varEnv = varEnv })


restoreContext :: TCEnv -> Checked ()
restoreContext tcEnv = put tcEnv


putModuleVarBinding :: UniqId -> Ty -> Checked ()
putModuleVarBinding id ty =
  modify (\tcEnv -> tcEnv { curModule = addModuleVar (curModule tcEnv) id ty })


bindTy :: UniqId -> TyCon -> Checked ()
bindTy id tyCon = do
  modify (\tcEnv -> tcEnv { curModule = addModuleTy (curModule tcEnv) id tyCon })


bindVar :: UniqId -> Ty -> Checked ()
bindVar id ty = do
  isTopLevel <- gets inTopLevelScope
  modify (\tcEnv -> tcEnv { varEnv = Map.insert id ty (varEnv tcEnv) })
  if isTopLevel
  then putModuleVarBinding id ty
  else return ()


bindVarIfNotBound :: UniqId -> Ty -> Checked ()
bindVarIfNotBound id ty = do
  isTopLevel <- gets inTopLevelScope
  modify (\tcEnv -> tcEnv { varEnv = Map.insertWith (\new old -> old) id ty (varEnv tcEnv) })
  if isTopLevel
  then putModuleVarBinding id ty
  else return ()


putPatBinding :: UniqId -> Ty -> Checked ()
putPatBinding id ty = do
  modify (\tcEnv -> tcEnv { curModule = addModulePat (curModule tcEnv) id ty })


bindPoly :: UniqId -> Ty -> Checked ()
bindPoly id ty = do
  modify (\tcEnv -> tcEnv { polyEnv = Map.insert id ty (polyEnv tcEnv) })


bindMeta :: UniqId -> Ty -> Checked ()
bindMeta id (TyMeta otherMetaId) = do
  newMeta <- freshMeta
  modify (\tcEnv ->
            let env = metaEnv tcEnv
                metaEnv' = Map.insert id newMeta env
                metaEnv'' = Map.insert otherMetaId newMeta metaEnv'
            in
              tcEnv { metaEnv = metaEnv'' })

bindMeta id ty = do
  modify (\tcEnv -> tcEnv { metaEnv = Map.insert id ty (metaEnv tcEnv) })


mtApp :: TyCon -> Ty
mtApp tyCon = TyApp tyCon []


-- Shortcuts for primitive types
tyInt :: Ty
tyInt = mtApp TyConInt

tyBool :: Ty
tyBool = mtApp TyConBool

tyStr :: Ty
tyStr = mtApp TyConString

tyUnit :: Ty
tyUnit = mtApp TyConUnit


makeFresh :: RawId -> Checked UniqId
makeFresh raw = do
  alphaEnv <- gets alphaEnv
  let (uniqId, alphaEnv') = fresh raw alphaEnv
  modify (\tcEnv -> tcEnv { alphaEnv = alphaEnv' })
  return uniqId


freshId :: Checked UniqId
freshId = makeFresh "t"


freshMeta :: Checked Ty
freshMeta = do
  (UniqId n raw) <- makeFresh "meta"
  return $ TyMeta $ UniqId n $ printf "meta@%i" n


envLookup :: (TCEnv -> Map.Map UniqId a) -> UniqId -> Checked (Maybe a)
envLookup getTable id = do
  table <- gets getTable
  return $ Map.lookup id table


envLookupOrFail :: (TCEnv -> Map.Map UniqId a) -> UniqId -> Checked a
envLookupOrFail getTable id = do
  result <- envLookup getTable id
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) result


lookupMeta :: UniqId -> Checked (Maybe Ty)
lookupMeta id = do
  result <- envLookup metaEnv id
  case result of
    Just ty -> do { ty' <- subst ty; return $ Just ty' }
    _ -> return result


isFreeMeta :: Ty -> Checked Bool
isFreeMeta (TyMeta id) = do
  ty <- lookupMeta id
  return $ isNothing ty


markPolyEnv :: Checked (Map.Map UniqId Ty)
markPolyEnv = gets polyEnv >>= return


restorePolyEnv :: Map.Map UniqId Ty -> Checked ()
restorePolyEnv env = modify (\tcEnv -> tcEnv { polyEnv = env })


markMetaEnv :: Checked (Map.Map UniqId Ty)
markMetaEnv = gets metaEnv >>= return


restoreMetaEnv :: Map.Map UniqId Ty -> Checked ()
restoreMetaEnv env = modify (\tcEnv -> tcEnv { metaEnv = env })


lookupPoly :: UniqId -> Checked (Maybe Ty)
lookupPoly id = envLookup polyEnv id


lookupTyIn :: TCModule -> UniqId -> Checked TyCon
lookupTyIn mod id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id $ types mod


lookupVarIn :: TCModule -> UniqId -> Checked Ty
lookupVarIn mod id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id $ vars mod


lookupPatIn :: TCModule -> UniqId -> Checked Ty
lookupPatIn mod id =
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id) $ Map.lookup id $ patFuns mod


lookupTy :: UniqId -> Checked TyCon
lookupTy id = do
  curMod <- gets curModule
  lookupTyIn curMod id


lookupQual :: QualifiedId UniqId -> Checked Ty
lookupQual (Id id) = lookupVar id
lookupQual (Path qid id) = do
  v <- lookupQual qid
  case v of
    TyApp (TyConModule _ mod) _ ->
      hoistEither $ maybeToEither (ErrUndefinedMember id) $ Map.lookup id $ vars mod
    TyApp (TyConStruct fieldNames) fTys ->
      do fIndex <- hoistEither $ maybeToEither (ErrUndefinedMember id) $ elemIndex id fieldNames
         return $ fTys !! fIndex


lookupTyQual :: QualifiedId UniqId -> Checked TyCon
lookupTyQual (Id id) = lookupTy id
lookupTyQual (Path qid id) = do
  ty <- lookupQual qid
  case ty of
    TyApp (TyConModule _ mod) _ -> lookupTyIn mod id
    _ -> throwError $ ErrInvalidModulePath qid


lookupVar :: UniqId -> Checked Ty
lookupVar id = envLookupOrFail varEnv id


occursIn :: Ty -> Ty -> Bool
occursIn _ _ = False


expand :: Ty -> Checked Ty
expand (TyApp (TyConTyFun tyParamIds ty) tyArgs) = do
  mapM_ (uncurry bindPoly) $ zip tyParamIds tyArgs
  ty' <- subst ty
  expand ty'
expand (TyApp (TyConUnique _ tyCon) tyArgs) =
  expand (TyApp tyCon tyArgs)
expand meta@(TyMeta id) = do
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

allMetaIdsInTyCon :: TyCon -> [UniqId]
allMetaIdsInTyCon (TyConTyFun _ ty) = allMetaIdsIn ty
allMetaIdsInTyCon (TyConUnique _ tyCon) = allMetaIdsInTyCon tyCon
allMetaIdsInTyCon _ = []


allMetaIdsIn :: Ty -> [UniqId]
allMetaIdsIn (TyApp tyCon tyArgs) =
  allMetaIdsInTyCon tyCon ++ concat (map allMetaIdsIn tyArgs)

allMetaIdsIn (TyPoly _ ty) = allMetaIdsIn ty
allMetaIdsIn (TyMeta id) = [id]
allMetaIdsIn _ = []


referencedMetaIds :: UniqId -> Checked [UniqId]
referencedMetaIds metaId = do
  result <- lookupMeta metaId
  refdIds <- case result of
    Just ty ->
      case ty of
        TyMeta id -> referencedMetaIds id
        _ -> return []
    _ -> return []
  return (metaId : refdIds)


allMetasInEnv :: Checked [UniqId]
allMetasInEnv = do
  varEnv <- gets varEnv
  let allTys = snd $ unzip $ Map.toList varEnv
      metaTys  = filter (\ty -> case ty of
                                  TyMeta _ -> True
                                  _ -> False)
                        allTys
      allMetaIds = map (\(TyMeta id) -> id) metaTys
  allBoundMetaIdSets <- mapM referencedMetaIds allMetaIds
  return $ concat allBoundMetaIdSets


freeMetas :: Ty -> Checked [UniqId]
freeMetas ty =
  let occurringMetaIds = allMetaIdsIn ty
  in do allMetaIds <- allMetasInEnv
        let occursSet = Set.fromList occurringMetaIds
            envSet = Set.fromList allMetaIds
            freeSet = Set.difference occursSet envSet
        return $ Set.toList freeSet


trimUnusedPolyParams :: Ty -> Checked Ty
trimUnusedPolyParams (TyPoly [] ty) = return ty
trimUnusedPolyParams (TyPoly tyParamIds ty) =
    case tyParamIds' of
      [] -> return ty
      _ -> return $ TyPoly tyParamIds' ty
  where
    allTyConVarIds tyCon =
      case tyCon of
        TyConTyVar id -> [id]
        TyConTyFun _ ty -> allTyVarIds ty
        _ -> []
    allTyVarIds ty =
      case ty of
        TyApp tyCon tys -> allTyConVarIds tyCon ++ concat (map allTyVarIds tys)
        TyPoly _ ty -> allTyVarIds ty
        TyVar id -> [id]
        TyMeta id -> []
    paramIdSet = Set.fromList tyParamIds
    usedParamIdSet = Set.fromList $ allTyVarIds ty
    tyParamIds' = Set.toList $ Set.intersection paramIdSet usedParamIdSet

trimUnusedPolyParams ty = return ty


generalize :: Ty -> Checked Ty
generalize ty = do
  ty' <- subst ty
  frees <- freeMetas ty'
  tyParamIds <- mapM (\_ -> freshId) frees
  let metasAndTyParamIds = zip frees tyParamIds
  mapM_ (\(metaId, paramId) -> bindMeta metaId $ TyVar paramId)
        metasAndTyParamIds
  ty'' <- subst ty'
  case tyParamIds of
    [] -> return ty''
    _ ->
      let retTy = TyPoly tyParamIds ty''
      in trimUnusedPolyParams retTy


instantiate :: Ty -> Checked Ty
instantiate (TyPoly tyParamIds ty) = do
  mapM_ (\paramId -> do { meta <- freshMeta; bindPoly paramId meta })
        tyParamIds
  ty' <- subst ty
  return ty'

instantiate ty = return ty


substTyCon :: TyCon -> Checked TyCon
substTyCon (TyConTyFun varIds ty) = do
  ty' <- subst ty
  return $ TyConTyFun varIds ty'

substTyCon tyCon = return tyCon


subst :: Ty -> Checked Ty
subst ty = do
  oldEnv <- markPolyEnv
  ty' <- case ty of
    meta@(TyMeta id) -> do
      maybeTy <- lookupMeta id
      case maybeTy of
        Just ty -> subst ty
        _ -> return meta

    (TyApp (TyConTyFun [] tyRef@(TyRef _)) []) -> do
      tyRef' <- subst tyRef
      return tyRef'

    (TyApp tyCon@(TyConTyFun tyParamIds ty) tyArgs)
      | length tyParamIds == length tyArgs ->
        do mapM_ (uncurry bindPoly) $ zip tyParamIds tyArgs
           subst ty >>= subst
      | otherwise ->
        do madeUpId <- freshId
           throwError $ ErrPartialTyConApp (Id madeUpId) tyCon tyArgs

    (TyApp tyCon tyArgs) -> do
      tyCon' <- substTyCon tyCon
      tyArgs' <- mapM subst tyArgs
      return $ TyApp tyCon' tyArgs'

    var@(TyVar id) -> do
      maybeTy <- lookupPoly id
      case maybeTy of
        Just ty -> return ty
        _ -> return var

    TyPoly tyParamIds ty -> do
      ty' <- subst ty
      return $ TyPoly tyParamIds ty'

    (TyRef (Id id)) -> do
      tyCon <- lookupTy id
      tyCon' <- substTyCon tyCon
      return $ TyApp tyCon' []

  -- restorePolyEnv oldEnv
  return ty'


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
  oldPolyEnv <- markPolyEnv
  oldMetaEnv <- markMetaEnv
  ty <- case (tya, tyb) of
    (a@(TyApp tyconA tyArgsA), b@(TyApp tyconB tyArgsB))
      | tyconA == tyconB ->
        do mapM_ (uncurry unify) $ zip tyArgsA tyArgsB
           return a

    (TyApp (TyConTyFun paramVarIds ty) tyArgs, tyb) -> do
      -- oldPolyEnv <- markPolyEnv
      mapM_ (uncurry bindPoly) $ zip paramVarIds tyArgs
      ty' <- subst ty
      uty <- unify ty' tyb
      -- restorePolyEnv oldPolyEnv
      return uty

    (tya, TyApp (TyConTyFun paramVarIds ty) tyArgs) -> do
      -- oldPolyEnv <- markPolyEnv
      mapM_ (uncurry bindPoly) $ zip paramVarIds tyArgs
      ty' <- subst ty
      uty <- unify tya ty'
      -- restorePolyEnv oldPolyEnv
      return uty

    (TyPoly [] ty, tyb) -> unify ty tyb

    (TyPoly aParamIds aty, (TyPoly bParamIds bty)) ->
      let paramIds = zip bParamIds aParamIds
      in do mapM_ (\(bParamId, aParamId) -> bindPoly bParamId $ TyVar aParamId)
                  paramIds
            bty' <- subst bty
            unify aty bty'

    (meta@(TyMeta metaId), ty) -> do
      metaTy <- lookupMeta metaId
      case metaTy of
        Just mty -> unify mty ty
        _ ->
          case ty of
            TyApp (TyConTyFun _ _) _ -> do
              expanded <- expand ty
              unify meta expanded
            TyMeta rhMetaId ->
              if metaId == rhMetaId
              then return meta
              else do maybeRhMetaTy <- lookupMeta rhMetaId
                      case maybeRhMetaTy of
                        Just rhMetaTy -> unify meta rhMetaTy
                        _ -> do bindMeta metaId ty
                                return ty
            _ ->
              if meta `occursIn` ty
              then throwError $ ErrCircularType ty
              else do
                bindMeta metaId ty
                return ty

    (ta@(TyVar a), tb@(TyVar b)) ->
      if a == b
      then do ty <- lookupPoly a
              return $ fromMaybe ta ty
      else throwError $ ErrCantUnify ta tb

    (ty, meta@(TyMeta _)) -> unify meta ty
    (ta@(TyRef a), tb@(TyRef b)) ->
      if a == b
      then do tyCon <- lookupTyQual a
              return $ TyApp tyCon []
      else unifyFail ta tb

    (tyRef@(TyRef _), ty) -> unify ty tyRef
    (ty, (TyRef qid)) -> do
      tyb <- lookupTyQual qid
      unify ty $ TyApp tyb []

    (ta, tb) -> unifyFail ta tb

  -- restorePolyEnv oldPolyEnv
  -- restoreMetaEnv oldMetaEnv
  return ty


unifyAll :: [Ty] -> Checked Ty
unifyAll [] = freshMeta
unifyAll [ty] = return ty
unifyAll (ta:tb:tys) = do
  ty' <- unify ta tb
  unifyAll (ty':tys)


tcArith :: Exp UniqId -> Exp UniqId -> Checked Ty
tcArith a b = do
  tc a >>= unify tyInt
  tc b >>= unify tyInt
  return tyInt


-- A "syntax-level type" is just an
-- AST representing a type
tcTy :: SynTy UniqId -> Checked Ty
tcTy SynTyInt = return tyInt
tcTy SynTyBool = return tyBool
tcTy SynTyString = return tyStr
tcTy SynTyUnit = return tyUnit
tcTy (SynTyArrow paramTys retTy) = do
  paramTys' <- mapM tcTy paramTys
  retTy' <- tcTy retTy
  return $ TyApp TyConArrow $ paramTys' ++ [retTy']

tcTy (SynTyTuple tyArgs) = do
  tyArgs' <- mapM tcTy tyArgs
  return $ TyApp TyConTuple tyArgs'

tcTy (SynTyList tyArg) = do
  tyArg' <- tcTy tyArg
  return $ TyApp TyConList [tyArg']

tcTy (SynTyRef qid synTyArgs) = do
  tyCon <- lookupTyQual qid
  case tyCon of
    TyConTyVar id' -> return $ TyVar id'
    _ -> do tyArgs <- mapM tcTy synTyArgs
            return $ TyApp tyCon tyArgs


tcAdtAlt :: AdtAlternative UniqId -> Checked (UniqId, Ty)
tcAdtAlt (AdtAlternative id _ synTys) = do
  argTys <- mapM tcTy synTys
  return (id, TyApp TyConTuple argTys)


tcTyDec :: TypeDec UniqId -> Checked TyCon
tcTyDec (TypeDecTy id SynTyInt) = return TyConInt
tcTyDec (TypeDecTy id (SynTyStruct fields)) =
  let (fieldNames, fieldSynTys) = unzip fields
  in do
    fieldTys <- mapM tcTy fieldSynTys
    return $ TyConTyFun [] $ TyApp (TyConStruct fieldNames) fieldTys

tcTyDec (TypeDecAdt id tyParamIds alts) = do
  -- Bind a 'name' type for recursive definitions
  bindTy id $ TyConTyFun tyParamIds $ TyRef $ Id id
  -- Bind a 'tyvar' tycon for each type parameter
  mapM_ (\tyParamId -> bindTy tyParamId $ TyConTyVar tyParamId) tyParamIds
  altNamesTys <- mapM tcAdtAlt alts
  let (names, tys) = unzip altNamesTys
      adtTyCon = TyConUnique id $ TyConTyFun tyParamIds $ TyApp (TyConAdt names) tys
  -- Add a function binding for each constructor
  mapM_ (\(ctorName, (TyApp TyConTuple argTys)) ->
            let ctor = TyPoly tyParamIds $ TyApp TyConArrow (argTys ++ [TyApp adtTyCon (map TyVar tyParamIds)])
            in do bindVar ctorName ctor
                  putPatBinding ctorName ctor)
        altNamesTys
  return adtTyCon


-- The language grammar only permits the expression
-- to be a MemberAccessExp, which is either an application
-- followed by a '. ID', or an atom expression.
-- The reason this must be an expression (and not a qualified identifier)
-- is that we can access some type defined on an inline module, for example.
-- module { type t = ...; }.t { ... };
--
-- Allowing this means the language supports first-class modules.
-- Support should be deferred until we really decide we
-- want that feature.  Until then inline module expressions
-- should be prevented at the syntactic level.
tcTyconExp :: Exp UniqId -> Checked TyCon
tcTyconExp (ExpRef id) = lookupTy id


tcStructFields :: [(UniqId, Ty)] -> [(UniqId, Exp UniqId)] -> Checked Ty
tcStructFields _ [] = return tyUnit
tcStructFields tyFields ((fieldId, fieldExp):fieldInitExps) =
  let maybeField = find (flip ((==) . fst) fieldId) tyFields
  in
    case maybeField of
      Nothing -> throwError $ ErrUndefinedMember fieldId
      Just (matchedFieldId, matchedTy) -> do
        initExpTy <- tc fieldExp
        unify matchedTy initExpTy
        tcStructFields tyFields fieldInitExps


tcPatExp :: PatExp UniqId -> Checked Ty
tcPatExp (PatExpNumLiteral _) = return tyInt
tcPatExp (PatExpBoolLiteral _) = return tyBool
tcPatExp (PatExpTuple es) = do
  eTys <- mapM tcPatExp es
  return $ TyApp TyConTuple eTys

tcPatExp (PatExpAdt id es) = do
  curMod <- gets curModule
  patFunTy <- lookupPatIn curMod id
  eTys <- mapM tcPatExp es
  retTyMeta@(TyMeta retTyMetaId) <- freshMeta
  let gotTy = TyApp TyConArrow $ eTys ++ [retTyMeta]
  patFunTy' <- instantiate patFunTy
  (TyApp TyConArrow eTys) <- unify patFunTy' gotTy
  let (retTy:_) = reverse eTys
  return retTy

tcPatExp (PatExpList es) = do
  eTys <- mapM tcPatExp es
  patElemTy <- unifyAll eTys
  return $ TyApp TyConList [patElemTy]

tcPatExp (PatExpListCons eHd eTl) = do
  hdTy <- tcPatExp eHd
  tlTy <- tcPatExp eTl
  case tlTy of
    TyApp TyConList [elemTy] -> unify elemTy hdTy
    _ -> unify (TyApp TyConList [hdTy]) tlTy

tcPatExp (PatExpId id) = do
  ty <- freshMeta
  -- ty' <- generalize ty
  bindVar id ty
  return ty

tcPatExp PatExpWildcard = freshMeta


addBindingsForPat :: PatExp UniqId -> Ty -> Checked ()
addBindingsForPat (PatExpTuple patEs) (TyApp TyConTuple tyArgs) =
  let componentEsTys = zip patEs tyArgs
  in do mapM_ (uncurry addBindingsForPat) componentEsTys

addBindingsForPat (PatExpAdt _ es) (TyApp (TyConUnique _ _) argTys) =
  mapM_ (uncurry addBindingsForPat) $ zip es argTys

addBindingsForPat (PatExpList elemEs) (TyApp TyConList [tyArg]) =
  let addBindingsForPatWithTy = (flip addBindingsForPat) tyArg
  in do mapM_ addBindingsForPatWithTy elemEs

addBindingsForPat (PatExpList elemEs) (TyPoly [tyParamId] (TyApp TyConList [tyArg])) =
  let elemTy = TyPoly [tyParamId] tyArg
      addBindingsForPatWithTy = (flip addBindingsForPat) elemTy
  in do mapM_ addBindingsForPatWithTy elemEs

addBindingsForPat (PatExpList []) (TyMeta _) = return ()

addBindingsForPat (PatExpListCons hdE tlE) ty@(TyApp TyConList [tyArg]) = do
  addBindingsForPat hdE tyArg
  addBindingsForPat tlE ty

addBindingsForPat (PatExpId id) ty = bindVar id ty
addBindingsForPat PatExpWildcard _ = return ()
addBindingsForPat (PatExpNumLiteral _) _ = return ()
addBindingsForPat (PatExpBoolLiteral _) _ = return ()

addBindingsForPat patE ty =
  throwError $ ErrPatMatchBindingFail patE ty


tc :: Exp UniqId -> Checked Ty
tc ExpUnit = return $ mtApp TyConUnit
tc (ExpRef id) = do
  ty <- lookupVar id
  instantiate ty

tc (ExpString _) = return $ mtApp TyConString
tc (ExpBool _) = return $ mtApp TyConBool
tc (ExpNum _) = return $ mtApp TyConInt

tc (ExpAdd a b) = tcArith a b
tc (ExpSub a b) = tcArith a b
tc (ExpDiv a b) = tcArith a b
tc (ExpMul a b) = tcArith a b

tc (ExpCons headE listE) = do
  tyListE <- tc listE
  tyHeadE <- tc headE
  tyListE' <- instantiate tyListE
  case tyListE' of
    TyApp TyConList _ -> do
      listTy <- unify tyListE' $ TyApp TyConList [tyHeadE]
      subst listTy
    _ -> unify (TyApp TyConList [tyHeadE]) tyListE'

tc (ExpNot e) = do
  te <- tc e >>= unify tyBool
  return tyBool

tc (ExpMemberAccess e id) = do
  eTy <- tc e
  case eTy of
    TyApp (TyConModule tyParamIds mod) [] ->
      do ty <- lookupVarIn mod id
         instantiate ty
    _ -> throwError $ ErrNotImplemented "Failed member access"

tc (ExpApp ratorE randEs) = do
  fty <- tc ratorE
  argTys <- mapM tc randEs
  retTyMeta@(TyMeta retTyMetaId) <- freshMeta
  (TyApp TyConArrow argTys) <- unify fty $ TyApp TyConArrow $ argTys ++ [retTyMeta]
  case reverse argTys of
    [] -> return tyUnit
    retTy:_ -> return retTy

-- module { m1 ... mn } --> App(Module, [tc(m1), ..., tc(mn)]
-- module <t1, ..., tn> { ... } --> Poly([t1, ..., tn], App(Module ...))
tc (ExpModule paramIds es) = do
  oldEnv <- pushNewModuleContext
  mapM_ tc es
  curMod <- gets curModule
  restoreContext oldEnv
  let tyApp = TyApp (TyConModule paramIds curMod) $ map TyVar paramIds
  case paramIds of
    [] -> return tyApp
    _ -> return $ TyPoly paramIds tyApp

-- If the right-hand side is a function,
-- we must bind the name before typechecking
-- the right-hand side (otherwise recursive
-- applications will fail)
-- We do this by binding the name in the
-- var environment to the type:
--
-- App(Arrow, [meta1, ..., metaN])
--
-- Where meta1 ... meta(N-1) are metavariables
-- for parameters, and metaN is a metavariable
-- representing the return type.
-- We also prohibit pattern-match bindings
-- for functions here (require simple identifier patterns)
tc (ExpAssign patE (ExpFun paramIds bodyEs)) =
  case patE of
    PatExpId id -> do
      paramMetas <- mapM (\_ -> freshMeta) paramIds
      bodyTyMeta <- freshMeta
      let paramsAndTys = zip paramIds paramMetas
          fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
      oldVarEnv <- markVarEnv
      mapM_ (uncurry bindVar) paramsAndTys
      bindVar id fty
      bodyTy <- tcEs bodyEs
      unify bodyTyMeta bodyTy
      restoreVarEnv oldVarEnv
      fty' <- generalize fty
      bindVar id fty'
      return tyUnit
    _ ->
      throwError ErrInvalidFunPattern

tc (ExpAssign patE rhe) = do
  oldVarEnv <- markVarEnv
  rheTy <- tc rhe
  patTy <- tcPatExp patE
  unify patTy rheTy
  restoreVarEnv oldVarEnv
  rheTy' <- generalize rheTy
  addBindingsForPat patE rheTy'
  return tyUnit

tc (ExpTuple es) = do
  eMetas <- mapM (\_ -> freshMeta) es
  tys <- mapM tc es
  return $ TyApp TyConTuple tys
  unify (TyApp TyConTuple tys) $ TyApp TyConTuple eMetas

tc (ExpSwitch e clauses) = do
  tyE <- tc e
  cTys <- mapM (\(CaseClause patE ces) ->
                  do oldVarEnv <- markVarEnv
                     pty <- tcPatExp patE
                     pty' <- unify tyE pty
                     -- addBindingsForPat patE pty'
                     retTy <- tcEs ces
                     restoreVarEnv oldVarEnv
                     return retTy)
               clauses
  clauseResultTy <- unifyAll cTys
  instantiate clauseResultTy >>= return

tc (ExpList es) = do
  tys <- mapM tc es
  elemTy <- unifyAll tys
  return $ TyApp TyConList [elemTy]

tc (ExpFun paramIds bodyEs) = do
  paramMetas <- mapM (\_ -> freshMeta) paramIds
  bodyTyMeta <- freshMeta
  let paramsAndTys = zip paramIds paramMetas
      fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
  oldVarEnv <- markVarEnv
  mapM_ (uncurry bindVar) paramsAndTys
  bodyTy <- tcEs bodyEs
  restoreVarEnv oldVarEnv
  unify bodyTyMeta bodyTy
  fty' <- generalize fty
  return fty'

tc (ExpMakeAdt synTy i es) = throwError $ ErrNotImplemented "tc for MakeAdt"

tc (ExpStruct strSynTyE fieldInitEs) = do
  structTyCon <- tcTyconExp strSynTyE
  case structTyCon of
    TyConTyFun [] structTyConApp@(TyApp (TyConStruct fids) ftys) -> do
      tcStructFields (zip fids ftys) fieldInitEs
      return structTyConApp
    _ -> throwError $ ErrInvalidStructType structTyCon

tc (ExpTypeDec tyDec) =
  let id = getTypeDecId tyDec
  in do
    tycon <- tcTyDec tyDec
    bindTy id tycon
    return tyUnit

-- Note that `annDefs` here will never contain
-- more than one element, because function definitions
-- are desugared during alpha-conversion.
-- We are guaranteed to have a function definition of the form:
--
-- id(id1, ..., idN) { e1; ...; eN; }
--
-- Alpha-conversion guarantees that all definitions
-- have matching arity, but doesn't check arity
-- against the type annotation.
tc (ExpAnnDec decId tyParamIds synTy [AnnDefFun (FunDefFun defId paramPats bodyEs)]) = do
  if decId == defId
  then
    let paramIds = map (\(PatExpId id) -> id) paramPats
        asnE = ExpAssign (PatExpId defId) $ ExpFun paramIds bodyEs
        (SynTyArrow paramSynTys retSynTy) = synTy
    in do oldMetaEnv <- markMetaEnv
          mapM_ (\tyParamId -> bindTy tyParamId $ TyConTyVar tyParamId) tyParamIds
          givenTy <- tcTy synTy
          let givenTy' = case tyParamIds of
                            [] -> givenTy
                            _ -> TyPoly tyParamIds givenTy
          tc asnE
          inferredTy <- lookupVar defId
          givenTy'' <- instantiate givenTy'
          funTy <- instantiate inferredTy >>= unify givenTy''
          restoreMetaEnv oldMetaEnv
          generalize funTy >>= bindVar defId
          return tyUnit
  else
    throwError $ ErrFunDefIdMismatch decId defId

tc (ExpIfElse testE thenEs elseEs) = do
  testTy <- tc testE >>= unify tyBool
  thenTy <- tcEs thenEs
  elseTy <- tcEs elseEs
  unify thenTy elseTy

tc e = throwError $ ErrInterpFailure $ printf "In function tc: %s" $ show e


tcEs :: [Exp UniqId] -> Checked Ty
tcEs [] = return $ mtApp TyConUnit
tcEs es = do
  tys <- mapM tc es
  return $ last tys


typeCheck :: CompUnit UniqId -> AlphaEnv -> Either Err (Ty, AlphaEnv)
typeCheck (CompUnit es) aEnv = do
  (tyResult, tcEnv) <- return $ runState (runExceptT $ do { ty <- tcEs es; generalize ty }) $ mtEnv aEnv
  ty <- tyResult
  return (ty, alphaEnv tcEnv)
