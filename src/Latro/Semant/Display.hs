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
  sexp = Symbol


instance Sexpable SourcePos where
  sexp (SourcePos filePath lineNum colNum) =
    List  [ Symbol "SourcePos"
          , Atom filePath
          , Symbol $ show lineNum
          , Symbol $ show colNum
          ]


instance Sexpable CheckedData where
  sexp (OfTy srcPos ty) =
    List  [ Symbol "OfTy"
          , sexp srcPos
          , sexp ty
          ]


instance (Sexpable a, Sexpable id) => Sexpable (QualifiedId a id) where
  sexp (Id _ raw) = sexp raw
  sexp (Path _ qid raw) =
    Symbol $ printf "%s.%s" (showSexp qid) (showSexp raw)


instance (Sexpable a, Sexpable id) => Sexpable (SynTy a id) where
  sexp (SynTyInt d) = List [ Symbol "Int", sexp d ]
  sexp (SynTyBool d) = List [ Symbol "Bool", sexp d ]
  sexp (SynTyChar d) = List [ Symbol "Char", sexp d ]
  sexp (SynTyUnit d) = List [ Symbol "Unit", sexp d ]
  sexp (SynTyArrow d paramTys retTy) =
    List $ sexp d : (intersperse (Symbol "->" ) . map sexp) (paramTys ++ [retTy])

  sexp (SynTyStruct d fields) =
    List  [ Symbol "Struct"
          , sexp d
          , List $ map (\(id, ty) -> List [ Symbol "Field", sexp id, sexp ty ]) fields
          ]

  sexp (SynTyAdt d id alts) =
    List  [ Symbol "ADT"
          , sexp d
          , sexp id
          , toSexpList alts
          ]

  sexp (SynTyTuple d synTys) =
    List  [ Symbol "Tuple" , sexp d, toSexpList synTys ]

  sexp (SynTyList d synTy) =
    List  [ Symbol "List", sexp d, sexp synTy ]

  sexp (SynTyRef d qid []) =
    List [ Symbol "Ref", sexp d, sexp qid ]

  sexp (SynTyRef d qid tyParamIds) =
    List [ Symbol "Ref", sexp d, sexp qid, toSexpList tyParamIds ]


instance Sexpable UniqId where
  sexp (UserId raw) = Symbol raw
  -- sexp (UniqId _ raw) = Symbol raw
  -- sexp (UniqId i raw) = Symbol $ printf "%s@%i" raw i
  sexp (UniqId i raw) = List [ Symbol "Id", Symbol raw, Symbol $ show i ]


instance (Sexpable a, Sexpable id) => Sexpable (CompUnit a id) where
  sexp (CompUnit d es) =
    List  [ Symbol "CompUnit"
          , sexp d
          , toSexpList es
          ]


instance (Sexpable a, Sexpable id) => Sexpable (AdtAlternative a id) where
  sexp (AdtAlternative d id i sTys) =
    List  [ Symbol "AdtAlternative"
          , sexp d
          , sexp id
          , Symbol $ show i
          , toSexpList sTys
          ]


instance (Sexpable a, Sexpable id) => Sexpable (TypeDec a id) where
  sexp (TypeDecTy d id tyParamIds sTy) =
    List  [ Symbol "TypeDecTy"
          , sexp d
          , sexp id
          , toSexpList tyParamIds
          , sexp sTy
          ]
  sexp (TypeDecAdt d id tyParamIds alts) =
    List  [ Symbol "TypeDecAdt"
          , sexp d
          , sexp id
          , toSexpList tyParamIds
          , toSexpList alts
          ]


instance (Sexpable a, Sexpable id) => Sexpable (PatExp a id) where
  sexp (PatExpNumLiteral d str) =
    List  [ Symbol "PatExpNumLiteral", sexp d, Atom str ]
  sexp (PatExpBoolLiteral d b) =
    List  [ Symbol "PatExpBoolLiteral", sexp d, Symbol $ show b ]
  sexp (PatExpStringLiteral d s) =
    List  [ Symbol "PatExpStringLiteral", sexp d, Atom s ]
  sexp (PatExpCharLiteral d s) =
    List  [ Symbol "PatExpCharLiteral", sexp d, Atom s ]
  sexp (PatExpTuple d patEs) =
    List  [ Symbol "PatExpTuple", sexp d, toSexpList patEs ]
  sexp (PatExpAdt d qid patEs) =
    List  [ Symbol "PatExpAdt", sexp d, sexp qid, toSexpList patEs ]
  sexp (PatExpList d patEs) =
    List  [ Symbol "PatExpList", sexp d, toSexpList patEs ]
  sexp (PatExpListCons d a b) =
    List  [ Symbol "PatExpListCons", sexp d, sexp a, sexp b ]
  sexp (PatExpId d id) =
    List  [ Symbol "PatExpId", sexp d, sexp id ]
  sexp (PatExpWildcard d) = List [ Symbol "PatExpWildcard", sexp d ]


instance (Sexpable a, Sexpable id) => Sexpable (CaseClause a id) where
  sexp (CaseClause d patE es) =
    List  [ Symbol "CaseClause"
          , sexp d
          , sexp patE
          , toSexpList es
          ]


instance (Sexpable a, Sexpable id) => Sexpable (CondCaseClause a id) where
  sexp (CondCaseClause d e es) =
    List  [ Symbol "CondCaseClause"
          , sexp d
          , sexp e
          , toSexpList es
          ]


instance (Sexpable a, Sexpable id) => Sexpable (FunDef a id) where
  sexp (FunDefFun d id argPatEs es) =
    List  [ Symbol "FunDefFun"
          , sexp d
          , sexp id
          , toSexpList argPatEs
          , toSexpList es
          ]
  sexp (FunDefInstFun d instPatE id argPatEs es) =
    List  [ Symbol "FunDefInstFun"
          , sexp d
          , sexp instPatE
          , sexp id
          , toSexpList argPatEs
          , toSexpList es
          ]


instance (Sexpable a, Sexpable id) => Sexpable (FieldInit a id) where
  sexp (FieldInit id e) = List  [ sexp id, sexp e ]


instance (Sexpable a, Sexpable id) => Sexpable (AnnDef a id) where
  sexp (AnnDefModule d id e) = List [ Symbol "AnnDefModule", sexp d, sexp e ]
  sexp (AnnDefFun d funDef) = List [ Symbol "AnnDefFun", sexp d, sexp funDef ]


instance (Sexpable a, Sexpable id) => Sexpable (Exp a id) where
  sexp (ExpAdd d a b) = List [ Symbol "ExpAdd", sexp d, sexp a, sexp b ]
  sexp (ExpSub d a b) = List [ Symbol "ExpSub", sexp d, sexp a, sexp b ]
  sexp (ExpDiv d a b) = List [ Symbol "ExpDiv", sexp d, sexp a, sexp b ]
  sexp (ExpMul d a b) = List [ Symbol "ExpMul", sexp d, sexp a, sexp b ]
  sexp (ExpCons d a b) = List [ Symbol "ExpCons", sexp d, sexp a, sexp b ]
  sexp (ExpCustomInfix d lhe id rhe) =
    List  [ Symbol "ExpCustomInfix"
          , sexp d
          , sexp lhe
          , sexp id
          , sexp rhe
          ]
  sexp (ExpMemberAccess d e id) =
    List  [ Symbol "ExpMemberAccess"
          , sexp d
          , sexp e
          , sexp id
          ]
  sexp (ExpApp d rator rands) =
    List  [ Symbol "ExpApp"
          , sexp d
          , sexp rator
          , toSexpList rands
          ]
  sexp (ExpImport d qid) = List [ Symbol "ExpImport", sexp d, sexp qid ]
  sexp (ExpAssign d patE e) =
    List  [ Symbol "ExpAssign"
          , sexp d
          , sexp patE
          , sexp e
          ]
  sexp (ExpTypeDec d tyDec) = List [ Symbol "ExpTypeDec", sexp d, sexp tyDec ]
  sexp (ExpTyAnn (TyAnn d id tyParamIds synTy)) =
    List  [ Symbol "ExpTyAnn"
          , sexp d
          , sexp id
          , toSexpList tyParamIds
          , sexp synTy
          ]
  sexp (ExpWithAnn tyAnn e) =
    List  [ Symbol "ExpWithAnn"
          , sexp tyAnn
          , sexp e
          ]
  sexp (ExpFunDef (FunDefFun d id argPatEs bodyEs)) =
    List  [ Symbol "ExpFunDef"
          , sexp d
          , sexp id
          , toSexpList argPatEs
          , toSexpList bodyEs
          ]
  sexp (ExpFunDef (FunDefInstFun d instPatE id argPatEs bodyEs)) =
    List  [ Symbol "ExpFunDefInst"
          , sexp d
          , sexp instPatE
          , sexp id
          , toSexpList argPatEs
          , toSexpList bodyEs
          ]
  sexp (ExpFunDefClauses d id funDefs) =
    List  [ Symbol "ExpFunDefClauses"
          , sexp d
          , sexp id
          , toSexpList funDefs
          ]
  sexp (ExpInterfaceDec d id tyParamIds tyAnns) =
    List  [ Symbol "ExpInterfaceDec"
          , sexp d
          , sexp id
          , toSexpList tyParamIds
          , toSexpList tyAnns
          ]
  sexp (ExpModule d paramIds es) = List [ Symbol "ExpModule", sexp d, toSexpList paramIds, toSexpList es ]
  sexp (ExpStruct d tyE fieldInits) =
    List  [ Symbol "ExpStruct"
          , sexp d
          , List $ map sexp fieldInits
          ]
  sexp (ExpIfElse d e thenEs elseEs) =
    List  [ Symbol "ExpIfElse"
          , sexp d
          , sexp e
          , toSexpList thenEs
          , toSexpList elseEs
          ]
  sexp (ExpMakeAdt d sTy i es) =
    List  [ Symbol "ExpMakeAdt"
          , sexp d
          , sexp sTy
          , Atom $ show i
          , toSexpList es
          ]
  sexp (ExpGetAdtField d e index) =
    List  [ Symbol "ExpGetAdtField"
          , sexp d
          , sexp e
          , Atom $ show index
          ]
  sexp (ExpTuple d es) = List [ Symbol "ExpTuple", sexp d, toSexpList es ]
  sexp (ExpSwitch d e clauses) = List [ Symbol "ExpSwitch", sexp d, sexp e, toSexpList clauses ]
  sexp (ExpList d es) = List [ Symbol "ExpList", sexp d, toSexpList es ]
  sexp (ExpFun d paramIds es) =
    List  [ Symbol "ExpFun"
          , sexp d
          , toSexpList paramIds
          , toSexpList es
          ]
  sexp (ExpNum d str) = List [ Symbol "ExpNum", sexp d, Symbol str ]
  sexp (ExpBool d b) = List [ Symbol "ExpBool", sexp d, Symbol $ show b ]
  sexp (ExpString d s) = List [ Symbol "ExpString", sexp d, Atom s ]
  sexp (ExpChar d s) = List [ Symbol "ExpChar", sexp d, Atom s ]
  sexp (ExpRef d id) = List [ Symbol "ExpRef", sexp d, sexp id ]
  sexp (ExpQualifiedRef d qid) = List [ Symbol "ExpQualifiedRef", sexp d, sexp qid ]
  sexp (ExpUnit d) = List [ Symbol "ExpUnit", sexp d ]
  sexp (ExpBegin d es) =
    List  [ Symbol "ExpBegin"
          , sexp d
          , toSexpList es
          ]
  sexp (ExpPrecAssign d id level) =
    List  [ Symbol "ExpPrecAssign"
          , sexp d
          , sexp id
          , Atom (show level)
          ]
  sexp (ExpFail d msg) = List [ Symbol "ExpFail", sexp d, Atom msg ]


instance (Sexpable a, Sexpable id) => Sexpable (TyAnn a id) where
  sexp (TyAnn d id tyParamIds synTy) =
    List  [ Symbol "TyAnn"
          , sexp d
          , sexp id
          , toSexpList tyParamIds
          , sexp synTy
          ]


instance (Sexpable a) => Sexpable (ILFieldInit a) where
  sexp (ILFieldInit fieldId e) =
    List [ Symbol "ILFieldInit", sexp fieldId, sexp e ]


instance (Sexpable a) => Sexpable (ILCase a) where
  sexp (ILCase d patE bodyEs) =
    List [ Symbol "ILCase", sexp d, sexp patE, toSexpList bodyEs ]


instance (Sexpable a) => Sexpable (ILPat a) where
  sexp ilPat =
    case ilPat of
      ILPatInt d i -> List [ Symbol "ILPatInt", sexp d, Atom $ show i ]
      ILPatBool d b -> List [ Symbol "ILPatBool", sexp d, Symbol $ show b ]
      ILPatStr d s -> List [ Symbol "ILPatStr", sexp d, Atom s ]
      ILPatChar d s -> List [ Symbol "ILPatChar", sexp d, Atom s ]
      ILPatTuple d argPatEs ->
        List [ Symbol "ILPatTuple", sexp d, toSexpList argPatEs ]
      ILPatAdt d ctorId argPatEs ->
        List [ Symbol "ILPatAdt", sexp d, sexp ctorId, toSexpList argPatEs ]
      ILPatList d argPatEs ->
        List [ Symbol "ILPatList", sexp d, toSexpList argPatEs ]
      ILPatCons d patHd patTl ->
        List [ Symbol "ILPatCons", sexp d, sexp patHd, sexp patTl ]
      ILPatId d id ->
        List [ Symbol "ILPatId", sexp d, sexp id ]
      ILPatWildcard d -> List [ Symbol "ILPatWildcard", sexp d ]


instance (Sexpable a) => Sexpable (IL a) where
  sexp il =
    case il of
      ILAdd d a b -> List [ Symbol "ILAdd", sexp d, sexp a, sexp b ]
      ILSub d a b -> List [ Symbol "ILSub", sexp d, sexp a, sexp b ]
      ILDiv d a b -> List [ Symbol "ILDiv", sexp d, sexp a, sexp b ]
      ILMul d a b -> List [ Symbol "ILMul", sexp d, sexp a, sexp b ]
      ILCons d a b -> List [ Symbol "ILCons", sexp d, sexp a, sexp b ]
      ILApp d rator rands ->
        List  [ Symbol "ILApp"
              , sexp d
              , sexp rator
              , toSexpList rands
              ]
      ILAssign d patE e -> List [ Symbol "ILAssign", sexp d, sexp patE, sexp e ]
      ILTypeDec d typeDec -> List [ Symbol "ILTypeDec", sexp d, sexp typeDec ]
      ILWithAnn d tyAnn e -> List [ Symbol "ILWithAnn", sexp d, sexp tyAnn, sexp e ]
      ILFunDef d id paramIds bodyEs ->
        List [ Symbol "ILFunDef", sexp d, sexp id, toSexpList paramIds, toSexpList bodyEs ]
      ILInstFunDef d instId funId paramIds bodyEs ->
        List [ Symbol "ILInstFunDef"
             , sexp d
             , sexp instId
             , sexp funId
             , toSexpList paramIds
             , toSexpList bodyEs
             ]
      ILStruct d typeId fieldInits -> List [ Symbol "ILStruct", sexp d, toSexpList fieldInits ]
      ILMakeAdt d typeId ctorIndex argEs ->
        List  [ Symbol "ILMakeAdt"
              , sexp d
              , sexp typeId
              , Atom $ show ctorIndex
              , toSexpList argEs
              ]
      ILGetAdtField d e fieldIndex ->
        List [ Symbol "ILGetAdtField", sexp d, sexp e, Atom $ show fieldIndex ]
      ILTuple d argEs -> List [ Symbol "ILTuple", sexp d, toSexpList argEs ]
      ILSwitch d e clauses -> List [ Symbol "ILSwitch", sexp d, sexp e, toSexpList clauses ]
      ILList d argEs -> List [ Symbol "ILList", sexp d, toSexpList argEs ]
      ILFun d paramIds bodyEs ->
        List  [ Symbol "ILFun"
              , sexp d
              , toSexpList paramIds
              , toSexpList bodyEs
              ]
      ILInt d i -> List [ Symbol "ILInt", sexp d, Atom $ show i ]
      ILBool d b -> List [ Symbol "ILBool", sexp d, Symbol $ show b ]
      ILStr d s -> List [ Symbol "ILStr", sexp d, Atom $ printf "\"%s\"" s ]
      ILChar d s -> List [ Symbol "ILChar", sexp d, Atom $ printf "\'%s\'" s ]
      ILUnit d -> List [ Symbol "ILUnit", sexp d ]
      ILRef d id -> List [ Symbol "ILRef", sexp d, sexp id ]
      ILBegin d es -> List [ Symbol "ILBegin", sexp d, toSexpList es ]
      ILFail d msg -> List [ Symbol "ILFail", sexp d, Atom $ printf "\"%s\"" msg ]


instance (Sexpable a) => Sexpable (ILCompUnit a) where
  sexp (ILCompUnit d es) = List [ Symbol "ILCompUnit", sexp d, toSexpList es ]


sexpOfMap :: (Sexpable k, Sexpable v) => Map.Map k v -> Sexp
-- sexpOfMap m = List $ map (\\(k, v) -> List [ sexp k, sexp v]) $ Map.toList m
sexpOfMap m = toSexpList $ Map.keys m


instance Sexpable Exports where
  sexp Exports { exportTypes, exportVars } =
    List  [ Symbol "Exports"
          , sexpOfMap exportVars
          ]


instance Sexpable Module where
  sexp (Module cloEnv paramIds exports) =
    List  [ Symbol "Module"
          , List [ Symbol "CloEnv", sexpOfMap cloEnv ]
          , List [ Symbol "Params", toSexpList paramIds ]
          , sexp exports
          ]


instance Sexpable Closure where
  sexp (Closure id _ cloEnv _ _) =
    List  [ Symbol "Fun"
          , sexp id
          , List [ Symbol "CloEnv", sexpOfMap cloEnv ]
          ]


instance Sexpable Struct where
  sexp (Struct ty fields) =
    List  [ Symbol "Struct"
          , sexp ty
          , List $ map (\(id, v) -> List [ sexp id, sexp v ]) fields
          ]


instance Sexpable Adt where
  sexp (Adt id i vs) =
      List  [ Symbol "Adt"
            , sexp id
            , Symbol (show i)
            , toSexpList vs
            ]


instance Sexpable Value where
  sexp (ValueInt i) = Symbol $ show i
  sexp (ValueBool b) = Symbol $ show b
  sexp (ValueChar c) = Symbol $ printf "#\\%c" c
  sexp (ValueModule m) = sexp m
  sexp (ValueFun clo) = sexp clo
  sexp (ValueStruct struct) = sexp struct
  sexp (ValueAdt adt) = sexp adt
  sexp (ValueTuple vs) = List [ Symbol "Tuple", toSexpList vs ]
  sexp (ValueList vs)
    | null vs = List [ Symbol "List", toSexpList vs ]
    | all (\v -> case v of
                   ValueChar _ -> True
                   _ -> False
          )
          vs = Atom $ map (\(ValueChar c) -> c) vs
    | otherwise = List [ Symbol "List", toSexpList vs ]

  sexp ValueUnit = Symbol "Unit"
  sexp (Err str) = List [ Symbol "Error", Atom str ]


instance Sexpable Ty where
  sexp (TyApp TyConInt []) = Symbol "Int"
  sexp (TyApp TyConBool []) = Symbol "Bool"
  sexp (TyApp TyConChar []) = Symbol "Char"
  sexp (TyApp tyCon tys) =
    List  [ Symbol "App"
          , sexp tyCon
          , toSexpList tys
          ]

  sexp (TyPoly tyVars ty) =
    List  [ Symbol "Poly"
          , toSexpList tyVars
          , sexp ty
          ]

  sexp (TyVar tyVar) = List [ Symbol "Var", sexp tyVar ]
  sexp (TyMeta id) = List [ Symbol "Meta", sexp id ]
  sexp (TyRef qid) = List [ Symbol "Ref", sexp qid ]
  sexp (TyInstFun instTy funTy) = List [ Symbol "InstFun", sexp instTy, sexp funTy ]


instance Sexpable TCModule where
  sexp _ = List [ Symbol "Module" ]


instance Sexpable TyCon where
  sexp TyConInt = Symbol "Int"
  sexp TyConBool = Symbol "Bool"
  sexp TyConChar = Symbol "Char"
  sexp TyConUnit = Symbol "Unit"
  sexp TyConList = Symbol "List"
  sexp TyConTuple = Symbol "Tuple"
  sexp TyConArrow = Symbol "Arrow"
  sexp (TyConStruct fieldNames) =
    List [ Symbol "Struct", toSexpList fieldNames ]
  sexp (TyConAdt ctorNames) =
    List [ Symbol "Adt", toSexpList ctorNames ]
  sexp (TyConModule tyParamIds tcMod) =
    List [ Symbol "Module", toSexpList tyParamIds, sexp tcMod ]
  sexp (TyConTyFun tyVarIds ty) =
    List [ Symbol "TyFun", toSexpList tyVarIds, sexp ty ]
  sexp (TyConUnique id tyCon) =
    List [ Symbol "Unique", sexp id, sexp tyCon ]
  sexp (TyConTyVar varId) =
    List [ Symbol "TyVar", sexp varId ]
