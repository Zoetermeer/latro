module Types.Display where

import Common
import Data.List (intercalate)
import Text.Printf (printf)
import Types

instance PrettyShow TCError where
  showShort ErrNotImplemented = "Not implemented!"
  showShort (ErrCantUnify tya tyb) =
    printf "(Error \"Expected '%s' but instead got: '%s'\")"
           (showShort tya)
           (showShort tyb)

instance Show TCError where
  show e = showShort e

instance PrettyShow Ty where
  showShort (App Int []) = "Int"
  showShort (App Bool []) = "Bool"
  showShort (App String []) = "String"
  showShort (App tyCon tys) =
    printf "(App %s (%s))"
           (showShort tyCon)
           ((intercalate " " . map showShort) tys)
  showShort (Poly tyVars ty) =
    printf "(Poly (%s) %s)"
           ((intercalate " " . map showShort) tyVars)
           (showShort ty)
  showShort (Var tyVar) = printf "(Var %s)" $ showShort tyVar


instance PrettyShow TyCon where
  showShort Int = "Int"
  showShort Bool = "Bool"
  showShort String = "String"
  showShort Unit = "Unit"
  showShort List = "List"
  showShort Tuple = "Tuple"
