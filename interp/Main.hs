module Main where

import qualified Semant
import System.Environment (getArgs)
import Test.Hspec
import Text.Printf (printf)

runIt :: String -> IO ()
runIt prog = do
  let v = Semant.interp prog
  case v of
    Left err -> printf "Error: %s" err
    Right v' -> printf "%s" $ show v'

main = do
  args <- getArgs
  case args of
    (s:_) -> runIt s
    [] -> putStrLn "No input program given."
