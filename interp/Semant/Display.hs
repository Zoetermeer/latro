{-# LANGUAGE NamedFieldPuns, FlexibleInstances #-}
module Semant.Display where

import Data.List (find, intersperse)
import qualified Data.Map as Map
import Data.Maybe (fromJust)
import Semant
import Sexpable
import Text.Printf (printf)


-- To satisfy (Sexpable RawId)
instance Sexpable RawId where
  sexp s = Symbol s


instance Sexpable id => Sexpable (QualifiedId id) where
  sexp (Id raw) = sexp raw
  sexp (Path qid raw) =
    Symbol $ printf "%s.%s" (showSexp qid) (showSexp raw)


instance Sexpable id => Sexpable (AdtAlternative id) where
  sexp (AdtAlternative id i tys) =
    List  [ Symbol $ printf "%s@%i" (showSexp id) i
          , toSexpList tys
          ]


instance Sexpable id => Sexpable (SynTy id) where
  sexp SynTyInt = Symbol "Int"
  sexp SynTyBool = Symbol "Bool"
  sexp SynTyString = Symbol "String"
  sexp SynTyUnit = Symbol "Unit"
  sexp (SynTyArrow paramTys retTy) =
    List $ ((intersperse (Symbol "->" )) . map sexp) (paramTys ++ [retTy])

  sexp SynTyModule = Symbol "Module"
  sexp SynTyInterface = Symbol "Interface"
  sexp (SynTyStruct fields) =
    List  [ Symbol "Struct"
          , List $ map (\(id, ty) -> List [ Symbol "Field", sexp id, sexp ty ]) fields
          ]

  sexp (SynTyAdt id alts) =
    List  [ Symbol "ADT"
          , sexp id
          , toSexpList alts
          ]

  sexp (SynTyRef qid) =
    List [ Symbol "Ref", sexp qid ]


instance Sexpable UniqId where
  sexp (UserId raw) = Symbol raw
  sexp (UniqId _ raw) = Symbol raw


-- TODO: Implement both of these!!!!
instance Sexpable id => Sexpable (CompUnit id) where
  sexp cu = Symbol "CompUnit"


instance Sexpable id => Sexpable (Exp id) where
  sexp e = Symbol "foo"


sexpOfMap :: Sexpable k => Map.Map k v -> Sexp
sexpOfMap m = List $ map sexp $ Map.keys m


instance Sexpable ClosureEnv where
  sexp (ClosureEnv { cloTypeEnv, cloVarEnv }) =
    List  [ Symbol "Closure"
          , sexpOfMap cloTypeEnv
          , sexpOfMap cloVarEnv
          ]


instance Sexpable Exports where
  sexp (Exports { exportTypes, exportVars }) =
    List  [ Symbol "Exports"
          , sexpOfMap exportTypes
          , sexpOfMap exportVars
          ]


instance Sexpable Module where
  sexp (Module cloEnv exports) =
    List  [ Symbol "Module"
          , sexp cloEnv
          , sexp exports
          ]


instance Sexpable Closure where
  sexp (Closure id _ cloEnv _ _) =
    List  [ Symbol "Fun"
          , sexp id
          , sexp cloEnv
          ]


instance Sexpable Struct where
  sexp (Struct ty fields) =
    List  [ Symbol "Struct"
          , sexp ty
          , List $ map (\(id, v) -> List [ sexp id, sexp v ]) fields
          ]


instance Sexpable Adt where
  sexp (Adt (SynTyAdt id alts) i vs) =
      List  [ sexp id
            , sexp altName
            , toSexpList vs
            ]
    where
      (AdtAlternative altName _ _) =
        fromJust $ find (\(AdtAlternative aid ai _) -> ai == i) alts


instance Sexpable Value where
  sexp (ValueInt i) = Atom $ show i
  sexp (ValueBool b) = Atom $ show b
  sexp (ValueStr s) = Atom s
  sexp (ValueModule m) = sexp m
  sexp (ValueFun clo) = sexp clo
  sexp (ValueStruct struct) = sexp struct
  sexp (ValueAdt adt) = sexp adt
  sexp (ValueTuple vs) = List [ Symbol "Tuple", toSexpList vs ]
  sexp (ValueList vs) = List [ Symbol "List", toSexpList vs ]
  sexp ValueUnit = Symbol "Unit"
  sexp (Err str) = List [ Symbol "Error", Atom str ]
