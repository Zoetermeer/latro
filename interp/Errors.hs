module Errors where

import qualified Data.Map as Map
import Semant


data Err =
    ErrSyntax String
  | ErrNonExhaustivePattern Value
  | ErrInvalidConstructor UniqId Ty
  | ErrNotAConstructor UniqId
  | ErrNotAnAdt Value
  | ErrInvalidFunPattern
  | ErrInvalidAdtPattern
  | ErrInvalidTypeExp (Exp SourcePos UniqId)
  | ErrNumLitPatMatchFail Int Int
  | ErrBoolLitPatMatchFail Bool Bool
  | ErrListPatMatchFail Value
  | ErrPatMatchFailOn Value
  | ErrPatMatchBindingFail (PatExp SourcePos UniqId) Ty
  | ErrInvalidConsTo Value
  | ErrNonFunDefsInFunDec UniqId
  | ErrNoFunDefGivenFor UniqId
  | ErrNoInstFunDefGivenFor UniqId
  | ErrFunDefIdMismatch UniqId UniqId
  | ErrFunDefArityMismatch UniqId
  | ErrCantEvaluate (Exp CheckedData UniqId)
  | ErrUnboundRawIdentifier RawId
  | ErrUnboundUniqIdentifier UniqId
  | ErrCantUnify Ty Ty
  | ErrUndefinedMember UniqId
  | ErrInvalidStructType TyCon
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrCircularType Ty
  | ErrPartialTyConApp (QualifiedId UniqId) TyCon [Ty]
  | ErrInvalidModulePath (QualifiedId UniqId)
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrInterpFailure String
  | ErrNotImplemented String
  deriving (Show)
