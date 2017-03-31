module Latro.Errors where

import qualified Data.Map as Map
import Latro.Semant


data Err =
    ErrSyntax String
  | ErrNonExhaustivePattern (Typed IL) Value
  | ErrInvalidConstructor UniqId Ty
  | ErrNotAConstructor UniqId
  | ErrNotAnAdt Value
  | ErrInvalidFunPattern
  | ErrInvalidAdtPattern
  | ErrInvalidTypeExp (Exp SourcePos UniqId)
  | ErrPatMatchFail (Typed ILPat) Value
  | ErrPatMatchFailOn SourcePos Value
  | ErrPatMatchBindingFail (ILPat SourcePos) Ty
  | ErrInvalidConsTo Value
  | ErrNonFunDefsInFunDec UniqId
  | ErrNoFunDefGivenFor UniqId
  | ErrFunDefIdMismatch UniqId UniqId
  | ErrFunDefArityMismatch UniqId
  | ErrWrongArity (Typed IL) Int Int
  | ErrWrongMainArity (Untyped IL)
  | ErrMainAlreadyDefined SourcePos
  | ErrMainUndefined
  | ErrCantEvaluate (Typed IL)
  | ErrUnboundRawIdentifier RawId
  | ErrUnboundUniqIdentifier UniqId
  | ErrUnboundQualIdentifier (QualifiedId SourcePos UniqId)
  | ErrIdAlreadyBound UniqId
  | ErrCantUnify Ty Ty
  | ErrUndefinedMember SourcePos UniqId
  | ErrInvalidStructType Ty
  | ErrNotATyCon (SynTy SourcePos UniqId)
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrNoBindingAfterTyAnn RawId
  | ErrCircularType Ty Ty
  | ErrPartialTyConApp (QualifiedId SourcePos UniqId) TyCon [Ty]
  | ErrInvalidRawModulePath (QualifiedId SourcePos RawId)
  | ErrInvalidUniqModulePath (QualifiedId SourcePos UniqId)
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrPrimUnknown RawId
  | ErrProtocolAlreadyImplemented UniqId TyCon
  | ErrMultipleDataDecs UniqId
  | ErrUserFail SourcePos String
  | ErrInterpFailure String
  | ErrNotImplemented String
  | ErrAtPos SourcePos String Err
  | ErrBreak
  deriving (Show)
