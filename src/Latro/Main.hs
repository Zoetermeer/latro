module Main where

import AlphaConvert
import Common
import Control.Monad
import Data.Functor.Identity (runIdentity)
import Errors
import Errors.Display
import Parse (parseExp)
import qualified Interp
import Semant
import Semant.Display
import Sexpable
import System.Environment (getArgs)
import Text.Printf (printf)
import qualified Types as T

type ProgramText = String

data UserSwitch =
    Evaluate
  | DumpParseTree
  | DumpAlphaConverted
  | DumpTypecheckResult
  | DumpTypedAst
  deriving (Eq, Show)

data CommandResult a =
    Success a
  | DumpOutput Sexpable.Sexp
  | Error Err


instance Functor CommandResult where
  fmap = liftM


instance Applicative CommandResult where
  pure = Success

  (<*>) = ap

  DumpOutput sexp *> _ = DumpOutput sexp
  _ *> b = b


instance Monad CommandResult where
  Success v >>= f = f v
  DumpOutput sexp >>= _ = DumpOutput sexp
  Error err >>= _ = Error err

  (>>) = (*>)

  return = pure


data Command a = Command UserSwitch (a -> Sexpable.Sexp) (Either Err a)


parseCmd :: FilePath -> ProgramText -> Command (RawAst CompUnit)
parseCmd filePath program =
  Command DumpParseTree sexp $ parseExp filePath program

alphaConvertCmd :: RawAst CompUnit -> Command (UniqAst CompUnit, AlphaEnv)
alphaConvertCmd compUnit =
  Command DumpAlphaConverted (\(ac, _) -> sexp ac) $ alphaConvert compUnit

tcCmd :: UniqAst CompUnit -> AlphaEnv -> Command (TypedAst CompUnit, AlphaEnv)
tcCmd alphaConverted alphaEnv =
  Command DumpTypecheckResult
          (\(CompUnit (OfTy _ ty) _, _) -> sexp ty)
          $ T.typeCheck alphaConverted alphaEnv

showTypedAstCmd :: TypedAst CompUnit -> Command (TypedAst CompUnit)
showTypedAstCmd typedAst =
  Command DumpTypedAst sexp $ return typedAst

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


combineAsts :: [RawAst CompUnit] -> RawAst CompUnit
combineAsts cus =
  CompUnit mtSourcePos $ concatMap (\(CompUnit _ bodyEs) -> bodyEs) cus


run :: UserSwitch -> [(FilePath, ProgramText)] -> CommandResult Value
run switch pathsAndSources =
  let runCmd' = runCmd switch
  in do asts <- mapM (runCmd' . uncurry parseCmd) pathsAndSources
        let ast = combineAsts asts
        (alphaConvertedAst, alphaEnv) <- runCmd' $ alphaConvertCmd ast
        (typedAst, alphaEnv') <- runCmd' $ tcCmd alphaConvertedAst alphaEnv
        runCmd' $ showTypedAstCmd typedAst
        runCmd' $ interpCmd typedAst alphaEnv'


getUserSwitch :: [String] -> (UserSwitch, [FilePath])
getUserSwitch [] = error "Usage: interp [-a|-p|-t] FILEPATH"
getUserSwitch ("-p" : paths) = (DumpParseTree, paths)
getUserSwitch ("-a" : paths) = (DumpAlphaConverted, paths)
getUserSwitch ("-tc" : paths) = (DumpTypecheckResult, paths)
getUserSwitch ("-t" : paths) = (DumpTypedAst, paths)
getUserSwitch paths = (Evaluate, paths)


main = do
  args <- getArgs
  let (switch, filePaths) = getUserSwitch args
  sources <- mapM readFile filePaths
  case run switch (zip filePaths sources) of
    Success v -> printf "%s" $ showSexp v
    DumpOutput sexp -> printf "%s" $ show sexp
    Error err -> printf "%s" $ showSexp err
