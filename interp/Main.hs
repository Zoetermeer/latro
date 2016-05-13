module Main where

import AlphaConvert
import Common
import Data.Functor.Identity (runIdentity)
import Errors
import Errors.Display
import Language.Sexp
import Parse (parseExp)
import qualified Interp
import Semant
import Semant.Display
import Sexpable
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)
import qualified Types as T

type ProgramText = String

data UserSwitch =
    Evaluate
  | DumpParseTree
  | DumpAlphaConverted
  | DumpTypecheckResult
  deriving (Eq, Show)

data CommandResult a =
    Success a
  | DumpOutput Sexpable.Sexp
  | Error Err

instance Monad CommandResult where
  Success v >>= f = f v
  DumpOutput sexp >>= _ = DumpOutput sexp
  Error err >>= _ = Error err

  return v = Success v


data Command a = Command UserSwitch (a -> Sexpable.Sexp) (Either Err a)


parseCmd :: FilePath -> ProgramText -> Command (RawAst CompUnit)
parseCmd filePath program =
  Command DumpParseTree sexp $ parseExp filePath program

alphaConvertCmd :: RawAst CompUnit -> Command (UniqAst CompUnit, AlphaEnv)
alphaConvertCmd compUnit =
  Command DumpAlphaConverted (\(ac, _) -> sexp ac) $ alphaConvert compUnit

tcCmd :: UniqAst CompUnit -> AlphaEnv -> Command (TypedAst CompUnit, AlphaEnv)
tcCmd alphaConverted alphaEnv =
  Command DumpTypecheckResult (\(tcResult, _) -> sexp tcResult) $ T.typeCheck alphaConverted alphaEnv

interpCmd :: TypedAst CompUnit -> AlphaEnv -> Command Value
interpCmd alphaConverted alphaEnv =
  Command Evaluate sexp $ Interp.interp alphaConverted alphaEnv


runCmd :: UserSwitch -> Command a -> CommandResult a
runCmd switch (Command dumpOnSwitch dumpSexp result) =
  case result of
    Left err -> Error err
    Right v ->
      if switch == dumpOnSwitch
      then DumpOutput $ dumpSexp v
      else Success v


run :: UserSwitch -> FilePath -> ProgramText -> CommandResult Value
run switch filePath program =
  let runCmd' = runCmd switch
  in do ast <- runCmd' $ parseCmd filePath program
        (alphaConvertedAst, alphaEnv) <- runCmd' $ alphaConvertCmd ast
        (typedAst, alphaEnv') <- runCmd' $ tcCmd alphaConvertedAst alphaEnv
        runCmd' $ interpCmd typedAst alphaEnv'


getUserSwitch :: [String] -> (UserSwitch, FilePath)
getUserSwitch ["-p", path] = (DumpParseTree, path)
getUserSwitch ["-a", path] = (DumpAlphaConverted, path)
getUserSwitch ["-t", path] = (DumpTypecheckResult, path)
getUserSwitch [path] = (Evaluate, path)
getUserSwitch _ = error "Usage: interp [-a|-p|-t] FILEPATH"


main = do
  args <- getArgs
  let (switch, filePath) = getUserSwitch args
  program <- readFile filePath
  case run switch filePath program of
    Success v -> printf "%s" $ showSexp v
    DumpOutput sexp -> printf "%s" $ show sexp
    Error err -> printf "%s" $ showSexp err
