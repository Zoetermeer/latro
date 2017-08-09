module Latro.Errors where

import qualified Data.Map as Map
import Latro.Ast
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
  | ErrUnboundConstructor (QualifiedId SourcePos UniqId)
  | ErrIdAlreadyBound UniqId
  | ErrCantUnify Ty Ty
  | ErrUndefinedMember SourcePos UniqId
  | ErrInvalidStructType Ty
  | ErrUnboundStructField (QualifiedId SourcePos UniqId) UniqId
  | ErrNotATyCon (SynTy SourcePos UniqId)
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrNoBindingAfterTyAnn RawId
  | ErrCircularType Ty Ty
  | ErrWrongTyConArity TyCon [Ty]
  | ErrNotPolymorphicType TyCon [Ty]
  | ErrUnboundRawModulePath (QualifiedId SourcePos RawId)
  | ErrUnboundUniqModulePath (QualifiedId SourcePos UniqId)
  | ErrOverlappingVarImport (QualifiedId SourcePos UniqId) [RawId]
  | ErrOverlappingTyImport (QualifiedId SourcePos UniqId) [RawId]
  | ErrOverlappingCtorImport (QualifiedId SourcePos UniqId) [RawId]
  | ErrOverlappingProtoImport (QualifiedId SourcePos UniqId) [RawId]
  | ErrIllegalTopLevelTypeModule (QualifiedId SourcePos UniqId)
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrPrimUnknown RawId
  | ErrPrimTypeUnknown RawId
  | ErrProtocolAlreadyImplemented UniqId TyCon
  | ErrInvalidConstraints UniqId
  | ErrDoesNotImplementProtocol TyCon ProtocolId
  | ErrCannotResolveProtocolImp Ty ProtocolId
  | ErrCannotResolveMethod Ty MethodId
  | ErrUnknownMethodId MethodId ProtocolId
  | ErrMultipleDataDecs (QualifiedId SourcePos UniqId)
  | ErrUserFail SourcePos String
  | ErrInterpFailure String
  | ErrNotImplemented String
  | ErrAtPos SourcePos String Err
  | ErrBreak
  deriving (Show)
