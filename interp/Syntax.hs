module Syntax where

import Common (PrettyShow(..))
import Data.List
import Text.Printf (printf)

type RawId = String

data QualifiedId id =
    Id id
  | Path (QualifiedId id) id
  deriving (Eq)

instance Show id => Show (QualifiedId id) where
  show (Id raw) = show raw
  show (Path qid raw) =
    printf "%s.%s" (show qid) $ show raw

data CompUnit id = CompUnit [Exp id]
  deriving (Eq, Show)

data Exp id =
    ExpAdd (Exp id) (Exp id)
  | ExpSub (Exp id) (Exp id)
  | ExpDiv (Exp id) (Exp id)
  | ExpMul (Exp id) (Exp id)
  | ExpNot (Exp id)
  | ExpMemberAccess (Exp id) id
  | ExpApp (Exp id) [Exp id]
  | ExpImport (QualifiedId id)
  | ExpAssign id (Exp id)
  | ExpTypeDec (TypeDec id)
  | ExpFunDec (FunDec id)
  | ExpModule [Exp id]
  | ExpStruct (Exp id) [(id, Exp id)]
  | ExpIfElse (Exp id) [Exp id] [Exp id]
  | ExpMakeAdt (Ty id) Int [Exp id]
  | ExpTuple [Exp id]
  | ExpNum String
  | ExpBool Bool
  | ExpRef id
  | ExpUnit
  deriving (Eq, Show)

data TypeDec id =
    TypeDecTy id (Ty id)
  | TypeDecAdt id [AdtAlternative id]
  deriving (Eq, Show)

data AdtAlternative id =
    AdtAlternative id Int [Ty id]
  deriving (Eq, Show)

instance Show id => PrettyShow (AdtAlternative id) where
  showShort (AdtAlternative id i tys) =
    printf "%s@%i [%s]"
           (show id)
           i
           ((intercalate ", " . map show) tys)

data Ty id =
    TyInt
  | TyBool
  | TyUnit
  | TyArrow [Ty id] (Ty id)
  | TyModule
  | TyInterface
  | TyStruct [(id, (Ty id))]
  | TyAdt id [AdtAlternative id]
  | TyTuple [Ty id]
  | TyRef (QualifiedId id)
  deriving (Eq, Show)

instance Show id => PrettyShow (Ty id) where
  showShort TyInt = "<<Int>>"
  showShort TyBool = "<<Bool>>"
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
           ((intercalate ", " . map (\(id, ty) -> printf "%s %s" (show id) (showShort ty))) fields)

  showShort (TyAdt id alts) =
    printf "<<adt %s [%s]>>"
           (show id)
           ((intercalate ", " . map showShort) alts)

  showShort (TyTuple tys) =
    printf "<<tuple (%s)>>"
           ((intercalate " * " . map showShort) tys)

  showShort (TyRef qid) = show qid


data FunDec id =
    FunDecFun id (Ty id) [FunDef id]
  | FunDecInstFun id (Ty id) (Ty id) [FunDef id]
  deriving (Eq, Show)

data FunDef id =
    FunDefFun id [PatExp id] [Exp id]
  | FunDefInstFun (PatExp id) id [PatExp id] [Exp id]
  deriving (Eq, Show)

data PatExp id = PatExpVar id
  deriving (Eq, Show)
