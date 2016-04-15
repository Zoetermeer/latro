module Syntax.Display where

import Common(PrettyShow(..))
import Data.List (intercalate)
import Syntax
import Text.Printf (printf)

instance PrettyShow id => PrettyShow (QualifiedId id) where
  showShort (Id raw) = showShort raw
  showShort (Path qid raw) =
    printf "%s.%s" (showShort qid) $ showShort raw

instance PrettyShow id => PrettyShow (AdtAlternative id) where
  showShort (AdtAlternative id i tys) =
    printf "%s@%i [%s]"
           (showShort id)
           i
           ((intercalate ", " . map show) tys)

instance PrettyShow id => PrettyShow (Ty id) where
  showShort TyInt = "<<Int>>"
  showShort TyBool = "<<Bool>>"
  showShort TyString = "<<String>>"
  showShort TyUnit = "<<Unit>>"
  showShort (TyArrow paramTys retTy) =
    printf "<<%s -> %s>>"
           ((intercalate " -> " . map showShort) paramTys)
           (showShort retTy)

  showShort TyModule = "<<Module>>"
  showShort TyInterface = "<<Interface>>"
  showShort (TyStruct []) = "<<{ }>>"

  showShort (TyStruct fields) =
    printf "<<{ %s }>>"
           ((intercalate ", " . map (\(id, ty) -> printf "%s %s" (showShort id) (showShort ty))) fields)

  showShort (TyAdt id alts) =
    printf "<<adt %s [%s]>>"
           (showShort id)
           ((intercalate ", " . map showShort) alts)

  showShort (TyTuple tys) =
    printf "<<tuple (%s)>>"
           ((intercalate " * " . map showShort) tys)

  showShort (TyList ty) =
    printf "<<%s list>>" $ showShort ty

  showShort (TyRef qid) = showShort qid
