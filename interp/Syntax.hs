{-# LANGUAGE DeriveGeneric #-}
module Syntax where

import GHC.Generics
import Language.Sexp
import Text.Printf (printf)

type RawId = String

data QualifiedId =
    Id RawId
  | Path QualifiedId RawId
  deriving (Eq, Generic)

instance (Show QualifiedId) where
  show (Id raw) = raw
  show (Path qid raw) =
    printf "%s.%s" (show qid) raw

data CompUnit = CompUnit [Exp]
  deriving (Eq, Generic, Show)

data Exp =
    ExpAdd Exp Exp
  | ExpSub Exp Exp
  | ExpDiv Exp Exp
  | ExpMul Exp Exp
  | ExpNot Exp
  | ExpMemberAccess Exp RawId
  | ExpApp Exp [Exp]
  | ExpImport QualifiedId
  | ExpAssign RawId Exp
  | ExpTypeDec TypeDec
  | ExpModule [Exp]
  | ExpFun RawId [RawId] [Exp]
  | ExpNum String
  | ExpBool Bool
  | ExpRef RawId
  deriving (Eq, Generic, Show)

data TypeDec =
    TypeDecTy RawId Ty
  | TypeDecAdt RawId [AdtAlternative]
  deriving (Eq, Generic, Show)

data AdtAlternative =
    AdtAlternative RawId [Ty]
  deriving (Eq, Generic, Show)

type Ty = QualifiedId

instance Sexpable QualifiedId
instance Sexpable CompUnit
instance Sexpable Exp
instance Sexpable TypeDec
instance Sexpable AdtAlternative

