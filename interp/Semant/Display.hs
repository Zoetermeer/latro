{-# LANGUAGE NamedFieldPuns, FlexibleInstances #-}
module Semant.Display where

import Data.List (find, intersperse)
import qualified Data.Map as Map
import Data.Maybe (fromJust)
import Semant
import Sexpable
import Text.Printf (printf)


instance Sexpable v => Sexpable (Maybe v) where
  sexp (Just v) = sexp v
  sexp Nothing = List []


-- To satisfy (Sexpable RawId)
instance Sexpable RawId where
  sexp s = Symbol s


instance Sexpable id => Sexpable (QualifiedId id) where
  sexp (Id raw) = sexp raw
  sexp (Path qid raw) =
    Symbol $ printf "%s.%s" (showSexp qid) (showSexp raw)


instance Sexpable id => Sexpable (SynTy id) where
  sexp SynTyInt = Symbol "Int"
  sexp SynTyBool = Symbol "Bool"
  sexp SynTyString = Symbol "String"
  sexp SynTyUnit = Symbol "Unit"
  sexp (SynTyArrow paramTys retTy) =
    List $ ((intersperse (Symbol "->" )) . map sexp) (paramTys ++ [retTy])

  sexp (SynTyModule paramTys maybeImplTy)  =
    List  [ Symbol "Module"
          , toSexpList paramTys
          , sexp maybeImplTy
          ]
  sexp (SynTyInterface []) = Symbol "Interface"
  sexp (SynTyInterface ids) = List [ Symbol "Interface", toSexpList ids ]
  sexp (SynTyDefault qid synTyArgs) =
    List  [ Symbol "Default"
          , sexp qid
          , toSexpList synTyArgs
          ]
  sexp (SynTyStruct fields) =
    List  [ Symbol "Struct"
          , List $ map (\(id, ty) -> List [ Symbol "Field", sexp id, sexp ty ]) fields
          ]

  sexp (SynTyAdt id alts) =
    List  [ Symbol "ADT"
          , sexp id
          , toSexpList alts
          ]

  sexp (SynTyTuple synTys) =
    List  [ Symbol "Tuple" , toSexpList synTys ]

  sexp (SynTyList synTy) =
    List  [ Symbol "List", sexp synTy ]

  sexp (SynTyRef qid []) =
    List [ Symbol "Ref", sexp qid ]

  sexp (SynTyRef qid tyParamIds) =
    List [ Symbol "Ref", sexp qid, toSexpList tyParamIds ]


instance Sexpable UniqId where
  sexp (UserId raw) = Symbol raw
  sexp (UniqId _ raw) = Symbol raw


instance Sexpable id => Sexpable (CompUnit id) where
  sexp (CompUnit es) =
    List  [ Symbol "CompUnit"
          , toSexpList es
          ]


instance Sexpable id => Sexpable (AdtAlternative id) where
  sexp (AdtAlternative id i sTys) =
    List  [ Symbol "AdtAlternative"
          , sexp id
          , Symbol $ show i
          , toSexpList sTys
          ]


instance Sexpable id => Sexpable (TypeDec id) where
  sexp (TypeDecTy id sTy) =
    List  [ Symbol "TypeDecTy", sexp id, sexp sTy ]
  sexp (TypeDecAdt id alts) =
    List  [ Symbol "TypeDecAdt", sexp id, toSexpList alts ]


instance Sexpable id => Sexpable (PatExp id) where
  sexp (PatExpNumLiteral str) =
    List  [ Symbol "PatExpNumLiteral", Atom str ]
  sexp (PatExpBoolLiteral b) =
    List  [ Symbol "PatExpBoolLiteral", Symbol $ show b ]
  sexp (PatExpTuple patEs) =
    List  [ Symbol "PatExpTuple", toSexpList patEs ]
  sexp (PatExpAdt id patEs) =
    List  [ Symbol "PatExpAdt", sexp id, toSexpList patEs ]
  sexp (PatExpList patEs) =
    List  [ Symbol "PatExpList", toSexpList patEs ]
  sexp (PatExpListCons a b) =
    List  [ Symbol "PatExpListCons", sexp a, sexp b ]
  sexp (PatExpId id) =
    List  [ Symbol "PatExpId", sexp id ]
  sexp PatExpWildcard = Symbol "PatExpWildcard"


instance Sexpable id => Sexpable (CaseClause id) where
  sexp (CaseClause patE es) =
    List  [ Symbol "CaseClause"
          , sexp patE
          , toSexpList es
          ]


instance Sexpable id => Sexpable (FunDef id) where
  sexp (FunDefFun id argPatEs es) =
    List  [ Symbol "FunDefFun"
          , sexp id
          , toSexpList argPatEs
          , toSexpList es
          ]
  sexp (FunDefInstFun instPatE id argPatEs es) =
    List  [ Symbol "FunDefInstFun"
          , sexp instPatE
          , sexp id
          , toSexpList argPatEs
          , toSexpList es
          ]


instance Sexpable id => Sexpable (FunDec id) where
  sexp (FunDecFun id sTy funDefs) =
    List  [ Symbol "FunDecFun"
          , sexp id
          , sexp sTy
          , toSexpList funDefs
          ]
  sexp (FunDecInstFun id instTy arrowTy funDefs) =
    List  [ Symbol "FunDecInstFun"
          , sexp id
          , sexp instTy
          , sexp arrowTy
          , toSexpList funDefs
          ]


instance Sexpable id => Sexpable (AnnDef id) where
  sexp (AnnDefModule id e) = List [ Symbol "AnnDefModule", sexp e ]
  sexp (AnnDefFun funDef) = List [ Symbol "AnnDefFun", sexp funDef ]


instance Sexpable id => Sexpable (Exp id) where
  sexp (ExpAdd a b) = List [ Symbol "ExpAdd", sexp a, sexp b ]
  sexp (ExpSub a b) = List [ Symbol "ExpSub", sexp a, sexp b ]
  sexp (ExpDiv a b) = List [ Symbol "ExpDiv", sexp a, sexp b ]
  sexp (ExpMul a b) = List [ Symbol "ExpMul", sexp a, sexp b ]
  sexp (ExpCons a b) = List [ Symbol "ExpCons", sexp a, sexp b ]
  sexp (ExpNot e) = List [ Symbol "ExpNot", sexp e ]
  sexp (ExpMemberAccess e id) =
    List  [ Symbol "ExpMemberAccess"
          , sexp e
          , sexp id
          ]
  sexp (ExpApp rator rands) =
    List  [ Symbol "ExpApp"
          , sexp rator
          , toSexpList rands
          ]
  sexp (ExpImport qid) = List [ Symbol "ExpImport", sexp qid ]
  sexp (ExpAssign patE e) =
    List  [ Symbol "ExpAssign"
          , sexp patE
          , sexp e
          ]
  sexp (ExpTypeDec tyDec) = List [ Symbol "ExpTypeDec", sexp tyDec ]
  sexp (ExpAnnDec id tyParamIds ty annDefs) =
    List  [ Symbol "ExpAnnDec"
          , sexp id
          , toSexpList tyParamIds
          , sexp ty
          , toSexpList annDefs
          ]
  sexp (ExpInterfaceDec id tyParamIds tyAnns) =
    List  [ Symbol "ExpInterfaceDec"
          , sexp id
          , toSexpList tyParamIds
          , toSexpList tyAnns
          ]
  sexp (ExpModule paramIds es) = List [ Symbol "ExpModule", toSexpList paramIds, toSexpList es ]
  sexp (ExpStruct tyE fieldEs) =
    List  [ Symbol "ExpStruct"
          , List $ map (\(id, e) -> List [ sexp id, sexp e ]) fieldEs
          ]
  sexp (ExpIfElse e thenEs elseEs) =
    List  [ Symbol "ExpIfElse"
          , sexp e
          , toSexpList thenEs
          , toSexpList elseEs
          ]
  sexp (ExpMakeAdt sTy i es) =
    List  [ Symbol "ExpMakeAdt"
          , sexp sTy
          , Atom $ show i
          , toSexpList es
          ]
  sexp (ExpTuple es) = List [ Symbol "ExpTuple", toSexpList es ]
  sexp (ExpSwitch e clauses) = List [ Symbol "ExpSwitch", sexp e, toSexpList clauses ]
  sexp (ExpList es) = List [ Symbol "ExpList", toSexpList es ]
  sexp (ExpFun paramIds es) =
    List  [ Symbol "ExpFun"
          , toSexpList paramIds
          , toSexpList es
          ]
  sexp (ExpNum str) = List [ Symbol "ExpNum", Symbol str ]
  sexp (ExpBool b) = List [ Symbol "ExpBool", Symbol $ show b ]
  sexp (ExpString s) = List [ Symbol "ExpString", Atom s ]
  sexp (ExpRef id) = List [ Symbol "ExpRef", sexp id ]
  sexp ExpUnit = Symbol "ExpUnit"


instance Sexpable id => Sexpable (TyAnn id) where
  sexp (TyAnn id tyParamIds synTy) =
    List  [ Symbol "TyAnn"
          , sexp id
          , toSexpList tyParamIds
          , sexp synTy
          ]


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
  sexp (Module cloEnv paramIds exports) =
    List  [ Symbol "Module"
          , sexp cloEnv
          , toSexpList paramIds
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
