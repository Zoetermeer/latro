module Errors where

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
  | ErrNotImplemented String
