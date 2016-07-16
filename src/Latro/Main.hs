module Main where

import AlphaConvert
import Collapse
import Common
import Compiler
import Control.Monad
import Control.Monad.Except
import Control.Monad.State
import Control.Monad.Trans.Class
import Data.Functor.Identity (runIdentity)
import Errors
import Errors.Display
import ILGen
import Parse (parseExp)
import Interp
import Reorder
import Semant
import Semant.Display
import Sexpable
import System.Console.Haskeline
import System.Environment (getArgs)
import Text.Printf (printf)
import Types

type ProgramText = String

data UserSwitch =
    Evaluate
  | DumpParseTree
  | DumpAlphaConverted
  | DumpReordered
  | DumpIL
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


-- parseCmd :: FilePath -> ProgramText -> Command (RawAst CompUnit)
-- parseCmd filePath program =
--   Command DumpParseTree sexp $ parseExp filePath program
-- 
-- alphaConvertCmd :: RawAst CompUnit -> AlphaEnv -> Command (UniqAst CompUnit, AlphaEnv)
-- alphaConvertCmd compUnit alphaEnv =
--   Command DumpAlphaConverted (\\(ac, _) -> sexp ac) $ alphaConvert compUnit alphaEnv
-- 
-- reorderInfixesCmd :: UniqAst CompUnit -> Command (UniqAst CompUnit)
-- reorderInfixesCmd compUnit =
--   Command DumpReordered sexp $ reorderInfixes compUnit
-- 
-- ilGenCmd :: UniqAst CompUnit -> Command (Untyped ILCompUnit)
-- ilGenCmd cu =
--   Command DumpIL sexp $ return $ ilGenCompUnit cu
-- 
-- tcCmd :: Untyped ILCompUnit -> AlphaEnv -> Command (Typed ILCompUnit, AlphaEnv)
-- tcCmd untypedIL alphaEnv =
--   Command DumpTypecheckResult
--           (\\(ILCompUnit (OfTy _ ty) _, _) -> sexp ty)
--           $ T.typeCheck untypedIL alphaEnv
-- 
-- showTypedAstCmd :: Typed ILCompUnit -> Command (Typed ILCompUnit)
-- showTypedAstCmd typedIL =
--   Command DumpTypedAst sexp $ return typedIL
-- 
-- 
-- runCmd :: UserSwitch -> Command a -> CommandResult a
-- runCmd switch (Command dumpOnSwitch dumpSexp result) =
--   case result of
--     Left err -> Error err
--     Right v ->
--       if switch == dumpOnSwitch
--       then DumpOutput $ dumpSexp v
--       else Success v


combineAsts :: [RawAst CompUnit] -> RawAst CompUnit
combineAsts cus =
  CompUnit mtSourcePos $ concatMap (\(CompUnit _ bodyEs) -> bodyEs) cus


getUserSwitch :: [String] -> (UserSwitch, [FilePath])
getUserSwitch [] = error "Usage: latro [-a|-p|-t] FILEPATH"
getUserSwitch ("-p" : paths) = (DumpParseTree, paths)
getUserSwitch ("-a" : paths) = (DumpAlphaConverted, paths)
getUserSwitch ("-r" : paths) = (DumpReordered, paths)
getUserSwitch ("-il" : paths) = (DumpIL, paths)
getUserSwitch ("-tc" : paths) = (DumpTypecheckResult, paths)
getUserSwitch ("-t" : paths) = (DumpTypedAst, paths)
getUserSwitch paths = (Evaluate, paths)


type Repl a = ExceptT Err (StateT CompilerEnv IO) a


-- run :: CompilerEnv -> UserSwitch -> [(FilePath, ProgramText)] -> CommandResult (Typed ILCompUnit, AlphaEnv)
-- run env switch pathsAndSources =
--   let runCmd' = runCmd switch
--   in do asts <- mapM (runCmd' . uncurry parseCmd) pathsAndSources
--         let ast = combineAsts asts
--         (alphaConvertedAst, alphaEnv) <- runCmd' $ alphaConvertCmd ast $ alphaEnv env
--         reorderedAst <- runCmd' $ reorderInfixesCmd alphaConvertedAst
--         il <- runCmd' $ ilGenCmd reorderedAst
--         (typedIL, alphaEnv') <- runCmd' $ tcCmd il alphaEnv
--         runCmd' $ showTypedAstCmd typedIL
--         return (typedIL, alphaEnv')


repl :: ProgramText -> CompilerPass CompilerEnv (Typed ILCompUnit)
repl input = do
  let parseResult = parseExp "<<repl>>" input
  case parseResult of
    Left err -> throwError err
    Right ast -> do collapsedAst <- runCollapseFunClauses ast
                    alphaConvertedAst <- runAlphaConvert collapsedAst
                    reorderedAst <- runReorderInfixes alphaConvertedAst
                    untypedIL <- runILGen reorderedAst
                    typedIL <- runTypecheck untypedIL
                    return typedIL


getReplInput :: InputT IO (Maybe ProgramText)
getReplInput = do
  input <- getInputLine "λ> "
  case input of
    Nothing -> return Nothing
    Just input ->
      case words input of
        [] -> return Nothing
        [":q"] -> return Nothing
        [":l", inputFilePath] -> do
          content <- lift $ readFile inputFilePath
          return $ Just content
        _ -> return $ Just input


runInteractive :: IO ()
runInteractive = runInputT defaultSettings $ loop mt
  where loop :: CompilerEnv -> InputT IO ()
        loop compilerEnv = do
          coreSource <- lift $ readFile "./lib/Core.l"
          input <- getReplInput
          case input of
            Nothing -> return ()
            Just source ->
              let (semantResult, compilerEnv') = runState (runExceptT (repl source)) compilerEnv
              in case semantResult of
                  Right typedIL -> do
                    outputStrLn $ showSexp typedIL
                    (result, compilerEnv'') <- lift $ runStateT (runExceptT (runInterp typedIL)) compilerEnv'
                    case result of
                      Left err  -> outputStrLn $ showSexp err
                      Right v   -> outputStrLn $ show v
                    loop compilerEnv''
                  Left err -> do { outputStrLn $ printf "%s" $ showSexp err; loop compilerEnv }


-- runInterp :: [String] -> IO ()
-- runInterp args = do
--   let (switch, filePaths) = getUserSwitch args
--   sources <- mapM readFile filePaths
--   case run mt switch (zip filePaths sources) of
--     Success (il, alphaEnv) -> do
--       result <- Interp.interp il alphaEnv
--       case result of
--         Left err -> putStrLn $ showSexp err
--         Right v -> putStrLn $ show v
--     DumpOutput sexp -> printf "%s" $ show sexp
--     Error err -> printf "%s" $ showSexp err

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> runInteractive
    -- _ -> runInterp args
