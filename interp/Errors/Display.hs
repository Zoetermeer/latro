module Errors.Display where

import Errors
import Semant
import Semant.Display
import Types.Display
import Sexpable
import Text.Printf (printf)


instance Sexpable Err where
  sexp (ErrSyntax msg) =
    List  [ Symbol "Syntax", Atom msg ]

  sexp (ErrNonExhaustivePattern v) =
    List  [ Symbol "NonExhaustivePattern"
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

  sexp ErrInvalidAdtPattern = Symbol "InvalidAdtPattern"

  sexp (ErrInvalidTypeExp e) =
    List  [ Symbol "InvalidTypeExp", sexp e ]

  sexp (ErrNumLitPatMatchFail x y) =
    List  [ Symbol "NumLitPatMatchFail", Atom (show x), Atom (show y) ]

  sexp (ErrBoolLitPatMatchFail x y) =
    List  [ Symbol "BoolLitPatMatchFail", Atom (show x), Atom (show y) ]

  sexp (ErrPatMatchFailOn v) =
    List  [ Symbol "PatMatchFailOn", sexp v ]

  sexp (ErrInvalidConsTo v) =
    List  [ Symbol "InvalidConsTo", sexp v ]

  sexp (ErrNoFunDefGivenFor id) =
    List  [ Symbol "NoFunDefGivenFor", sexp id ]

  sexp (ErrNoInstFunDefGivenFor id) =
    List  [ Symbol "NoInstFunDefGivenFor", sexp id ]

  sexp (ErrCantEvaluate e) =
    List  [ Symbol "CantEvaluate", sexp e ]

  sexp (ErrUnboundUniqIdentifier id) =
    List  [ Symbol "UnboundIdentifier"
          , sexp id
          ]

  sexp (ErrUnboundRawIdentifier id) =
    List  [ Symbol "UnboundIdentifier"
          , sexp id
          ]

  sexp (ErrCantUnify a b) =
    List  [ Symbol "CantUnify"
          , List [ Symbol "Expected", sexp a ]
          , List [ Symbol "Got", sexp b ]
          ]

  sexp (ErrUndefinedMember id) =
    List  [ Symbol "UndefinedMember"
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

  sexp (ErrMultipleDefsInSimpleAnnDec id) =
    List  [ Symbol "MultipleDefsInSimpleAnnDec"
          , sexp id
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

  sexp err = List  [ Symbol "Error", Atom $ show err ]
