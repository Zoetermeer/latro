module Semant where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity (runIdentity)
import Data.List
import Data.Monoid
import Parse
import Syntax
import Text.Printf (printf)

data Module = Module Env
  deriving (Eq, Show)

data Closure = Closure Env [RawId] [Exp]
  deriving (Eq, Show)

data Env = Env [(QualifiedId, Value)]
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


instance Monoid Env where
  mempty = Env []
  mappend (Env a) (Env b) = Env (a <> b)


mtEnv :: Env
mtEnv = Env []

addToEnv :: RawId -> Value -> State Env ()
addToEnv id v = do
  (Env table) <- get
  put $ Env $ ((Id id, v):table)


lookupEnv :: QualifiedId -> Eval Value
lookupEnv qid = do
  (Env table) <- get
  let ov = find (\(key, val) -> key == qid) table
  case ov of
    Just (k, v) -> return v
    _ -> throwError $ printf "Unbound identifier '%s'" $ show qid

pushEnv :: State Env Env
pushEnv = do
  env <- get
  put (env <> mempty)
  env' <- get
  return env'

popEnv :: Env -> State Env ()
popEnv env = do
  put env

type FailMessage = String
type Eval a = ExceptT FailMessage (State Env) a


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> Exp -> Exp -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


evalE :: Exp -> Eval Value
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

evalE (ExpAssign id e) = do
  v <- evalE e
  lift $ addToEnv id v
  return ValueUnit

evalE (ExpRef rawId) = do
  v <- lookupEnv (Id rawId)
  return v

evalE (ExpFun id paramIds es) = do
  env <- lift get
  lift $ pushEnv
  env' <- lift get
  let clo = Closure env' paramIds  es
  lift $ popEnv env
  lift $ addToEnv id $ ValueFun clo
  return ValueUnit

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


lookupValueInLocalEnv :: Value -> RawId -> Eval Value
lookupValueInLocalEnv (ValueModule (Module mEnv)) id = do
  env <- get
  put mEnv
  v <- lookupEnv $ Id id
  put env
  return v

lookupValueInLocalEnv _ id = do
  throwError $ printf "Invalid member access for '%s' on non-module value" id


evalEs :: [Exp] -> Eval Value
evalEs [] = return ValueUnit
evalEs (e:[]) = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: CompUnit -> Eval Value
eval (CompUnit es) = evalEs es


interp :: String -> Either FailMessage Value
interp prog =
  let eAst = runIdentity $ runExceptT $ parse prog
  in
    case eAst of
      Left msg -> Left msg
      Right ast ->
        evalState (runExceptT $ eval ast) mtEnv
