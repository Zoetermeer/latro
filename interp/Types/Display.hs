module Types.Display where

import Common
import Data.List (intercalate)
import Text.Printf (printf)
import Types

instance PrettyShow Ty where
  showShort (App tyCon tys) =
    printf "(App %s %s)"
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
