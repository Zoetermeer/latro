module Semant where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity (runIdentity)
import Data.List
import Parse
import Syntax
import Test.Hspec
import Text.Printf (printf)

data Module = Module [(RawId, Value)]
  deriving (Eq, Show)

data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueModule Module
  | ValueUnit
  | Err String
  deriving (Eq, Show)


data Env = Env [(QualifiedId, Value)]

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

type FailMessage = String
type Eval a = ExceptT FailMessage (State Env) a


evalBinArith :: (Int -> Int -> Int) -> Exp -> Exp -> Eval Value
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

evalE (ExpModule _) = return $ ValueModule $ Module []

evalE (ExpAssign id e) = do
  v <- evalE e
  lift $ addToEnv id v
  return ValueUnit

evalE (ExpQualId qid) = do
  v <- lookupEnv qid
  return v


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
    it "interps literals" $ do
      interp "True;" `shouldBe` Right (ValueBool True)
      interp "False;" `shouldBe` Right (ValueBool False)
      interp "42;" `shouldBe` Right (ValueInt 42)

    it "interps arithmetic exps" $ do
      interp "4 + 3;" `shouldBe` Right (ValueInt 7)
      interp "4 + 3 * 2;" `shouldBe` Right (ValueInt 10)
      interp "4 - 3 / 3;" `shouldBe` Right (ValueInt 3)

    it "rejects ill-typed programs" $ do
      interp "4 + False;" `shouldBe` Left "Expected Int"

    it "returns module values" $ do
      let prog = "m := module { }; \
                 \ m;"
      interp prog `shouldBe` Right (ValueModule $ Module [])

    it "reads modules with function defs" $ do
      let prog = "m := module { \
                 \   fun f() : Int \
                 \   f() := 42 \
                 \ }; \
                 \ m.f();"
      interp prog `shouldBe` Right (ValueInt 42)
