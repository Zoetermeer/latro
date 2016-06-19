module Sexpable where

import Data.List
import Text.Printf (printf)

data Sexp =
    List [Sexp]
  | Symbol String
  | Atom String

class Sexpable a where
  sexp :: a -> Sexp

instance Show Sexp where
  show (List vs) =
    printf "(%s)" ((intercalate " " . map show) vs)

  show (Symbol v) = v
  show (Atom v) = show v


showSexp :: Sexpable a => a -> String
showSexp v = (show . sexp) v


toSexpList :: Sexpable a => [a] -> Sexp
toSexpList vs = List $ map sexp vs


errorSexp :: String -> Sexp
errorSexp str =
  List [Symbol "Error", Atom str]
