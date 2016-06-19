module Errors.Display where

import Errors
import Semant
import Semant.Display
import Sexpable
import Text.Printf (printf)


instance Sexpable Err where
  sexp (ErrSyntax msg) =
    List  [ Symbol "Syntax", Atom msg ]

  sexp (ErrNonExhaustivePattern e v) =
    List  [ Symbol "NonExhaustivePattern"
          , sexp e
          , sexp v
          ]

  sexp (ErrInvalidConstructor id sty) =
    List  [ Symbol "InvalidConstructor"
          , sexp id
          , sexp sty
          ]

  sexp (ErrNotAConstructor id) =
    List  [ Symbol "NotAConstructor", sexp id ]

  sexp (ErrNotAnAdt v) =
    List  [ Symbol "NotAnAdt", sexp v ]

  sexp ErrInvalidFunPattern =
    List  [ Symbol "InvalidFunPattern"
          , Atom "Pattern bindings are not allowed for function values."
          ]

  sexp ErrInvalidAdtPattern = Symbol "InvalidAdtPattern"

  sexp (ErrInvalidTypeExp e) =
    List  [ Symbol "InvalidTypeExp", sexp e ]

  sexp (ErrPatMatchFail e v) =
    List  [ Symbol "PatMatchFail", sexp e, sexp v ]

  sexp (ErrPatMatchBindingFail patE ty) =
    List  [ Symbol "PatMatchBindingFail"
          , sexp patE
          , sexp ty
          ]

  sexp (ErrInvalidConsTo v) =
    List  [ Symbol "InvalidConsTo", sexp v ]

  sexp (ErrNoFunDefGivenFor id) =
    List  [ Symbol "NoFunDefGivenFor", sexp id ]

  sexp (ErrNoInstFunDefGivenFor id) =
    List  [ Symbol "NoInstFunDefGivenFor", sexp id ]

  sexp (ErrCantEvaluate e) =
    List  [ Symbol "CantEvaluate", sexp e ]

  sexp (ErrUnboundUniqIdentifier id) =
    List  [ Symbol "UnboundUniqIdentifier"
          , sexp id
          ]

  sexp (ErrUnboundRawIdentifier id) =
    List  [ Symbol "UnboundRawIdentifier"
          , sexp id
          ]

  sexp (ErrCantUnify a b) =
    List  [ Symbol "CantUnify"
          , List [ Symbol "Expected", sexp a ]
          , List [ Symbol "Got", sexp b ]
          ]

  sexp (ErrUndefinedMember d id) =
    List  [ Symbol "UndefinedMember"
          , sexp d
          , sexp id
          ]

  sexp (ErrInvalidStructType tyCon) =
    List  [ Symbol "InvalidStructType"
          , sexp tyCon
          ]

  sexp (ErrTooManyModuleDefs id) =
    List  [ Symbol "TooManyModuleDefs"
          , sexp id
          ]

  sexp (ErrNoModuleDefInModuleDec id) =
    List  [ Symbol "NoModuleDefInModuleDec"
          , sexp id
          ]

  sexp (ErrNonFunDefsInFunDec id) =
    List  [ Symbol "NonFunDefsInFunDec"
          , sexp id
          ]

  sexp (ErrFunDefIdMismatch exp act) =
    List  [ Symbol "FunDefIdMismatch"
          , List [ Symbol "Expected", sexp exp ]
          , List [ Symbol "Got", sexp act ]
          ]

  sexp (ErrFunDefArityMismatch id) =
    List  [ Symbol "FunDefArityMismatch"
          , sexp id
          , Atom "One or more definitions have different arity."
          ]

  sexp (ErrWrongArity funE arity argLen) =
    List  [ Symbol "WrongArity"
          , sexp funE
          , List [ Symbol "ExpectedArity", Symbol $ show arity ]
          , List [ Symbol "ArgLen", Symbol $ show argLen ]
          ]

  sexp (ErrMultipleDefsInSimpleAnnDec id) =
    List  [ Symbol "MultipleDefsInSimpleAnnDec"
          , sexp id
          ]

  sexp (ErrCircularType tya tyb) =
    List  [ Symbol "CircularType"
          , sexp tya
          , sexp tyb
          ]

  sexp (ErrPartialTyConApp id tyCon tyArgs) =
    List  [ Symbol "PartialTyConApp"
          , sexp id
          , sexp tyCon
          , toSexpList tyArgs
          ]

  sexp (ErrInferenceFail metaEnv fty retTy) =
    List  [ Symbol "InferenceFail"
          , List [ Symbol "Meta Env", sexpOfMap metaEnv ]
          , List [ Symbol "FunctionType", sexp fty ]
          , List [ Symbol "ReturnType", sexp retTy ]
          ]

  sexp (ErrInterpFailure s) =
    List  [ Symbol "InterpFailure"
          , Atom "Non-exhaustive pattern"
          , Atom s
          ]

  sexp (ErrNotImplemented s) =
    List  [ Symbol "NotImplemented"
          , Atom s
          ]

  sexp (ErrAtPos p moduleName err) =
    List  [ Symbol "AtPos"
          , sexp p
          , List [ Symbol "CompilerModule", Symbol moduleName ]
          , sexp err
          ]

  sexp err = List  [ Symbol "Error", Atom $ show err ]
