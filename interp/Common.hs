module Common where

import Data.Monoid

data Env a b = Env [(a, b)]
  deriving (Eq, Show)

instance Monoid (Env a b) where
  mempty = Env []
  mappend (Env a) (Env b) = Env (a <> b)

type FailMessage = String
