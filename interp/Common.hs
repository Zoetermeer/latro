module Common where

import Data.List
import Data.Monoid

data Env a b = Env [(a, b)]
  deriving (Eq, Show)

instance Monoid (Env a b) where
  mempty = Env []
  mappend (Env a) (Env b) = Env (a <> b)

type FailMessage = String

class Show a => PrettyShow a where
  showShort :: a -> String
  showLong :: a -> String
  showLong x = show x


mapInd :: (Int -> a -> b) -> Int -> [a] -> [b]
mapInd _ _ [] = []
mapInd f i (x:xs) =
  (f i x):(mapInd f (i + 1) xs)

mapi :: (Int -> a -> b) -> [a] -> [b]
mapi _ [] = []
mapi f xs = mapInd f 0 xs
