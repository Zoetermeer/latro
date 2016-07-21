module Main where

import AlphaConvert
import Collapse
import Common
import Compiler
import Control.Exception.Base (evaluate)
import Control.Monad
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Trans.Class
import Data.Functor.Identity (runIdentity)
import Data.List (intersperse)
import Errors
import Errors.Display
import ILGen
import Parse
import Interp
import Reorder
import Semant
import Semant.Display
import Sexpable
import System.Console.Haskeline
import System.Environment (getArgs)
import Text.Printf (printf)
import Types


combineAsts :: [RawAst CompUnit] -> RawAst CompUnit
combineAsts cus =
  CompUnit mtSourcePos $ concatMap (\(CompUnit _ bodyEs) -> bodyEs) cus


getUserOpts :: [String] -> ([Opt], [FilePath])
getUserOpts [] = error "Usage: latro [-a|-p|-t] FILEPATH"
getUserOpts ("-p" : paths) = ([OptDumpParseTree], paths)
getUserOpts ("-a" : paths) = ([OptDumpAlphaConverted], paths)
getUserOpts ("-r" : paths) = ([OptDumpReordered], paths)
getUserOpts ("-il" : paths) = ([OptDumpIL], paths)
getUserOpts ("-tc" : paths) = ([OptDumpType], paths)
getUserOpts ("-t" : paths) = ([OptDumpTypedAst], paths)
getUserOpts paths = ([], paths)


data Opt =
    OptDumpParseTree
  | OptDumpAlphaConverted
  | OptDumpReordered
  | OptDumpIL
  | OptDumpType
  | OptDumpTypedAst
  deriving (Eq, Show)


optEnabled :: Opt -> [Opt] -> Bool
optEnabled = elem


data Cmd =
    CmdQuit
  | CmdInterpFiles [FilePath] [Opt]
  | CmdInterp ProgramText [Opt]
  deriving (Eq, Show)


type ProgramText = String


data SourceBuf =
    SourceBufFile FilePath ProgramText
  | SourceBufRepl ProgramText


fileSourceBufs :: [FilePath] -> [ProgramText] -> [SourceBuf]
fileSourceBufs = zipWith SourceBufFile


breakIfOpt :: Sexpable a => [Opt] -> Opt -> CompilerPass CompilerEnv a -> GenericCompilerPass Sexp CompilerEnv a
breakIfOpt opts opt m = do
  result <- withExceptT sexp m
  if optEnabled opt opts
    then ExceptT . return $ Left $ sexp result
    else return result


parseBuf :: SourceBuf -> GenericCompilerPass Sexp CompilerEnv (RawAst CompUnit)
parseBuf buf =
    withExceptT sexp $ ExceptT . return $ syntaxRule path source
  where
    (path, source, syntaxRule) = case buf of
      SourceBufFile path source -> (path, source, parseTopLevel)
      SourceBufRepl source      -> ("<<repl>>", source, parseInteractive)


semAnal :: [SourceBuf] -> [Opt] -> GenericCompilerPass Sexp CompilerEnv (Typed ILCompUnit)
semAnal sourceBufs opts = do
  asts <- mapM parseBuf sourceBufs
  let ast = combineAsts asts
  collapsedAst <- withExceptT sexp $ runCollapseFunClauses ast
  alphaConvertedAst <- dumpOn OptDumpAlphaConverted $ runAlphaConvert collapsedAst
  reorderedAst <- dumpOn OptDumpReordered $ runReorderInfixes alphaConvertedAst
  untypedIL <- dumpOn OptDumpIL $ runILGen reorderedAst
  (ty, typedIL) <- withExceptT sexp $ runTypecheck untypedIL
  if optEnabled OptDumpType opts
    then throwError $ sexp ty
    else return typedIL
  where
    dumpOn opt = breakIfOpt opts opt


eval :: [SourceBuf] -> [Opt] -> GenericCompilerPassT Sexp CompilerEnv IO Value
eval sourceBufs opts = do
  compilerEnv <- get
  let (semantResult, compilerEnv') = runState (runExceptT (semAnal sourceBufs opts)) compilerEnv
  case semantResult of
    Left sxp -> ExceptT . return $ Left sxp
    Right typedIL -> do put compilerEnv'
                        withExceptT sexp $ interp typedIL


readInput :: InputT IO (Maybe (ProgramText, [Opt]))
readInput = do
  input <- getInputLine "λ> "
  case input of
    Nothing -> return Nothing
    Just input ->
      case words input of
        [] -> return Nothing
        [":q"] -> return Nothing
        (":t" : rest) ->
          return $ Just (unwords rest, [OptDumpType])
        [":l", inputFilePath] -> do
          content <- lift $ readFile inputFilePath
          return $ Just (content, [])
        _ -> return $ Just (input, [])


runRepl :: IO ()
runRepl = runInputT defaultSettings $ loop mt
  where loop :: CompilerEnv -> InputT IO ()
        loop compilerEnv = do
          inputAndOpts <- readInput
          case inputAndOpts of
            Nothing -> return ()
            Just (source, opts) -> do
              (result, compilerEnv') <- lift $ runStateT (runExceptT (eval [SourceBufRepl source] opts)) compilerEnv
              case result of
                Left sxp -> outputStrLn $ show sxp
                Right v   -> outputStrLn $ show v
              loop compilerEnv'


runProgram :: [String] -> IO ()
runProgram args = do
  let (opts, filePaths) = getUserOpts args
  sources <- mapM readFile filePaths
  (result, _) <- runStateT (runExceptT (eval (fileSourceBufs filePaths sources) opts)) mt
  case result of
    Left sxp  -> print sxp
    Right v   -> print v


main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> runRepl
    _ -> runProgram args
