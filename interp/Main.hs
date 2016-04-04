module Main where

import Control.Monad.Except (runExceptT)
import Data.Functor.Identity (runIdentity)
import Language.Sexp
import Parse (parseExp)
import qualified Semant
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)

main = do
  args <- getArgs
  result <- case args of
              [] -> fmap (parseExp "<stdin>") getContents
              [f] -> fmap (parseExp f) (readFile f)
              _ -> error "expected max. 1 argument"
  case result of
    Left err -> putStrLn err
    Right compUnit ->
      case Semant.interp compUnit of
        Left msg -> printf "%s" ("Error: " ++ msg)
        Right v -> printf "%s" $ show v
