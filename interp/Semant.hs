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

type VEnv = Env (QualifiedId UniqId) Value

data Module = Module VEnv
  deriving (Eq, Show)

data Closure = Closure VEnv [UniqId] [Exp UniqId]
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


mtEnv :: VEnv
mtEnv = Env []

addToEnv :: UniqId -> Value -> State VEnv ()
addToEnv id v = do
  (Env table) <- get
  put $ Env $ ((Id id, v):table)


lookupEnv :: QualifiedId UniqId -> Eval Value
lookupEnv qid = do
  (Env table) <- get
  let ov = find (\(key, val) -> key == qid) table
  case ov of
    Just (k, v) -> return v
    _ -> throwError $ printf "Unbound identifier '%s'" $ show qid

pushEnv :: State VEnv VEnv
pushEnv = do
  env <- get
  put (env <> mempty)
  env' <- get
  return env'

popEnv :: VEnv -> State VEnv ()
popEnv env = do
  put env

type Eval a = ExceptT FailMessage (State VEnv) a


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
  env <- get
  lift pushEnv
  evalEs moduleEs
  moduleEnv <- lift get
  lift $ popEnv env
  return $ ValueModule $ Module moduleEnv

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
        env <- lift get
        let paramIds = map patExpBindingId argPatExps
            clo = Closure env paramIds bodyExps
        lift $ addToEnv id $ ValueFun clo
        return ValueUnit

evalE (ExpFunDec (FunDecInstFun id instTy funTy funDefs)) =
  return ValueUnit

-- evalE (ExpFun id paramIds es) = do
--   env <- lift get
--   lift $ pushEnv
--   env' <- lift get
--   let clo = Closure env' paramIds  es
--   lift $ popEnv env
--   lift $ addToEnv id $ ValueFun clo
--   return ValueUnit

evalE (ExpAssign id e) = do
  v <- evalE e
  lift $ addToEnv id v
  return ValueUnit

evalE (ExpRef rawId) = do
  v <- lookupEnv (Id rawId)
  return v

evalE (ExpApp e argEs) = do
  (ValueFun (Closure fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs
  env <- get
  put fenv
  let argVTbl = zip paramIds argVs
  lift $ mapM (\(paramId, paramV) -> addToEnv paramId paramV) argVTbl
  retV <- evalEs bodyEs
  put env
  return retV

evalE (ExpMemberAccess e id) = do
  v <- evalE e
  lookupValueInLocalEnv v id


lookupValueInLocalEnv :: Value -> UniqId -> Eval Value
lookupValueInLocalEnv (ValueModule (Module mEnv)) id = do
  env <- get
  put mEnv
  v <- lookupEnv $ Id id
  put env
  return v

lookupValueInLocalEnv _ id = do
  throwError $ printf "Invalid member access for '%s' on non-module value" $ show id


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
  evalState (runExceptT $ eval alphaConverted) mtEnv
