module Main where

import AlphaConvert
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
  | DumpAlphaConverted
  | DumpTypecheckResult
  deriving (Eq, Show)

getCommand :: [String] -> (Command, String)
getCommand ["-p", path] = (DumpParseTree, path)
getCommand ["-a", path] = (DumpAlphaConverted, path)
getCommand ["-t", path] = (DumpTypecheckResult, path)
getCommand [path] = (Evaluate, path)
getCommand _ = error "Usage: interp [-p|-t] FILEPATH"

run :: Command -> String -> String -> Either String String
run command filePath program =
  let parseTreeResult = parseExp filePath program
  in do
    parseTree <- parseTreeResult
    if command == DumpParseTree
    then return $ show parseTree
    else do
      (alphaConverted, alphaEnv) <- alphaConvert parseTree
      if command == DumpAlphaConverted
      then return $ show alphaConverted
      else do
        result <- Semant.interp alphaConverted alphaEnv
        return $ show result

main = do
  args <- getArgs
  let (command, filePath) = getCommand args
  program <- readFile filePath
  case run command filePath program of
    Left err -> printf "Error: %s" err
    Right v -> printf "%s" v
