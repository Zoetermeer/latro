module Semant where

import Parse
import Syntax
import Test.Hspec
import Text.Heredoc

data Answer =
    AnswerInt Int
  | AnswerBool Bool
  | AnswerString String
  | Err String
  deriving (Eq, Show)


interp :: String -> Answer
interp _ = Err "not implemented"

specs = do
  describe "interp" $ do
    it "interps literals" $ do
      interp "True" `shouldBe` AnswerBool True
      interp "False" `shouldBe` AnswerBool False
      interp "42" `shouldBe` AnswerInt 42
      interp "\"hello\"" `shouldBe` AnswerString "hello"

    it "interps arithmetic exps" $ do
      interp "4 + 3" `shouldBe` AnswerInt 7
      interp "4 + 3 * 2" `shouldBe` AnswerInt 10
      interp "4 - 3 / 3" `shouldBe` AnswerInt 3

    it "rejects ill-typed programs" $ do
      interp "4 + False" `shouldBe` Err "Expected Int"
