module Latro.Output where

import Data.List (intercalate)
import Latro.Sexpable


type HumanReadable = String

class Sexpable a => CompilerOutput a where
  render :: a -> HumanReadable
  renderSexp :: a -> HumanReadable
  renderSexp = showSexp


renderCommaSep :: CompilerOutput a => [a] -> HumanReadable
renderCommaSep as = intercalate ", " $ map render as
