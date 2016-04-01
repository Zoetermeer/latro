module Semant where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity (runIdentity)
import Parse
import Syntax
import Test.Hspec
import Text.Heredoc

data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueString String
  | ValueUnit
  | ValueAst CompUnit
  | Err String
  deriving (Eq, Show)


data Env = Env [(RawId, Value)]

mtEnv :: Env
mtEnv = Env []

type FailMessage = String
type Eval a = ExceptT FailMessage (State Env) a


evalE :: Exp -> Eval Value
evalE (ExpNum str) = return $ ValueInt $ read str
evalE (ExpBool b) = return $ ValueBool b
evalE (ExpAdd a b) = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ a' + b'

evalE (ExpSub a b) = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ a' - b'

evalE (ExpMul a b) = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ a' * b'

evalE (ExpDiv a b) = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ a' `quot` b'


evalEs :: [Exp] -> Eval Value
evalEs (e:[]) = evalE e


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
