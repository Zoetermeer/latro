module Syntax where

type RawId = String

data QualifiedId =
    Id RawId
  | Path QualifiedId RawId
  deriving (Eq, Show)

data CompUnit = CompUnit [Exp]
  deriving (Eq, Show)

data Exp =
    ExpAdd Exp Exp
  | ExpSub Exp Exp
  | ExpDiv Exp Exp
  | ExpMul Exp Exp
  | ExpNot Exp
  | ExpApp Exp [Exp]
  | ExpImport QualifiedId
  | ExpAssign RawId Exp
  | ExpTypeDec TypeDec
  | ExpModule [Exp]
  | ExpStms [Stm] Exp
  | ExpNum String
  | ExpBool Bool
  | ExpQualId QualifiedId
  deriving (Eq, Show)

data Stm =
    StmImport QualifiedId
  | StmAssign RawId Exp
  | StmTypeDec TypeDec
  deriving (Eq, Show)

data ModuleLevelDec =
    ModuleLevelDecType TypeDec
  deriving (Eq, Show)

data TypeDec =
    TypeDecTy RawId Ty
  | TypeDecAdt RawId [AdtAlternative]
  deriving (Eq, Show)

data AdtAlternative =
    AdtAlternative RawId [Ty]
  deriving (Eq, Show)

type Ty = QualifiedId
