module Syntax where

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
  | ExpIfElse (Exp id) [Exp id] [Exp id]
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
    AdtAlternative id [Ty id]
  deriving (Eq, Show)

data Ty id =
    TyInt
  | TyBool
  | TyUnit
  | TyArrow [Ty id] (Ty id)
  | TyModule
  | TyInterface
  | TyRef (QualifiedId id)
  deriving (Eq, Show)

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
