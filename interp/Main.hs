module Main where

import AlphaConvert
import Common
import Data.Functor.Identity (runIdentity)
import Errors
import Errors.Display
import Language.Sexp
import Parse (parseExp)
import qualified Interp
import Semant.Display
import Sexpable
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)
import qualified Types as T
import Types.Display

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
getCommand _ = error "Usage: interp [-a|-p|-t] FILEPATH"


run :: Command -> String -> String -> Either Err Sexpable.Sexp
run command filePath program = do
  ast <- parseExp filePath program
  if command == DumpParseTree
  then return (sexp ast)
  else do
    (alphaConverted, alphaEnv) <- alphaConvert ast
    if command == DumpAlphaConverted
    then return $ sexp alphaConverted
    else do
      (progType, alphaEnv') <- T.typeCheck alphaConverted alphaEnv
      if command == DumpTypecheckResult
      then return $ sexp progType
      else do
        result <- Interp.interp alphaConverted alphaEnv'
        return $ sexp result

main = do
  args <- getArgs
  let (command, filePath) = getCommand args
  program <- readFile filePath
  case run command filePath program of
    Left err -> printf "%s" $ showSexp err
    Right sxp -> printf "%s" $ show sxp
