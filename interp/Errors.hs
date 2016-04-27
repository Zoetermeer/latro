module Errors where

import qualified Data.Map as Map
import Semant


data Err =
    ErrSyntax String
  | ErrNonExhaustivePattern Value
  | ErrInvalidConstructor UniqId (SynTy UniqId)
  | ErrNotAConstructor UniqId
  | ErrNotAnAdt Value
  | ErrInvalidAdtPattern
  | ErrInvalidTypeExp (Exp UniqId)
  | ErrNumLitPatMatchFail Int Int
  | ErrBoolLitPatMatchFail Bool Bool
  | ErrListPatMatchFail Value
  | ErrPatMatchFailOn Value
  | ErrInvalidConsTo Value
  | ErrNoFunDefGivenFor UniqId
  | ErrNoInstFunDefGivenFor UniqId
  | ErrCantEvaluate (Exp UniqId)
  | ErrUnboundRawIdentifier RawId
  | ErrUnboundUniqIdentifier UniqId
  | ErrFunDefArityMismatch UniqId
  | ErrCantUnify Ty Ty
  | ErrUndefinedMember UniqId
  | ErrInvalidStructType TyCon
  | ErrTooManyModuleDefs UniqId
  | ErrNoModuleDefInModuleDec UniqId
  | ErrNonFunDefsInFunDec UniqId
  | ErrMultipleDefsInSimpleAnnDec UniqId
  | ErrCircularType Ty
  | ErrInferenceFail (Map.Map UniqId Ty) Ty Ty
  | ErrInterpFailure String
  | ErrNotImplemented String
  deriving (Show)
