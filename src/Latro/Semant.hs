{-# LANGUAGE DeriveGeneric, TypeSynonymInstances #-}
module Semant where

import Data.List (intersperse)
import qualified Data.Map as Map
import Text.PrettyPrint.GenericPretty
import Text.Printf (printf)


type LineNumber = Int
type ColNumber = Int
type SourceFilePath = String
data SourcePos = SourcePos SourceFilePath LineNumber ColNumber
  deriving (Eq, Generic, Show)


instance Out SourcePos


mtSourcePos :: SourcePos
mtSourcePos = SourcePos "??" 0 0


type RawId = String


data QualifiedId a id =
    Id a id
  | Path a (QualifiedId a id) id
  deriving (Generic, Ord, Show)


instance Eq id => Eq (QualifiedId a id) where
  Id _ id1 == Id _ id2 = id1 == id2
  Path _ qid1 id1 == Path _ qid2 id2 =
    id1 == id2 && qid1 == qid2
  _ == _ = False


instance (Out a, Out id) => Out (QualifiedId a id)

class AstNode a where
  nodeData :: a b id -> b


class ILNode a where
  ilNodeData :: a b -> b


instance AstNode QualifiedId where
  nodeData (Id d _) = d
  nodeData (Path d _ _) = d


class BindingOccurrence a where
  bindingId :: a b id -> id


data CompUnit a id = CompUnit a [Exp a id]
  deriving (Eq, Show)


instance AstNode CompUnit where
  nodeData (CompUnit d _) = d


data PatExp a id =
    PatExpNumLiteral a String
  | PatExpBoolLiteral a Bool
  | PatExpStringLiteral a String
  | PatExpCharLiteral a String
  | PatExpTuple a [PatExp a id]
  | PatExpAdt a (QualifiedId a id) [PatExp a id]
  | PatExpList a [PatExp a id]
  | PatExpListCons a (PatExp a id) (PatExp a id)
  | PatExpId a id
  | PatExpWildcard a
  deriving (Eq, Show)


instance AstNode PatExp where
  nodeData patExp =
    case patExp of
      PatExpNumLiteral d _ -> d
      PatExpBoolLiteral d _ -> d
      PatExpStringLiteral d _ -> d
      PatExpCharLiteral d _ -> d
      PatExpTuple d _ -> d
      PatExpAdt d _ _ -> d
      PatExpList d _ -> d
      PatExpListCons d _ _ -> d
      PatExpId d _ -> d
      PatExpWildcard d -> d


data CaseClause a id =
    CaseClause a (PatExp a id) (Exp a id)
  deriving (Eq, Show)


instance AstNode CaseClause where
  nodeData (CaseClause d _ _) = d


data CondCaseClause a id =
    CondCaseClause a (Exp a id) (Exp a id)
  | CondCaseClauseWildcard a (Exp a id)
  deriving (Eq, Show)


instance AstNode CondCaseClause where
  nodeData (CondCaseClause d _ _) = d
  nodeData (CondCaseClauseWildcard d _) = d


data TyAnn a id = TyAnn a id [id] (SynTy a id) [Constraint a id]
  deriving (Eq, Show)


instance AstNode TyAnn where
  nodeData (TyAnn d _ _ _ _) = d


instance BindingOccurrence TyAnn where
  bindingId (TyAnn _ id _ _ _) = id


data FunDef a id =
    FunDefFun a id [PatExp a id] (Exp a id)
  | FunDefInstFun a (PatExp a id) id [PatExp a id] (Exp a id)
  deriving (Eq, Show)


instance AstNode FunDef where
  nodeData fd =
    case fd of
      FunDefFun d _ _ _ -> d
      FunDefInstFun d _ _ _ _ -> d


data FieldInit a id = FieldInit id (Exp a id)
  deriving (Eq, Show)


data Constraint a id = Constraint a id id
  deriving (Eq, Show)


instance AstNode Constraint where
  nodeData (Constraint d _ _) = d


data ILFieldInit a = ILFieldInit UniqId (IL a)
  deriving (Eq, Show)


data ILCase a = ILCase a (ILPat a) (IL a)
  deriving (Eq, Show)


data ILPat a =
    ILPatInt a Int
  | ILPatBool a Bool
  | ILPatStr a String
  | ILPatChar a String
  | ILPatTuple a [ILPat a]
  | ILPatAdt a UniqId [ILPat a]
  | ILPatList a [ILPat a]
  | ILPatCons a (ILPat a) (ILPat a)
  | ILPatId a UniqId
  | ILPatWildcard a
  deriving (Eq, Show)


instance ILNode ILPat where
  ilNodeData ilPat =
    case ilPat of
      ILPatInt d _ -> d
      ILPatBool d _ -> d
      ILPatStr d _ -> d
      ILPatChar d _ -> d
      ILPatTuple d _ -> d
      ILPatAdt d _ _ -> d
      ILPatList d _ -> d
      ILPatCons d _ _ -> d
      ILPatId d _ -> d
      ILPatWildcard d -> d


data Prim =
    PrimPrintln
  | PrimIntAdd
  | PrimIntSub
  | PrimIntDiv
  | PrimIntMul
  | PrimIntMod
  | PrimIntEq
  | PrimIntLt
  | PrimIntLeq
  | PrimIntGt
  | PrimIntGeq
  | PrimUnknown RawId
  deriving (Eq, Show)


data IL a =
    ILCons a (IL a) (IL a)
  | ILApp a (IL a) [IL a]
  | ILPrim a Prim
  | ILAssign a (ILPat a) (IL a)
  | ILTypeDec a (TypeDec a UniqId)
  | ILProtoDec a UniqId UniqId [Constraint a UniqId] [TyAnn a UniqId]
  | ILProtoImp a (SynTy a UniqId) UniqId [Constraint a UniqId] [IL a]
  | ILWithAnn a (TyAnn a UniqId) (IL a)
  | ILFunDef a UniqId [UniqId] (IL a)
  | ILInstFunDef a UniqId UniqId [UniqId] (IL a)
  | ILStruct a UniqId [ILFieldInit a]
  | ILMakeAdt a UniqId Int [IL a]
  | ILGetAdtField a (IL a) Int
  | ILTuple a [IL a]
  | ILSwitch a (IL a) [ILCase a]
  | ILList a [IL a]
  | ILFun a [UniqId] (IL a)
  | ILInt a Int
  | ILBool a Bool
  | ILStr a String
  | ILChar a String
  | ILUnit a
  | ILRef a UniqId
  | ILBegin a [IL a]
  | ILFail a String
  | ILMain a [UniqId] (IL a)
  deriving (Eq, Show)


instance ILNode IL where
  ilNodeData il =
    case il of
      ILCons d _ _ -> d
      ILApp d _ _ -> d
      ILPrim d _ -> d
      ILAssign d _ _ -> d
      ILTypeDec d _ -> d
      ILProtoDec d _ _ _ _ -> d
      ILProtoImp d _ _ _ _ -> d
      ILWithAnn d _ _ -> d
      ILFunDef d _ _ _ -> d
      ILInstFunDef d _ _ _ _ -> d
      ILStruct d _ _ -> d
      ILMakeAdt d _ _ _ -> d
      ILGetAdtField d _ _ -> d
      ILTuple d _ -> d
      ILSwitch d _ _ -> d
      ILList d _ -> d
      ILFun d _ _ -> d
      ILInt d _ -> d
      ILBool d _ -> d
      ILStr d _ -> d
      ILChar d _ -> d
      ILUnit d -> d
      ILRef d _ -> d
      ILBegin d _ -> d
      ILFail d _ -> d
      ILMain d _ _ -> d


data ILCompUnit a = ILCompUnit a [IL a]
  deriving (Eq, Show)


data Exp a id =
  ExpCons a (Exp a id) (Exp a id)
  | ExpInParens a (Exp a id)
  | ExpCustomInfix a (Exp a id) id (Exp a id)
  | ExpMemberAccess a (Exp a id) id
  | ExpApp a (Exp a id) [Exp a id]
  | ExpPrim a id
  | ExpImport a (QualifiedId a id)
  | ExpAssign a (PatExp a id) (Exp a id)
  | ExpTypeDec a (TypeDec a id)
  | ExpProtoDec a id id [Constraint a id] [TyAnn a id]
  | ExpProtoImp a (SynTy a id) id [Constraint a id] [Exp a id]
  | ExpTyAnn (TyAnn a id)
  | ExpWithAnn (TyAnn a id) (Exp a id)
  | ExpFunDef (FunDef a id)
  | ExpFunDefClauses a id [FunDef a id]
  | ExpInterfaceDec a id [id] [TyAnn a id]
  | ExpModule a [id] [Exp a id]
  | ExpStruct a (QualifiedId a id) [FieldInit a id]
  | ExpIfElse a (Exp a id) (Exp a id) (Exp a id)
  | ExpMakeAdt a id Int [Exp a id]
  | ExpGetAdtField a (Exp a id) Int
  | ExpTuple a [Exp a id]
  | ExpSwitch a (Exp a id) [CaseClause a id]
  | ExpCond a [CondCaseClause a id]
  | ExpList a [Exp a id]
  | ExpFun a [PatExp a id] (Exp a id)
  | ExpNum a String
  | ExpBool a Bool
  | ExpString a String
  | ExpChar a String
  | ExpRef a id
  | ExpQualifiedRef a (QualifiedId a id)
  | ExpUnit a
  | ExpBegin a [Exp a id]
  | ExpPrecAssign a id Int
  | ExpFail a String
  deriving (Eq, Show)


instance AstNode Exp where
  nodeData e =
    case e of
      ExpCons d _ _ -> d
      ExpInParens d _ -> d
      ExpCustomInfix d _ _ _ -> d
      ExpMemberAccess d _ _ -> d
      ExpApp d _ _ -> d
      ExpPrim d _ -> d
      ExpImport d _ -> d
      ExpAssign d _ _ -> d
      ExpTypeDec d _ -> d
      ExpTyAnn (TyAnn d _ _ _ _) -> d
      ExpProtoDec d _ _ _ _ -> d
      ExpProtoImp d _ _ _ _ -> d
      ExpWithAnn _ e -> nodeData e
      ExpFunDef (FunDefFun d _ _ _) -> d
      ExpFunDef (FunDefInstFun d _ _ _ _) -> d
      ExpInterfaceDec d _ _ _ -> d
      ExpModule d _ _ -> d
      ExpStruct d _ _ -> d
      ExpIfElse d _ _ _ -> d
      ExpMakeAdt d _ _ _ -> d
      ExpGetAdtField d _ _ -> d
      ExpTuple d _ -> d
      ExpSwitch d _ _ -> d
      ExpCond d _ -> d
      ExpList d _ -> d
      ExpFun d _ _ -> d
      ExpNum d _ -> d
      ExpBool d _ -> d
      ExpString d _ -> d
      ExpChar d _ -> d
      ExpRef d _ -> d
      ExpQualifiedRef d _ -> d
      ExpUnit d -> d
      ExpBegin d _ -> d
      ExpPrecAssign d _ _ -> d
      ExpFail d _ -> d


data AnnDef a id =
    AnnDefModule a id (Exp a id)
  | AnnDefFun a (FunDef a id)
  | AnnDefExp a (Exp a id)
  deriving (Eq, Show)


instance AstNode AnnDef where
  nodeData def =
    case def of
      AnnDefModule d _ _ -> d
      AnnDefFun d _ -> d
      AnnDefExp d _ -> d


isAnnDefFun :: AnnDef a id -> Bool
isAnnDefFun (AnnDefFun _ _) = True
isAnnDefFun _ = False

isAnnDefModule :: AnnDef a id -> Bool
isAnnDefModule AnnDefModule{} = True
isAnnDefModule _ = False


data TypeDec a id =
    TypeDecTy a id [id] (SynTy a id)
  | TypeDecAdt a id [id] [AdtAlternative a id]
  deriving (Eq, Show)


instance AstNode TypeDec where
  nodeData td =
    case td of
      TypeDecTy d _ _ _ -> d
      TypeDecAdt d _ _ _ -> d


getTypeDecId :: TypeDec a id -> id
getTypeDecId (TypeDecTy _ id _ _) = id
getTypeDecId (TypeDecAdt _ id _ _) = id


data AdtAlternative a id =
    AdtAlternative a id Int [SynTy a id]
  deriving (Eq, Show)


instance AstNode AdtAlternative where
  nodeData (AdtAlternative d _ _ _) = d


data SynTy a id =
    SynTyInt a
  | SynTyBool a
  | SynTyString a
  | SynTyChar a
  | SynTyUnit a
  | SynTyArrow a [SynTy a id] (SynTy a id)
  | SynTyStruct a [(id, SynTy a id)]
  | SynTyAdt a id [AdtAlternative a id]
  | SynTyTuple a [SynTy a id]
  | SynTyList a (SynTy a id)
  | SynTyRef a (QualifiedId a id) [SynTy a id]
  deriving (Eq, Show)


synTyArrowTys :: SynTy a id -> [SynTy a id]
synTyArrowTys (SynTyArrow _ tyArgs retTy) = tyArgs ++ [retTy]
synTyArrowTys sty = [sty]


instance AstNode SynTy where
  nodeData sty =
    case sty of
      SynTyInt d -> d
      SynTyBool d -> d
      SynTyString d -> d
      SynTyChar d -> d
      SynTyUnit d -> d
      SynTyArrow d _ _ -> d
      SynTyStruct d _ -> d
      SynTyAdt d _ _ -> d
      SynTyTuple d _ -> d
      SynTyList d _ -> d
      SynTyRef d _ _ -> d


data UniqId =
    UserId RawId
  | UniqId Int RawId
  deriving (Generic)

instance Out UniqId

instance Show UniqId where
  show (UserId raw) = raw
  show (UniqId _ raw) = raw

instance Eq UniqId where
  (UserId raw) == (UserId raw') = raw == raw'
  (UserId raw) == (UniqId _ raw') = raw == raw'
  (UniqId c _) == (UniqId c' _) = c == c'
  a == b = b == a

instance Ord UniqId where
  (UserId raw) `compare` (UserId raw') = raw `compare` raw'
  (UserId raw) `compare` (UniqId _ raw') = raw `compare` raw'
  (UniqId c raw) `compare` (UniqId c' raw') =
    let rawc = raw `compare` raw'
    in
      case rawc of
        EQ -> c `compare` c'
        _ -> rawc
  (UniqId _ raw) `compare` (UserId raw') = raw `compare` raw'


type RawIdEnv a = Map.Map RawId a
type Env a = Map.Map UniqId a
type CloEnv a = Env a
type VEnv = Env Value
type TEnv = Env Ty


mtRawIdEnv :: RawIdEnv a
mtRawIdEnv = Map.empty

mtEnv :: Env a
mtEnv = Map.empty


data CheckedData = OfTy SourcePos Ty
  deriving (Eq, Show)


type RawAst a = a SourcePos RawId
type UniqAst a = a SourcePos UniqId
type TypedAst a = a CheckedData UniqId

type UntypedUniq a = a SourcePos UniqId
type Untyped a = a SourcePos
type Typed a = a CheckedData


data Exports = Exports
  { exportTypes :: TEnv
  , exportVars :: VEnv
  }
  deriving (Eq, Show)


-- A module value has two environments:
-- A closure environment, and an export
-- environment.  A name lookup on a module
-- can't search the closure environment, so we
-- separate them
data Module = Module (CloEnv Value) [UniqId] Exports
  deriving (Eq, Show)


data Closure = Closure UniqId Ty (CloEnv Value) [UniqId] (Typed IL)
  deriving (Eq, Show)


data Struct = Struct Ty [(UniqId, Value)]
  deriving (Eq, Show)


data Adt = Adt UniqId Int [Value]
  deriving (Eq, Show)


data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueChar Char
  | ValueModule Module
  | ValueFun Closure
  | ValueStruct Struct
  | ValueAdt Adt
  | ValueTuple [Value]
  | ValueList [Value]
  | ValueUnit
  | ValuePrim Prim
  | ValueThunk (Typed IL)
  | Err String
  deriving (Eq)


instance Show Value where
  show v =
    case v of
      ValueInt i -> show i
      ValueBool b -> show b
      ValueChar c -> printf "'%c'" c
      ValueFun (Closure fid fty _ paramIds _) -> printf "fun %s : %s" (show fid) (show fty)
      ValueStruct struct -> "struct"
      ValueAdt (Adt uid i vs) ->
        printf "%s(%s)" (show uid) (concat . intersperse ", " $ map show vs)
      ValueTuple vs -> printf "%%(%s)" $ concat . intersperse ", " $ map show vs
      ValueList vs@((ValueChar c) : _) ->
        let str = map (\(ValueChar c) -> c) vs
        in show str
      ValueList vs -> printf "[%s]" $ concat . intersperse ", " $ map show vs
      ValueUnit -> "Unit"
      ValuePrim prim -> "prim"
      Err str -> "Error = " ++ str


type ProtocolId = UniqId
type MethodId = UniqId
type TyVarId = UniqId
type FieldName = UniqId
type CtorName = UniqId


data Protocol = Protocol ProtocolId TyVarId [MethodId]
  deriving (Eq, Show)


-- data Imp = Imp TyCon Protocol
--   deriving (Eq, Show)


data ImpDictValue a =
    ImpDictValueFun [UniqId] (IL a)
  | ImpDictValueSuperDict (ImpDictValue a)
  deriving (Eq, Show)


type ImpDict a = Map.Map UniqId (ImpDictValue a)


data TyConstraint = TyConstraint ProtocolId
  deriving (Eq, Generic, Ord)


instance Out TyConstraint
instance Show TyConstraint where
  show = pretty


data Ty =
    TyApp TyCon [Ty]
  | TyPoly [TyVarId] Ty
  | TyVar TyVarId
  | TyMeta TyVarId
  | TyRef (QualifiedId SourcePos UniqId) -- Only for recursive type definitions
  | TyScheme Ty [TyConstraint]
  deriving Generic


instance Eq Ty where
  (TyApp tyConA tyAs) == (TyApp tyConB tyBs) =
    tyConA == tyConB && tyAs == tyBs
  (TyPoly aVars tyA) == (TyPoly bVars tyB) =
    tyA == tyB
  (TyVar idA) == (TyVar idB) = idA == idB
  (TyMeta idA) == (TyMeta idB) = idA == idB
  (TyRef idA) == (TyRef idB) = idA == idB
  (TyScheme tyA _) == (TyScheme tyB _) = tyA == tyB
  _ == _ = False


instance Out Ty
instance Show Ty where
  show = pretty


-- instance Show Ty where
--   show (TyApp tyCon []) = show tyCon
--   show (TyApp TyConArrow tyArgs) = concat . intersperse " -> " $ map show tyArgs
--   show (TyApp tyCon tyArgs) = printf "%s{%s}" (show tyCon) (concat . intersperse ", " $ map show tyArgs)
--   show (TyPoly [] ty) = show ty
--   show (TyPoly tyParams ty) = printf "{%s} %s" (concat . intersperse ", " $ map show tyParams) (show ty)
--   show (TyVar id) = show id
--   show (TyMeta id) = show id
--   show (TyRef qid) = show qid


data ModuleBinding =
    ModuleBindingTyCon FieldName TyCon
  | ModuleBindingTy FieldName Ty
  deriving (Eq, Show)


data TyCon =
    TyConInt
  | TyConBool
  | TyConChar
  | TyConUnit
  | TyConList
  | TyConTuple
  | TyConArrow
  | TyConStruct [FieldName]
  | TyConAdt [CtorName]
  | TyConTyFun [TyVarId] Ty
  | TyConUnique UniqId TyCon
  | TyConTyVar TyVarId -- In the body of a tyfun/poly
  | TyConTyScheme TyCon [TyConstraint] -- In the body of a protocol dec
  deriving Generic


ordIndex :: TyCon -> Int
ordIndex tyCon =
  case tyCon of
    TyConInt -> 0
    TyConBool -> 1
    TyConChar -> 2
    TyConUnit -> 3
    TyConList -> 4
    TyConTuple -> 5
    TyConArrow -> 6
    TyConStruct _ -> 7
    TyConAdt _ -> 8
    TyConTyFun _ _ -> 9
    TyConUnique _ _ -> 10
    TyConTyVar _ -> 11
    TyConTyScheme tyCon _ -> ordIndex tyCon


instance Ord TyCon where
  TyConUnique idA _ <= TyConUnique idB _ = idA <= idB
  TyConTyVar idA <= TyConTyVar idB = idA <= idB
  a <= b = ordIndex a <= ordIndex b


instance Eq TyCon where
  TyConInt == TyConInt = True
  TyConBool == TyConBool = True
  TyConChar == TyConChar = True
  TyConUnit == TyConUnit = True
  TyConList == TyConList = True
  TyConTuple == TyConTuple = True
  TyConArrow == TyConArrow = True
  TyConUnique ida _ == TyConUnique idb _ = ida == idb
  TyConTyVar ida == TyConTyVar idb = ida == idb
  TyConTyScheme tyConA _ == TyConTyScheme tyConB _ = tyConA == tyConB
  _ == _ = False


instance Out TyCon
instance Show TyCon where
  show = pretty


-- instance Show TyCon where
--   show TyConInt = "Int"
--   show TyConBool = "Bool"
--   show TyConChar = "Char"
--   show TyConUnit = "Unit"
--   show TyConList = "[]"
--   show TyConTuple = "(,)"
--   show (TyConUnique id _) = show id
--   show (TyConTyFun [] ty) = show ty
