module Types where

import AlphaConvert
import Common
import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.List
import qualified Data.Map as Map
import Data.Maybe (isNothing)
import Errors
import Semant
import Text.Printf (printf)


data TCEnv = TCEnv
  { typeEnv :: Map.Map UniqId TyCon
  , varEnv :: Map.Map UniqId Ty
  , curModule :: TyCon
  , alphaEnv :: AlphaEnv
  , polyEnv :: Map.Map UniqId Ty
  , metaEnv :: Map.Map UniqId Ty
  }
  deriving (Eq)

mtEnv :: AlphaEnv -> TCEnv
mtEnv alphaEnv =
  TCEnv
    { typeEnv = Map.empty
    , varEnv = Map.empty
    , curModule = TyConModule [] []
    , alphaEnv = alphaEnv
    , polyEnv = Map.empty
    , metaEnv = Map.empty
    }

type Checked a = ExceptT Err (State TCEnv) a


pushNewModuleContext :: [TyVarId] -> Checked TCEnv
pushNewModuleContext tyParamIds = do
  oldEnv <- get
  modify (\tcEnv -> tcEnv { curModule = TyConModule tyParamIds [] })
  return oldEnv


restoreEnv :: TCEnv -> Checked ()
restoreEnv tcEnv = put tcEnv


-- Convenience methods for manipulating the environment
addModuleTyBinding :: TyCon -> UniqId -> TyCon -> TyCon
addModuleTyBinding (TyConModule tyParamIds bindings) id tyCon =
  TyConModule tyParamIds ((ModuleBindingTyCon id tyCon) : bindings)


addModuleVarBinding :: TyCon -> UniqId -> Ty -> TyCon
addModuleVarBinding (TyConModule tyParamIds bindings) id ty =
  TyConModule tyParamIds ((ModuleBindingTy id ty) : bindings)


putTyBinding :: UniqId -> TyCon -> Checked ()
putTyBinding id ty = do
  modify (\tcEnv -> tcEnv { typeEnv = Map.insert id ty (typeEnv tcEnv)
                          , curModule = addModuleTyBinding (curModule tcEnv) id ty
                          })


putVarBinding :: UniqId -> Ty -> Checked ()
putVarBinding id ty = do
  modify (\tcEnv -> tcEnv { varEnv = Map.insert id ty (varEnv tcEnv)
                          , curModule = addModuleVarBinding (curModule tcEnv) id ty
                          })


putPolyBinding :: UniqId -> Ty -> Checked ()
putPolyBinding id ty = do
  modify (\tcEnv -> tcEnv { polyEnv = Map.insert id ty (polyEnv tcEnv) })


putMetaBinding :: UniqId -> Ty -> Checked ()
putMetaBinding id ty = do
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


lookupPoly :: UniqId -> Checked (Maybe Ty)
lookupPoly id = envLookup polyEnv id


lookupTy :: UniqId -> Checked TyCon
lookupTy id = envLookupOrFail typeEnv id


lookupVar :: UniqId -> Checked Ty
lookupVar id = envLookupOrFail varEnv id


occursIn :: Ty -> Ty -> Bool
occursIn _ _ = False


expand :: Ty -> Checked Ty
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
freeMetas :: Ty -> Checked [UniqId]
freeMetas (TyApp _ tyArgs) = do
  frees <- mapM freeMetas tyArgs
  return $ concat frees
freeMetas (TyPoly _ ty) = freeMetas ty
freeMetas ty@(TyMeta id) = do
  maybeTy <- lookupMeta id
  if isNothing maybeTy
  then return [id]
  else return []
freeMetas _ = return []

generalize :: Ty -> Checked Ty
generalize ty = do
  frees <- freeMetas ty
  tyParamIds <- mapM (\_ -> freshId) frees
  let metasAndTyParamIds = zip frees tyParamIds
  mapM_ (\(metaId, paramId) -> putMetaBinding metaId $ TyVar paramId)
        metasAndTyParamIds
  return $ TyPoly tyParamIds ty


instantiate :: Ty -> Checked Ty
instantiate (TyPoly tyParamIds ty) = do
  mapM_ (\paramId -> do { meta <- freshMeta; putPolyBinding paramId meta })
        tyParamIds
  subst ty

instantiate ty = return ty


subst :: Ty -> Checked Ty
subst meta@(TyMeta id) = do
  maybeTy <- lookupMeta id
  case maybeTy of
    Just ty -> subst ty
    _ -> return meta

subst (TyApp tycon tyArgs) = do
  tyArgs' <- mapM subst tyArgs
  return $ TyApp tycon tyArgs'

subst var@(TyVar id) = do
  maybeTy <- lookupPoly id
  case maybeTy of
    Just ty -> return ty
    _ -> return var

subst (TyPoly tyParamIds ty) = do
  ty' <- subst ty
  freshParamIds <- mapM (\_ -> freshId) tyParamIds
  let freshParamVars = map TyVar freshParamIds
  mapM_ (uncurry putPolyBinding) $ zip tyParamIds freshParamVars
  ty'' <- subst ty'
  return $ TyPoly freshParamIds ty''

subst ty = return ty


unify :: Ty -> Ty -> Checked Ty
unify a@(TyApp tyconA tyArgsA) b@(TyApp tyconB tyArgsB) =
  if tyconA == tyconB
  then do mapM_ (uncurry unify) $ zip tyArgsA tyArgsB
          return a
  else throwError $ ErrCantUnify a b

unify (TyPoly [] ty) tyb = unify ty tyb

unify meta@(TyMeta metaId) ty = do
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
                    _ -> do putMetaBinding metaId ty
                            return ty
        _ ->
          if meta `occursIn` ty
          then throwError $ ErrCircularType ty
          else do
            putMetaBinding metaId ty
            return ty

unify ty meta@(TyMeta _) = unify meta ty

unify TyAny b = return b
unify a TyAny = return a

unify ta tb = throwError $ ErrInterpFailure
                         $ printf "Non-exhaustive pattern in unify for: %s  %s" (show ta) (show tb)


unifyAll :: [Ty] -> Checked Ty
unifyAll [] = freshId >>= return . TyVar
unifyAll [ty] = return ty
unifyAll (ta:tb:tys) = do
  ty' <- unify ta tb
  unifyAll (ty':tys)


tcArith :: Exp UniqId -> Exp UniqId -> Checked Ty
tcArith a b = do
  tc a >>= unify tyInt
  tc b >>= unify tyInt
  return tyInt


tcTy :: SynTy UniqId -> Checked Ty
tcTy SynTyInt = return tyInt
tcTy SynTyBool = return tyBool
tcTy SynTyString = return tyStr
tcTy SynTyUnit = return tyUnit


tcTyDec :: TypeDec UniqId -> Checked TyCon
tcTyDec (TypeDecTy id SynTyInt) = return TyConInt
tcTyDec (TypeDecTy id (SynTyStruct fields)) =
  let (fieldNames, fieldSynTys) = unzip fields
  in do
    fieldTys <- mapM tcTy fieldSynTys
    return $ TyConTyFun [] $ TyApp (TyConStruct fieldNames) fieldTys


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

tcPatExp (PatExpAdt _ _) = throwError $ ErrNotImplemented "tcPatExp for ADT's"
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

tcPatExp (PatExpId id) = return TyAny
tcPatExp PatExpWildcard = return TyAny


addBindingsForPat :: PatExp UniqId -> Ty -> Checked ()
addBindingsForPat (PatExpTuple patEs) (TyApp TyConTuple tyArgs) =
  let componentEsTys = zip patEs tyArgs
  in do mapM_ (uncurry addBindingsForPat) componentEsTys

addBindingsForPat (PatExpAdt _ _) _ = throwError $ ErrNotImplemented "addBindingsForPat for ADT's"

addBindingsForPat (PatExpList elemEs) (TyApp TyConList [tyArg]) =
  let addBindingsForPatWithTy = (flip addBindingsForPat) tyArg
  in do mapM_ addBindingsForPatWithTy elemEs

addBindingsForPat (PatExpListCons hdE tlE) _ = throwError $ ErrNotImplemented "addBindingsForPat for list cons"

addBindingsForPat (PatExpId id) ty = putVarBinding id ty
addBindingsForPat _ _ = return ()


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
    TyApp (TyConModule tyParamIds bindings) [] ->
      let match = find (\binding -> case binding of
                                      (ModuleBindingTy name _) -> name == id
                                      _ -> False
                       )
                       bindings
      in do
        (ModuleBindingTy _ ty) <- hoistEither $ maybeToEither (ErrUnboundUniqIdentifier id)
                                              match
        return ty
    _ -> throwError $ ErrNotImplemented "Failed member access"

tc (ExpApp ratorE randEs) = do
  fty <- tc ratorE
  argTys <- mapM tc randEs
  retTyMeta@(TyMeta retTyMetaId) <- freshMeta
  fty' <- unify fty $ TyApp TyConArrow $ argTys ++ [retTyMeta]
  maybeRetTy <- lookupMeta retTyMetaId
  case maybeRetTy of
    Just ty -> return ty
    _ -> do metaEnv <- gets metaEnv
            throwError $ ErrInferenceFail metaEnv fty' retTyMeta

tc (ExpModule paramIds es) = do
  oldEnv <- pushNewModuleContext paramIds
  mapM_ tc es
  moduleTy <- gets curModule
  restoreEnv oldEnv
  let tyApp = TyApp moduleTy $ map TyVar paramIds
  case paramIds of
    [] -> return tyApp
    _ -> return $ TyPoly paramIds tyApp

tc (ExpAssign patE rhe) = do
  rheTy <- tc rhe
  patTy <- tcPatExp patE
  unify patTy rheTy
  addBindingsForPat patE rheTy
  return tyUnit

tc (ExpTuple es) = do
  tys <- mapM tc es
  return $ TyApp TyConTuple tys

tc (ExpSwitch e clauses) = throwError $ ErrNotImplemented "tc for ExpSwitch"

tc (ExpList []) = do
  tyParamId <- freshId
  return $ TyPoly [tyParamId] $ TyApp TyConList [TyVar tyParamId]

tc (ExpList es) = do
  tys <- mapM tc es
  elemTy <- unifyAll tys
  return $ TyApp TyConList [elemTy]

tc (ExpFun paramIds bodyEs) = do
  paramMetas <- mapM (\_ -> freshMeta) paramIds
  bodyTyMeta <- freshMeta
  let paramsAndTys = zip paramIds paramMetas
      fty = TyApp TyConArrow $ paramMetas ++ [bodyTyMeta]
  -- oldEnv <- get
  mapM_ (uncurry putVarBinding) paramsAndTys
  bodyTy <- tcEs bodyEs
  unify bodyTyMeta bodyTy
  fty' <- generalize fty
  -- put oldEnv
  return fty'

tc (ExpMakeAdt synTy i es) = throwError $ ErrNotImplemented "tc for MakeAdt"

tc (ExpStruct strSynTyE fieldInitEs) = do
  structTyCon <- tcTyconExp strSynTyE
  case structTyCon of
    TyConTyFun [] structTyConApp@(TyApp (TyConStruct fids) ftys) -> do
      tcStructFields (zip fids ftys) fieldInitEs
      return structTyConApp
    _ -> throwError $ ErrInvalidStructType structTyCon

tc (ExpIfElse testE thenEs elseEs) = do
  testTy <- tc testE >>= unify tyBool
  thenTy <- tcEs thenEs
  elseTy <- tcEs elseEs
  unify thenTy elseTy

tc (ExpTypeDec tyDec) =
  let id = getTypeDecId tyDec
  in do
    tycon <- tcTyDec tyDec
    putTyBinding id tycon
    return tyUnit

tc e = throwError $ ErrInterpFailure $ printf "In function tc: %s" $ show e


tcEs :: [Exp UniqId] -> Checked Ty
tcEs [] = return $ mtApp TyConUnit
tcEs es = do
  tys <- mapM tc es
  return $ last tys


typeCheck :: CompUnit UniqId -> AlphaEnv -> Either Err (Ty, AlphaEnv)
typeCheck (CompUnit es) aEnv = do
  (tyResult, tcEnv) <- return $ runState (runExceptT $ tcEs es) $ mtEnv aEnv
  ty <- tyResult
  return (ty, alphaEnv tcEnv)
