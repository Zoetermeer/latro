module Types.Display where

import Common
import Data.List (intercalate)
import Semant
import Semant.Display
import Sexpable
import Text.Printf (printf)
import Types


instance Sexpable Ty where
  sexp (TyApp TyConInt []) = Symbol "Int"
  sexp (TyApp TyConBool []) = Symbol "Bool"
  sexp (TyApp TyConString []) = Symbol "String"
  sexp (TyApp tyCon tys) =
    List  [ Symbol "App"
          , sexp tyCon
          , toSexpList tys
          ]

  sexp (TyPoly tyVars ty) =
    List  [ Symbol "Poly"
          , toSexpList tyVars
          , sexp ty
          ]

  sexp (TyVar tyVar) = List [ Symbol "Var", sexp tyVar ]
  sexp (TyMeta id) = List [ Symbol "Meta", sexp id ]
  sexp TyAny = Symbol "Any"


instance Sexpable TyCon where
  sexp TyConInt = Symbol "Int"
  sexp TyConBool = Symbol "Bool"
  sexp TyConString = Symbol "String"
  sexp TyConUnit = Symbol "Unit"
  sexp TyConList = Symbol "List"
  sexp TyConTuple = Symbol "Tuple"
  sexp TyConArrow = Symbol "Arrow"
  sexp (TyConStruct fieldNames) =
    List [ Symbol "Struct", toSexpList fieldNames ]
