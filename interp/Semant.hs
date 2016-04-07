module Semant where

import AlphaConvert
import Common
import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity (runIdentity)
import Data.List
import Data.Monoid ((<>), mempty)
import Parse
import Syntax
import Text.Printf (printf)

type VEnv = Env UniqId Value

-- A module value has two environments:
-- A closure environment, and an export
-- environment.  A name lookup on a module
-- can't search the closure environment, so we
-- separate them
data Module = Module VEnv VEnv
  deriving (Eq, Show)

data Closure = Closure UniqId VEnv [UniqId] [Exp UniqId]
  deriving (Eq, Show)

data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueModule Module
  | ValueFun Closure
  | ValueUnit
  | Err String
  deriving (Eq)

instance Show Value where
  show (ValueInt i) = show i
  show (ValueBool b) = show b
  show (ValueModule m) = show m
  show (ValueFun clo) = show clo
  show ValueUnit = "()"
  show (Err msg) = "Error: " ++ msg

-- An evaluator monad is a possibly-failing computation
-- with a state: (variable environment, current module)
-- The variable environment maps ID --o--> Value
-- The "current module" is the module currently being evaluated,
-- at the top level it's an invented anonymous one.
-- The top-level anonymous module gives the nice property
-- that bindings at the top (not in any explicitly defined
-- module) are closed over in submodules, but will
-- not be accessible from other compilation units.
-- Each new binding occurrence adds the id to the current
-- module's list of exports
type EvalState = (VEnv, Module)
type Eval a = ExceptT FailMessage (State EvalState) a


mtEnv :: VEnv
mtEnv = Env []


lookupIn :: VEnv -> UniqId -> Eval Value
lookupIn (Env table) id = do
  let ov = find (\(key, val) -> key == id) table
  case ov of
    Just (k, v) -> return v
    _ -> throwError $ printf "Unbound identifier '%s'" $ show id


lookupQual :: QualifiedId UniqId -> Eval Value
lookupQual (Id id) = do
  (vEnv, _) <- get
  lookupIn vEnv id

lookupQual (Path qid id) = do
  (ValueModule (Module _ exportEnv)) <- lookupQual qid
  lookupIn exportEnv id


lookupId :: UniqId -> Eval Value
lookupId id = do
  (vEnv, _) <- get
  lookupIn vEnv id


getVarEnv :: Eval VEnv
getVarEnv = do
  (env, _) <- get
  return env


addVarBinding :: UniqId -> Value -> Eval ()
addVarBinding id v = do
  (Env vTable, cm) <- get
  put (Env ((id, v):vTable), cm)


addModuleExport :: UniqId -> Value -> Eval ()
addModuleExport id v = do
  (Env vTable, (Module mVars (Env mExports))) <- get
  put (Env vTable, (Module mVars (Env ((id, v):mExports))))


addToEnv :: UniqId -> Value -> State VEnv ()
addToEnv id v = do
  (Env table) <- get
  put $ Env $ ((id, v):table)


pushNewModuleContext :: Eval EvalState
pushNewModuleContext = do
  curState@(vEnv, _) <- get
  put (vEnv, Module vEnv mtEnv)
  return curState


pushEnv :: State VEnv VEnv
pushEnv = do
  env <- get
  put (env <> mempty)
  env' <- get
  return env'

popEnv :: VEnv -> State VEnv ()
popEnv env = do
  put env


-- This is a placeholder; to be replaced
-- by real pattern matching
patExpBindingId :: PatExp UniqId -> UniqId
patExpBindingId (PatExpVar id) = id


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> Exp UniqId -> Exp UniqId -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


evalE :: Exp UniqId -> Eval Value
evalE (ExpNum str) = return $ ValueInt $ read str
evalE (ExpBool b) = return $ ValueBool b
evalE (ExpAdd a b) = evalBinArith (+) a b
evalE (ExpSub a b) = evalBinArith (-) a b
evalE (ExpDiv a b) = evalBinArith quot a b
evalE (ExpMul a b) = evalBinArith (*) a b

evalE (ExpModule moduleEs) = do
  oldEnv <- pushNewModuleContext
  evalEs moduleEs
  (_, mod) <- get
  put oldEnv
  return $ ValueModule mod

evalE (ExpFunDec (FunDecFun id _ [])) = do
  throwError $ printf "No definition given for function declaration '%s'" $ show id

evalE (ExpFunDec (FunDecInstFun id _ _ [])) = do
  throwError $ printf "No definition given for instance function declaration '%s'" $ show id

evalE (ExpFunDec (FunDecFun id ty (funDef:_))) =
  case funDef of
    FunDefInstFun _ _ _ _ -> do
      throwError $ printf "Function '%s' is not an instance function" $ show id
    FunDefFun fid argPatExps bodyExps ->
      if id /= fid then
        do { throwError $ printf "Invalid definition for function '%s' in definition context for '%s'" (show fid) (show id) }
      else do
        (vEnv, _) <- get
        let paramIds = map patExpBindingId argPatExps
            clo = Closure fid vEnv paramIds bodyExps
            vClo = ValueFun clo
        addVarBinding id vClo
        addModuleExport id vClo
        return ValueUnit

evalE (ExpFunDec (FunDecInstFun id instTy funTy funDefs)) =
  return ValueUnit

evalE (ExpAssign id e) = do
  v <- evalE e
  addVarBinding id v
  addModuleExport id v
  return ValueUnit

evalE (ExpRef rawId) = do
  v <- lookupId rawId
  return v

evalE (ExpApp e argEs) = do
  fv@(ValueFun (Closure fid fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs
  (curEnv, curModule) <- get
  put (fenv, curModule)
  addVarBinding fid fv
  let argVTbl = zip paramIds argVs
  mapM (\(paramId, paramV) -> addVarBinding paramId paramV) argVTbl
  retV <- evalEs bodyEs
  put (curEnv, curModule)
  return retV

evalE (ExpMemberAccess e id) = do
  (ValueModule (Module _ exportEnv)) <- evalE e
  lookupIn exportEnv id

-- For now we allow 0 to evaluate
-- to 'False' in the test position of a
-- conditional, and any nonzero --> 'True'.
-- Ultimately this should not be the case
-- as we don't want to support implicit conversion
evalE (ExpIfElse condE thenEs elseEs) = do
  curEnv <- get
  condV <- evalE condE
  put curEnv
  let es = case condV of
            ValueBool True -> thenEs
            ValueInt 0 -> elseEs
            ValueInt _ -> thenEs
            _ -> elseEs
  v <- evalEs es
  put curEnv
  return v

evalE e = throwError $ printf "I don't know how to evaluate '%s'" $ show e


evalEs :: [Exp UniqId] -> Eval Value
evalEs [] = return ValueUnit
evalEs (e:[]) = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: CompUnit UniqId -> Eval Value
eval (CompUnit es) = evalEs es


interp :: CompUnit RawId -> Either FailMessage Value
interp compUnit = do
  alphaConverted <- alphaConvert compUnit
  evalState (runExceptT $ eval alphaConverted) (mtEnv, Module mtEnv mtEnv)
