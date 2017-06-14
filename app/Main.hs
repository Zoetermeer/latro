module Main where

import Control.Monad.Except
import Control.Monad.State
import Data.Char (toLower)
import Latro.AlphaConvert
import Latro.Ast
import Latro.Collapse
import Latro.Compiler
import Latro.Errors.Display ()
import Latro.ILGen
import Latro.Interp
import Latro.Output
import Latro.Parser
import Latro.Reorder
import Latro.Semant
import Latro.Semant.Display ()
import Latro.Types
import System.Console.GetOpt
import System.Console.Haskeline
import System.Environment (getArgs)
import System.Exit
import System.IO (hPutStrLn, stderr)


combineAsts :: [RawAst CompUnit] -> RawAst CompUnit
combineAsts cus =
  CompUnit mtSourcePos $ concatMap (\(CompUnit _ bodyEs) -> bodyEs) cus


flags =
  [ Option "a" [] (ReqArg (OptShowPhaseOutput . readPhaseName) "PHASE")
      "Stop after PHASE and show its output"
  , Option "e" ["eval"] (ReqArg OptEvaluateExpr "EXPR")
      "Evaluate 'expr' in an interactive-prompt style context"
  , Option "l" ["lib"] (ReqArg OptLoadFile "FILE")
      "Load FILE as a library source (useful in concert with -e)"
  , Option "i" ["repl"] (NoArg OptInteractive)
      "Run interactive read-eval-print loop"
  , Option "s" ["sexp"] (NoArg OptSexp)
      "Display output as an s-expression (only available in non-interactive mode)"
  , Option "h" ["help"] (NoArg OptHelp)
      "Show help"
  ]


data Phase =
    PhaseParse
  | PhaseCollapse
  | PhaseAlphaConvert
  | PhaseInfixReorder
  | PhaseILGen
  | PhaseTypecheckType
  | PhaseTypecheckAst
  | PhaseUnknown String
  deriving (Eq, Show)


readPhaseName :: String -> Phase
readPhaseName name =
  case map toLower name of
    "parse"    -> PhaseParse
    "collapse" -> PhaseCollapse
    "alpha"    -> PhaseAlphaConvert
    "infix"    -> PhaseInfixReorder
    "ilgen"    -> PhaseILGen
    "type"     -> PhaseTypecheckType
    "typed"    -> PhaseTypecheckAst
    _          -> PhaseUnknown name


data Opt =
    OptShowPhaseOutput Phase
  | OptEvaluateExpr ProgramText
  | OptLoadFile FilePath
  | OptInteractive
  | OptSexp
  | OptHelp
  deriving (Eq, Show)


optEnabled :: Opt -> [Opt] -> Bool
optEnabled = elem


data ReplCmd =
    ReplCmdQuit
  | ReplCmdLibFile FilePath
  | ReplCmdShowType ProgramText
  | ReplCmdEval ProgramText
  deriving (Eq)


type ProgramText = String


data SourceBuf =
    SourceBufFile FilePath ProgramText
  | SourceBufRepl ProgramText


fileSourceBufs :: [FilePath] -> [ProgramText] -> [SourceBuf]
fileSourceBufs = zipWith SourceBufFile


renderOutput :: CompilerOutput a => [Opt] -> (a -> String)
renderOutput opts | optEnabled OptSexp opts = renderSexp
                  | otherwise               = render


breakIfOpt :: CompilerOutput a => [Opt] -> Opt -> CompilerPass CompilerEnv a -> GenericCompilerPass HumanReadable CompilerEnv a
breakIfOpt opts opt m = do
  result <- withExceptT (renderOutput opts) m
  if optEnabled opt opts
    then ExceptT . return $ Left $ (renderOutput opts) result
    else return result


parseBuf :: [Opt] -> SourceBuf -> GenericCompilerPass HumanReadable CompilerEnv (RawAst CompUnit)
parseBuf opts buf =
    withExceptT (renderOutput opts) $ ExceptT . return $ syntaxRule path source
  where
    (path, source, syntaxRule) = case buf of
      SourceBufFile path source -> (path, source, parseTopLevel)
      SourceBufRepl source      -> ("<<repl>>", source, parseInteractive)


semAnal :: [SourceBuf] -> [Opt] -> GenericCompilerPass HumanReadable CompilerEnv (Typed ILCompUnit)
semAnal sourceBufs opts = do
    asts <- mapM (parseBuf opts) sourceBufs
    let ast = combineAsts asts
    ast' <- dumpOnPhase PhaseParse $ return ast
    collapsedAst <- dumpOnPhase PhaseCollapse $ runCollapseFunClauses ast
    alphaConvertedAst <- dumpOnPhase PhaseAlphaConvert $ runAlphaConvert collapsedAst
    reorderedAst <- dumpOnPhase PhaseInfixReorder $ runReorderInfixes alphaConvertedAst
    untypedIL <- dumpOnPhase PhaseILGen $ runILGen reorderedAst
    (ty, typedIL) <- withExceptT (renderOutput opts) $ runTypecheck untypedIL
    case opts of
      _ | optEnabled (OptShowPhaseOutput PhaseTypecheckType) opts -> throwError $ (renderOutput opts) ty
        | optEnabled (OptShowPhaseOutput PhaseTypecheckAst) opts  -> throwError $ (renderOutput opts) typedIL
        | otherwise -> return typedIL
  where
    dumpOnPhase ph = breakIfOpt opts $ OptShowPhaseOutput ph


eval :: [SourceBuf] -> [Opt] -> GenericCompilerPassT HumanReadable CompilerEnv IO Value
eval sourceBufs opts = do
  compilerEnv <- get
  let (semantResult, compilerEnv') = runState (runExceptT (semAnal sourceBufs opts)) compilerEnv
  case semantResult of
    Left sxp -> ExceptT . return $ Left sxp
    Right typedIL -> do put compilerEnv'
                        withExceptT (renderOutput opts) $ interp typedIL $ not $ optEnabled OptInteractive opts


readReplCmd :: InputT IO ReplCmd
readReplCmd = do
  input <- getInputLine "λ> "
  case input of
    Nothing -> return ReplCmdQuit
    Just input ->
      case words input of
        [] -> return ReplCmdQuit
        [":q"] -> return ReplCmdQuit
        (":t" : rest) ->
          return $ ReplCmdShowType $ unwords rest
        [":l", inputFilePath] ->
          return $ ReplCmdLibFile inputFilePath
        _ -> return $ ReplCmdEval input


loadLibFiles :: [Opt] -> CompilerEnv -> InputT IO (Either HumanReadable Value, CompilerEnv)
loadLibFiles (OptLoadFile path : opts) compilerEnv = do
  content <- lift $ readFile path
  (_, compilerEnv') <- lift $ runStateT (runExceptT (eval [SourceBufFile path content] opts)) compilerEnv
  loadLibFiles opts compilerEnv'
loadLibFiles (_ : opts) compilerEnv = loadLibFiles opts compilerEnv
loadLibFiles [] compilerEnv = return (Right ValueUnit, compilerEnv)


handleEvalResult :: (CompilerEnv -> InputT IO ())
                 -> (Value -> InputT IO ())
                 -> InputT IO (Either HumanReadable Value, CompilerEnv)
                 -> InputT IO ()
handleEvalResult k vHandler result = do
  (result, compilerEnv) <- result
  case result of
    Left output -> outputStrLn output
    Right v ->
      case v of
        ValueUnit -> return ()
        _         -> vHandler v
  k compilerEnv


runRepl :: [Opt] -> IO ()
runRepl opts =
    runInputT defaultSettings $ handleEvalResult loop (\_ -> return ()) $ loadLibFiles opts mt
  where env = mt :: CompilerEnv
        loop :: CompilerEnv -> InputT IO ()
        loop compilerEnv = do
          cmd <- readReplCmd
          case cmd of
            ReplCmdQuit -> return ()
            ReplCmdLibFile filePath -> do
              content <- lift $ readFile filePath
              let result = lift $ runStateT (runExceptT (eval [SourceBufFile filePath content] opts)) compilerEnv
              handleEvalResult loop (outputStrLn . render) result
            ReplCmdShowType input ->
              let opts' = OptShowPhaseOutput PhaseTypecheckType : opts
                  result = lift $ runStateT (runExceptT (eval [SourceBufRepl input] opts')) compilerEnv
              in handleEvalResult loop (outputStrLn . render) result
            ReplCmdEval input -> do
              let result = lift $ runStateT (runExceptT (eval [SourceBufRepl input] opts)) compilerEnv
              handleEvalResult loop (outputStrLn . render) result


runProgram :: [Opt] -> [FilePath] -> IO ()
runProgram opts filePaths = do
  sources <- mapM readFile filePaths
  (result, _) <- runStateT (runExceptT (eval (fileSourceBufs filePaths sources) opts)) mt
  case result of
    Left output -> putStrLn output
    Right v     ->
      case v of
        ValueUnit -> return ()
        _         -> putStrLn $ (renderOutput opts) v


header = "Usage: latro [-aelis] [FILE ...]"


parseOpts :: [String] -> IO ([Opt], [FilePath])
parseOpts args =
  case getOpt Permute flags args of
    (opts, fs, []) -> return (opts, fs)
    (_, _, errs)   -> do
      hPutStrLn stderr (concat errs ++ usageInfo header flags)
      exitWith (ExitFailure 1)


main :: IO ()
main = do
  args <- getArgs
  (opts, inputFiles) <- parseOpts args
  case () of
    _ | optEnabled OptHelp opts -> do
        hPutStrLn stderr (usageInfo header flags)
        exitSuccess
      | optEnabled OptInteractive opts -> runRepl opts
      | null inputFiles -> runRepl (OptInteractive : opts)
      | otherwise -> runProgram opts inputFiles
