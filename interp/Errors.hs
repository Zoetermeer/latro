module Errors where

import qualified Data.Map as Map
import Semant


data Err =
    ErrSyntax String
  | ErrNonExhaustivePattern (TypedAst Exp) Value
  | ErrInvalidConstructor UniqId Ty
  | ErrNotAConstructor UniqId
  | ErrNotAnAdt Value
  | ErrInvalidFunPattern
  | ErrInvalidAdtPattern
  | ErrInvalidTypeExp (Exp SourcePos UniqId)
  | ErrPatMatchFail (TypedAst PatExp) Value
  | ErrPatMatchFailOn SourcePos Value
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
  | ErrUndefinedMember SourcePos UniqId
  | ErrInvalidStructType Ty
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrCircularType Ty
  | ErrPartialTyConApp (QualifiedId SourcePos UniqId) TyCon [Ty]
  | ErrInvalidModulePath (QualifiedId SourcePos UniqId)
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrUserFail SourcePos String
  | ErrInterpFailure String
  | ErrNotImplemented String
  | ErrAtPos SourcePos Err
  deriving (Show)
