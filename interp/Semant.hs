module Semant where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity (runIdentity)
import Data.List
import Data.Monoid
import Parse
import Syntax
import Test.Hspec
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


specs = do
  describe "interp" $ do
    it "evaluates literals" $ do
      interp "True;" `shouldBe` Right (ValueBool True)
      interp "False;" `shouldBe` Right (ValueBool False)
      interp "42;" `shouldBe` Right (ValueInt 42)

    it "evaluates arithmetic exps" $ do
      interp "4 + 3;" `shouldBe` Right (ValueInt 7)
      interp "4 + 3 * 2;" `shouldBe` Right (ValueInt 10)
      interp "4 - 3 / 3;" `shouldBe` Right (ValueInt 3)

    it "rejects ill-typed programs" $ do
      interp
        "4 + False;"
        `shouldBe`
        Left "Expected Int but instead got: Bool"

    it "returns module values" $ do
      let prog = "m := module { }; \
                 \ m;"
      interp prog `shouldBe` Right (ValueModule $ Module mtEnv)

    it "returns values defined in modules" $ do
      let prog = "m := module { v := 42; }; m.v;"
      interp prog `shouldBe` Right (ValueInt 42)

    it "returns nested module values" $ do
      let prog = "a := module { b := module { v := 42; }; }; a.b.v;"
      interp prog `shouldBe` Right (ValueInt 42)

    it "applies defined functions" $ do
      let prog = "fun f() := { 42; }; f();"
      interp prog `shouldBe` Right (ValueInt 42)

    it "substitutes function args" $ do
      let prog = "fun f(x) := { x; }; f(42);"
      interp prog `shouldBe` Right (ValueInt 42)

    it "correctly shadows bindings in function bodies" $ do
      let prog = "m := module { }; fun f(m) := { m; }; f(42);"
      interp prog `shouldBe` Right (ValueInt 42)

    it "captures bindings from the env in function bodies" $ do
      let prog = "m := module { }; fun f() := { m; }; f();"
      interp prog `shouldBe` Right (ValueModule (Module mtEnv))

    it "preserves lexical scope for local module defs" $ do
      let prog = "fun f() := { m := module { }; }; m;"
      interp prog `shouldBe` Left "Unbound identifier 'm'"

    it "can apply functions on returned local modules" $ do
      let prog = "fun f() := {\
                 \  module { fun g() := { 42; }; }; \
                 \};\
                 \f().g();"
      interp prog `shouldBe` Right (ValueInt 42)

    it "reads modules with function defs" $ do
      let prog = "m := module { \
                 \   fun f() := { 42; }; \
                 \ }; \
                 \ m.f();"
      interp prog `shouldBe` Right (ValueInt 42)

    it "applies functions on nested modules" $ do
      let prog = "m := module { \
                 \   m1 := module { fun g() := { 43; }; };\
                 \   fun f() := { 42; }; \
                 \ }; \
                 \ m.m1.g();"
      interp prog `shouldBe` Right (ValueInt 43)

    it "evaluates functions with compound bodies on nested modules" $ do
      let prog = "m := module { \
                 \   m1 := module { fun g(x, y) := { y + x; }; };\
                 \   fun f() := { 42; }; \
                 \ }; \
                 \ m.m1.g(m.f(), 1);"
      interp prog `shouldBe` Right (ValueInt 43)

    it "adds module bindings into the env on import" $ do
      let prog = "m := module { \
                 \   m1 := module { fun g(x, y) := { y + x; }; };\
                 \ }; \
                 \import m.m1; \
                 \g(1, 1);"
      interp prog `shouldBe` Right (ValueInt 2)

    it "evaluates higher-order functions" $ do
      let prog = "fun f(g, x) := { g(10) + x; }; fun h(x) := { x + 1; }; f(h, 3);"
      interp prog `shouldBe` Right (ValueInt 14)

    it "detects circular module dependencies" $ do
      let prog = "a := module { x := b.x; }; b := module { x := a.x; }; a.x;"
      interp prog
        `shouldBe`
        Left "Circular dependency detected between 'a' and 'b'."
