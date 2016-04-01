module Syntax where

type RawId = String

data QualifiedId =
    Id RawId
  | Path QualifiedId RawId
  deriving (Eq, Show)

data CompUnit = CompUnit [Import] [ModuleDec]
  deriving (Eq, Show)

data Import = Import QualifiedId
  deriving (Eq, Show)

data ModuleDec = ModuleDec RawId ModuleExp
  deriving (Eq, Show)

data ModuleExp =
    ModuleExpRef QualifiedId
  | ModuleExpDef [ModuleLevelDec]
  deriving (Eq, Show)

data ModuleLevelDec =
    ModuleLevelDecType TypeDec
  deriving (Eq, Show)

data TypeDec =
    TypeDecTy RawId Ty
  deriving (Eq, Show)

type Ty = QualifiedId
