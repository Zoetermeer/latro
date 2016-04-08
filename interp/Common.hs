module Common where

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
