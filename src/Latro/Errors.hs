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
  | ErrPatMatchBindingFail (ILPat SourcePos) Ty
  | ErrInvalidConsTo Value
  | ErrNonFunDefsInFunDec UniqId
  | ErrNoFunDefGivenFor UniqId
  | ErrNoInstFunDefGivenFor UniqId
  | ErrFunDefIdMismatch UniqId UniqId
  | ErrFunDefArityMismatch UniqId
  | ErrWrongArity (Typed IL) Int Int
  | ErrCantEvaluate (Exp CheckedData UniqId)
  | ErrUnboundRawIdentifier RawId
  | ErrUnboundUniqIdentifier UniqId
  | ErrIdAlreadyBound UniqId
  | ErrCantUnify Ty Ty
  | ErrUndefinedMember SourcePos UniqId
  | ErrInvalidStructType Ty
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrNoBindingAfterTyAnn RawId
  | ErrCircularType Ty Ty
  | ErrPartialTyConApp (QualifiedId SourcePos UniqId) TyCon [Ty]
  | ErrInvalidRawModulePath (QualifiedId SourcePos RawId)
  | ErrInvalidUniqModulePath (QualifiedId SourcePos UniqId)
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrUserFail SourcePos String
  | ErrInterpFailure String
  | ErrNotImplemented String
  | ErrAtPos SourcePos String Err
  deriving (Show)
