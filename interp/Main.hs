module Main where

import Control.Monad.Except (runExceptT)
import Data.Functor.Identity (runIdentity)
import Language.Sexp
import qualified Parse
import qualified Semant
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)

showUsage :: IO ()
showUsage = do
  putStrLn "Usage: interp [-p] PROGRAM"
  putStrLn "Options:"
  putStrLn "  -p  Don't run the program, only display the parse tree"

runIt :: String -> IO ()
runIt prog = do
  let v = Semant.interp prog
  case v of
    Left err -> printf "Error: %s" err
    Right v' -> printf "%s" $ show v'

showParseTree :: String -> IO ()
showParseTree prog = do
  let eAst = runIdentity $ runExceptT $ Parse.parse prog
  case eAst of
    Left err -> printf "Error: %s" err
    Right ast -> putStrLn $ show $ printHum $ toSexp ast

main = do
  args <- getArgs
  case args of
    (s:[])      -> runIt s
    ("-p":[s])  -> showParseTree s
    _           -> showUsage
