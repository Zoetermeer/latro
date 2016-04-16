{-# LANGUAGE NamedFieldPuns #-}
module Interp where

import AlphaConvert hiding (lookup)
import Common
import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.Functor.Identity (runIdentity)
import Data.List
import qualified Data.Map as Map
import Data.Maybe (fromJust, isJust)
import Data.Monoid ((<>), mempty)
import Errors
import Parse
import Prelude hiding (lookup)
import Semant


-- An evaluator monad is a possibly-failing computation
-- with a state: (type environment, variable environment, current module)
-- The variable environment maps ID --o--> Value
-- The "current module" is the module currently being evaluated,
-- at the top level it's an invented anonymous one.
-- The top-level anonymous module gives the nice property
-- that bindings at the top (not in any explicitly defined
-- module) are closed over in submodules, but will
-- not be accessible from other compilation units.
-- Each new binding occurrence adds the id to the current
-- module's list of exports
data InterpEnv = InterpEnv
  { typeEnv :: TEnv
  , varEnv  :: VEnv
  , curModule :: Module
  , alphaEnv :: AlphaEnv
  }
  deriving (Eq)

type Eval a = ExceptT Err (State InterpEnv) a

mtClosureEnv :: ClosureEnv
mtClosureEnv = ClosureEnv { cloTypeEnv = Map.empty
                          , cloVarEnv = Map.empty
                          }

mtExports :: Exports
mtExports = Exports { exportTypes = Map.empty
                    , exportVars =  Map.empty
                    }

mtInterpEnv :: AlphaEnv -> InterpEnv
mtInterpEnv alphaEnv =
    InterpEnv
      { typeEnv = Map.empty
      , varEnv = Map.empty
      , curModule = mod
      , alphaEnv = alphaEnv
      }
  where
    mod = Module mtClosureEnv mtExports


lookupId :: UniqId -> Map.Map UniqId v -> Eval v
lookupId id map =
    hoistEither eithV
  where
    eithV = maybeToEither err $ Map.lookup id map
    err = ErrUnboundUniqIdentifier id


lookupQualIn  :: QualifiedId UniqId
              -> InterpEnv
              -> (Exports -> Map.Map UniqId a)
              -> (InterpEnv -> Map.Map UniqId a)
              -> Eval a
lookupQualIn (Id id) intEnv _ extractAEnv = lookupId id $ extractAEnv intEnv
lookupQualIn (Path qid id) intEnv extractExportEnv _ = do
  (ValueModule (Module _ exports)) <- lookupQualIn qid intEnv exportVars varEnv
  lookupId id $ extractExportEnv exports

lookupTyQualIn :: QualifiedId UniqId -> InterpEnv -> Eval (SynTy UniqId)
lookupTyQualIn id intEnv = lookupQualIn id intEnv exportTypes typeEnv

lookupVarQualIn :: QualifiedId UniqId -> InterpEnv -> Eval Value
lookupVarQualIn id intEnv = lookupQualIn id intEnv exportVars varEnv


lookupVarQual :: QualifiedId UniqId -> Eval Value
lookupVarQual id = get >>= lookupVarQualIn id


lookupTyQual :: QualifiedId UniqId -> Eval (SynTy UniqId)
lookupTyQual id = get >>= lookupTyQualIn id


lookupVarId :: UniqId -> Eval Value
lookupVarId id = getVarEnv >>= lookupId id


getVarEnv :: Eval VEnv
getVarEnv = gets varEnv


getTyEnv :: Eval TEnv
getTyEnv = gets typeEnv


putVarBinding :: UniqId -> Value -> Eval ()
putVarBinding id v = do
  modify (\intEnv -> intEnv { varEnv = Map.insert id v (varEnv intEnv) })


putTyBinding :: UniqId -> SynTy UniqId -> Eval ()
putTyBinding id ty = do
  modify (\intEnv -> intEnv { typeEnv = Map.insert id ty (typeEnv intEnv) })


putModuleVarExport :: UniqId -> Value -> Eval ()
putModuleVarExport id v = do
  modify (\intEnv ->
            let (Module cloEnv exports) = curModule intEnv
                exports' = exports { exportVars = Map.insert id v (exportVars exports) }
            in
              intEnv { curModule = Module cloEnv exports' })


putModuleTyExport :: UniqId -> SynTy UniqId -> Eval ()
putModuleTyExport id ty = do
  modify (\intEnv ->
            let (Module cloEnv exports) = curModule intEnv
                exports' = exports { exportTypes = Map.insert id ty (exportTypes exports) }
            in
              intEnv { curModule = Module cloEnv exports' })


pushNewModuleContext :: Eval InterpEnv
pushNewModuleContext = do
  curEnv <- get
  let modCloEnv = ClosureEnv { cloTypeEnv = typeEnv curEnv, cloVarEnv = varEnv curEnv }
  modify (\intEnv -> intEnv { curModule = Module modCloEnv mtExports })
  return curEnv


getClosureEnv :: Eval ClosureEnv
getClosureEnv = do
  curEnv <- get
  return $ ClosureEnv { cloTypeEnv = typeEnv curEnv, cloVarEnv = varEnv curEnv }


restoreEnv :: InterpEnv -> Eval ()
restoreEnv intEnv = put intEnv


-- TODO: Placeholder for patterns in argument-binding
-- position
patExpBindingId :: PatExp UniqId -> UniqId
patExpBindingId (PatExpId id) = id


evalTyExp :: Exp UniqId -> Eval (SynTy UniqId)
evalTyExp (ExpRef id) = getTyEnv >>= lookupId id
evalTyExp (ExpMemberAccess e id) = do
  (ValueModule (Module _ exports)) <- evalE e
  lookupId id $ exportTypes exports

evalTyExp e = throwError $ ErrInvalidTypeExp e


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> Exp UniqId -> Exp UniqId -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


freshId :: Eval UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let (uniqId, alphaEnv') = fresh "arg" alphaEnv
  modify (\interpEnv -> interpEnv { alphaEnv = alphaEnv' })
  return uniqId


evalAdtAlt :: SynTy UniqId -> AdtAlternative UniqId -> Eval ()
evalAdtAlt ty (AdtAlternative id i tys) = do
  argIds <- mapM (\_ -> freshId) tys
  let argRefs = map ExpRef argIds
  cloTypeEnv <- gets typeEnv
  let cloEnv = ClosureEnv { cloTypeEnv, cloVarEnv = Map.empty }
      ctorTy = SynTyArrow tys ty
      clo = Closure id ctorTy cloEnv argIds [ExpMakeAdt ty i argRefs]

  putVarBinding id $ ValueFun clo
  putModuleVarExport id $ ValueFun clo
  return ()


resolvePatExpAdtTag :: PatExp UniqId -> Value -> Value -> Either Err ()
resolvePatExpAdtTag (PatExpAdt id patEs) testV ctorV =
  case testV of
    ValueAdt (Adt ty tag vs) ->
      case ctorV of
        ValueFun (Closure _ (SynTyArrow paramTys retTy) _ paramIds _) ->
          let (SynTyAdt _ alts) = ty
          in
            case find (\(AdtAlternative altId i _) -> id == altId) alts of
              Just (AdtAlternative _ i tys) ->
                if i == tag
                then return ()
                else Left $ ErrNonExhaustivePattern testV
              _ -> Left $ ErrInvalidConstructor id ty
        _ ->
          Left $ ErrNotAConstructor id
    _ ->
      Left $ ErrNotAnAdt testV

resolvePatExpAdtTag _ _ _ = Left ErrInvalidAdtPattern


evalPatExp :: PatExp UniqId -> Value -> Eval ()
evalPatExp PatExpWildcard _ = return ()
evalPatExp (PatExpNumLiteral n) v =
    case v of
      ValueInt i ->
        if i == ni
        then return ()
        else throwError $ ErrNumLitPatMatchFail ni i
      _ ->
        throwError $ ErrPatMatchFailOn v
  where
    ni = read n

evalPatExp (PatExpBoolLiteral b) v =
  case v of
    ValueBool bv ->
      if bv == b
      then return ()
      else throwError $ ErrBoolLitPatMatchFail b bv
    _ -> throwError $ ErrPatMatchFailOn v

evalPatExp (PatExpTuple patEs) v@(ValueTuple vs) =
  if length patEs /= length vs
  then throwError $ ErrPatMatchFailOn v
  else do
    let evPairs = zip patEs vs
    mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
    return ()

evalPatExp (PatExpTuple _) v =
  throwError $ ErrPatMatchFailOn v

evalPatExp patE@(PatExpAdt id patEs) testV@(ValueAdt (Adt ty tag vs)) = do
  ctorV <- lookupVarId id
  resolved <- hoistEither $ resolvePatExpAdtTag patE testV ctorV
  let evPairs = zip patEs vs
  mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
  return ()

evalPatExp patE@(PatExpAdt _ _) v =
  throwError $ ErrNotAnAdt v

evalPatExp (PatExpList es) v@(ValueList vs) =
  if length es /= length vs
  then throwError $ ErrPatMatchFailOn v
  else do
    let evPairs = zip es vs
    mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
    return ()

evalPatExp patE@(PatExpList _) v =
  throwError $ ErrListPatMatchFail v

evalPatExp (PatExpListCons _ _) v@(ValueList []) =
  throwError $ ErrPatMatchFailOn v

evalPatExp (PatExpListCons eHd eTl) (ValueList (v:vs)) = do
  evalPatExp eHd v
  evalPatExp eTl $ ValueList vs
  return ()


evalPatExp (PatExpId id) v = do
  putVarBinding id v
  putModuleVarExport id v
  return ()


evalE :: Exp UniqId -> Eval Value
evalE (ExpNum str) = return $ ValueInt $ read str
evalE (ExpBool b) = return $ ValueBool b
evalE (ExpString s) = return $ ValueStr s
evalE (ExpAdd a b) = evalBinArith (+) a b
evalE (ExpSub a b) = evalBinArith (-) a b
evalE (ExpDiv a b) = evalBinArith quot a b
evalE (ExpMul a b) = evalBinArith (*) a b

evalE (ExpCons a b) = do
  vHd <- evalE a
  vTl <- evalE b
  case vTl of
    ValueList vs -> return $ ValueList (vHd:vs)
    _ ->
      throwError $ ErrInvalidConsTo vTl

evalE (ExpTuple es) = do
  vs <- mapM evalE es
  return $ ValueTuple vs

evalE (ExpList es) = do
  vs <- mapM evalE es
  return $ ValueList vs

evalE (ExpMakeAdt ty i ctorArgEs) = do
  argVs <- mapM evalE ctorArgEs
  return $ ValueAdt $ Adt ty i argVs

evalE (ExpTypeDec (TypeDecTy id ty)) = do
  putTyBinding id ty
  putModuleTyExport id ty
  return ValueUnit

evalE (ExpTypeDec (TypeDecAdt id alts)) = do
  let alts' = mapi (\i (AdtAlternative aid _ tys) -> AdtAlternative aid i tys) alts
      ty = SynTyAdt id alts'
  putTyBinding id ty
  putModuleTyExport id ty

  mapM_ (evalAdtAlt ty) alts'

  return ValueUnit

evalE (ExpModule moduleEs) = do
  oldEnv <- pushNewModuleContext
  mapM_ evalE moduleEs
  newModule <- gets curModule
  restoreEnv oldEnv
  return $ ValueModule newModule

evalE (ExpStruct tyExp fieldInits) = do
  ty <- evalTyExp tyExp
  fieldInitVs <- mapM (\(id, e) -> do { v <- evalE e; return (id, v) }) fieldInits
  return $ ValueStruct $ Struct ty fieldInitVs

evalE (ExpFunDec (FunDecFun id _ [])) = do
  throwError $ ErrNoFunDefGivenFor id

evalE (ExpFunDec (FunDecInstFun id _ _ [])) = do
  throwError $ ErrNoInstFunDefGivenFor id


-- Need to validate fundef identifiers here
evalE (ExpFunDec (FunDecFun id ty (funDef:[]))) = do
  let (FunDefFun _ argPatEs bodyEs) = funDef
  cloEnv <- gets (\intEnv -> ClosureEnv { cloTypeEnv = typeEnv intEnv, cloVarEnv = varEnv intEnv })
  let paramIds = map patExpBindingId argPatEs
      clo = Closure id ty cloEnv paramIds bodyEs
      vClo = ValueFun clo
  putVarBinding id vClo
  putModuleVarExport id vClo
  return ValueUnit

evalE (ExpFunDec (FunDecInstFun id instTy funTy funDefs)) =
  return ValueUnit

evalE (ExpAssign patE e) = do
  v <- evalE e
  evalPatExp patE v
  return ValueUnit

evalE (ExpRef rawId) = do
  v <- lookupVarId rawId
  return v

evalE (ExpApp e argEs) = do
  fv@(ValueFun (Closure fid fTy fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs

  preApplyInterpEnv <- get
  put (preApplyInterpEnv { typeEnv = cloTypeEnv fenv, varEnv = cloVarEnv fenv })

  putVarBinding fid fv
  let argVTbl = zip paramIds argVs
  mapM_ (\(paramId, paramV) -> putVarBinding paramId paramV) argVTbl
  retV <- evalEs bodyEs

  restoreEnv preApplyInterpEnv
  return retV

-- The type of the anonymous function is blatantly
-- wrong here, but we punt on it as we can't reliably determine
-- it until we have decent type inference.
evalE (ExpFun paramIds bodyEs) = do
  cloEnv <- getClosureEnv
  return $ ValueFun $ Closure (UserId "_") SynTyInt cloEnv paramIds bodyEs

evalE (ExpMemberAccess e id) = do
  v <- evalE e
  case v of
    (ValueModule (Module _ exports)) -> lookupId id $ exportVars exports
    (ValueStruct (Struct _ fields)) ->
      hoistEither $ maybeToEither err $ lookup id fields
  where
    err = ErrUnboundUniqIdentifier id

-- For now we allow 0 to evaluate
-- to 'False' in the test position of a
-- conditional, and any nonzero --> 'True'.
-- Ultimately this should not be the case
-- as we don't want to support implicit conversion
-- We throw away the updated environment
-- after each evaluation to avoid local binding
-- escape
evalE (ExpIfElse condE thenEs elseEs) = do
  curEnv <- get
  condV <- evalE condE
  restoreEnv curEnv
  let es = case condV of
            ValueBool True -> thenEs
            ValueInt 0 -> elseEs
            ValueInt _ -> thenEs
            _ -> elseEs
  v <- evalEs es
  restoreEnv curEnv
  return v

evalE (ExpSwitch e clauses) = do
  v <- evalE e
  matchResult <- evalCaseClauses v clauses
  case matchResult of
    Nothing -> throwError $ ErrNonExhaustivePattern v
    Just retV -> return retV

evalE e = throwError $ ErrCantEvaluate e


evalCaseClauses :: Value -> [CaseClause UniqId] -> Eval (Maybe Value)
evalCaseClauses _ [] = return Nothing
evalCaseClauses v ((CaseClause patE bodyEs):clauses) = do
  oldEnv <- get
  result <- do { r <- evalPatExp patE v; return $ Just () } `catchError` (\_ -> return Nothing)
  case result of
    Nothing -> do
      restoreEnv oldEnv
      evalCaseClauses v clauses
    Just _ -> do
      retV <- evalEs bodyEs
      return $ Just retV


evalEs :: [Exp UniqId] -> Eval Value
evalEs [] = return ValueUnit
evalEs (e:[]) = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: CompUnit UniqId -> Eval Value
eval (CompUnit es) = evalEs es

interp :: CompUnit UniqId -> AlphaEnv -> Either Err Value
interp alphaConverted alphaEnv = do
  evalState (runExceptT $ eval alphaConverted) $ mtInterpEnv alphaEnv
