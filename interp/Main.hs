module Main where

import Control.Monad.Except (runExceptT)
import Data.Functor.Identity (runIdentity)
import Language.Sexp
import Parse (parseExp)
import qualified Semant
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)

data Command =
    Evaluate
  | DumpParseTree
  | DumpTypecheckResult
  deriving (Eq, Show)

getCommand :: [String] -> (Command, String)
getCommand ["-p", path] = (DumpParseTree, path)
getCommand ["-t", path] = (DumpTypecheckResult, path)
getCommand [path] = (Evaluate, path)
getCommand _ = error "Usage: interp [-p|-t] FILEPATH"

main = do
  args <- getArgs
  let (command, filePath) = getCommand args
  parseResult <- fmap (parseExp filePath) $ readFile filePath
  case parseResult of
    Left err -> putStrLn err
    Right parseTree ->
      case command of
        DumpParseTree -> print $ show parseTree
        _ ->
          case Semant.interp parseTree of
            Left err -> printf "%s" $ "Error: " ++ err
            Right v -> printf "%s" $ show v
