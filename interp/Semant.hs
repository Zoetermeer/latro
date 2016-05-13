module Semant where

import qualified Data.Map as Map


type LineNumber = Int
type ColNumber = Int
type SourceFilePath = String
data SourcePos = SourcePos SourceFilePath LineNumber ColNumber
  deriving (Eq, Show)


type RawId = String


data QualifiedId a id =
    Id a id
  | Path a (QualifiedId a id) id
  deriving (Eq, Show)

class AstNode a where
  nodeData :: a b id -> b


instance AstNode QualifiedId where
  nodeData (Id d _) = d
  nodeData (Path d _ _) = d


data CompUnit a id = CompUnit a [Exp a id]
  deriving (Eq, Show)


instance AstNode CompUnit where
  nodeData (CompUnit d _) = d


data PatExp a id =
    PatExpNumLiteral a String
  | PatExpBoolLiteral a Bool
  | PatExpTuple a [PatExp a id]
  | PatExpAdt a id [PatExp a id]
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
      PatExpTuple d _ -> d
      PatExpAdt d _ _ -> d
      PatExpList d _ -> d
      PatExpListCons d _ _ -> d
      PatExpId d _ -> d
      PatExpWildcard d -> d


data CaseClause a id =
    CaseClause a (PatExp a id) [Exp a id]
  deriving (Eq, Show)


instance AstNode CaseClause where
  nodeData (CaseClause d _ _) = d


data CondCaseClause a id =
    CondCaseClause a (Exp a id) [Exp a id]
  | CondCaseClauseWildcard a [Exp a id]
  deriving (Eq, Show)


instance AstNode CondCaseClause where
  nodeData (CondCaseClause d _ _) = d
  nodeData (CondCaseClauseWildcard d _) = d


data Exp a id =
    ExpAdd a (Exp a id) (Exp a id)
  | ExpSub a (Exp a id) (Exp a id)
  | ExpDiv a (Exp a id) (Exp a id)
  | ExpMul a (Exp a id) (Exp a id)
  | ExpCons a (Exp a id) (Exp a id)
  | ExpNot a (Exp a id)
  | ExpMemberAccess a (Exp a id) id
  | ExpApp a (Exp a id) [Exp a id]
  | ExpImport a (QualifiedId a id)
  | ExpAssign a (PatExp a id) (Exp a id)
  | ExpTypeDec a (TypeDec a id)
  | ExpAnnDec a id [id] (SynTy a id) [AnnDef a id]
  | ExpInterfaceDec a id [id] [TyAnn a id]
  | ExpModule a [id] [Exp a id]
  | ExpStruct a (SynTy a id) [(id, Exp a id)]
  | ExpIfElse a (Exp a id) [Exp a id] [Exp a id]
  | ExpMakeAdt a id Int [Exp a id]
  | ExpTuple a [Exp a id]
  | ExpSwitch a (Exp a id) [CaseClause a id]
  | ExpCond a [CondCaseClause a id]
  | ExpList a [Exp a id]
  | ExpFun a [id] [Exp a id]
  | ExpNum a String
  | ExpBool a Bool
  | ExpString a String
  | ExpRef a id
  | ExpUnit a
  | ExpBegin a [Exp a id]
  | ExpFail a String
  deriving (Eq, Show)


instance AstNode Exp where
  nodeData e =
    case e of
      ExpAdd d _ _ -> d
      ExpSub d _ _ -> d
      ExpDiv d _ _ -> d
      ExpMul d _ _ -> d
      ExpCons d _ _ -> d
      ExpNot d _ -> d
      ExpMemberAccess d _ _ -> d
      ExpApp d _ _ -> d
      ExpImport d _ -> d
      ExpAssign d _ _ -> d
      ExpTypeDec d _ -> d
      ExpAnnDec d _ _ _ _ -> d
      ExpInterfaceDec d _ _ _ -> d
      ExpModule d _ _ -> d
      ExpStruct d _ _ -> d
      ExpIfElse d _ _ _ -> d
      ExpMakeAdt d _ _ _ -> d
      ExpTuple d _ -> d
      ExpSwitch d _ _ -> d
      ExpCond d _ -> d
      ExpList d _ -> d
      ExpFun d _ _ -> d
      ExpNum d _ -> d
      ExpBool d _ -> d
      ExpString d _ -> d
      ExpRef d _ -> d
      ExpUnit d -> d
      ExpFail d _ -> d


data TyAnn a id = TyAnn a id [id] (SynTy a id)
  deriving (Eq, Show)


instance AstNode TyAnn where
  nodeData (TyAnn d _ _ _) = d


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
isAnnDefModule (AnnDefModule _ _ _) = True
isAnnDefModule _ = False


data TypeDec a id =
    TypeDecTy a id (SynTy a id)
  | TypeDecAdt a id [id] [AdtAlternative a id]
  deriving (Eq, Show)


instance AstNode TypeDec where
  nodeData td =
    case td of
      TypeDecTy d _ _ -> d
      TypeDecAdt d _ _ _ -> d


getTypeDecId :: TypeDec a id -> id
getTypeDecId (TypeDecTy _ id _) = id
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
  | SynTyUnit a
  | SynTyArrow a [SynTy a id] (SynTy a id)
  | SynTyModule a [SynTy a id] (Maybe (SynTy a id))
  | SynTyInterface a [id]
  | SynTyDefault a (QualifiedId a id) [SynTy a id]
  | SynTyStruct a [(id, (SynTy a id))]
  | SynTyAdt a id [AdtAlternative a id]
  | SynTyTuple a [SynTy a id]
  | SynTyList a (SynTy a id)
  | SynTyRef a (QualifiedId a id) [SynTy a id]
  deriving (Eq, Show)


instance AstNode SynTy where
  nodeData sty =
    case sty of
      SynTyInt d -> d
      SynTyBool d -> d
      SynTyString d -> d
      SynTyUnit d -> d
      SynTyArrow d _ _ -> d
      SynTyModule d _ _ -> d
      SynTyInterface d _ -> d
      SynTyDefault d _ _ -> d
      SynTyStruct d _ -> d
      SynTyAdt d _ _ -> d
      SynTyTuple d _ -> d
      SynTyList d _ -> d
      SynTyRef d _ _ -> d


data FunDef a id =
    FunDefFun a id [PatExp a id] [Exp a id]
  | FunDefInstFun a (PatExp a id) id [PatExp a id] [Exp a id]
  deriving (Eq, Show)


instance AstNode FunDef where
  nodeData fd =
    case fd of
      FunDefFun d _ _ _ -> d
      FunDefInstFun d _ _ _ _ -> d


data UniqId =
    UserId RawId
  | UniqId Int RawId
  deriving (Show)

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


type VEnv = Map.Map UniqId Value
type TEnv = Map.Map UniqId Ty


data CheckedData = OfTy SourcePos Ty
  deriving (Eq, Show)


type RawAst a = a SourcePos RawId
type UniqAst a = a SourcePos UniqId
type TypedAst a = a CheckedData UniqId


data ClosureEnv = ClosureEnv
  { cloTypeEnv :: TEnv
  , cloVarEnv :: VEnv
  }
  deriving (Eq, Show)


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
data Module = Module ClosureEnv [UniqId] Exports
  deriving (Eq, Show)


data Closure = Closure UniqId Ty ClosureEnv [UniqId] [Exp CheckedData UniqId]
  deriving (Eq, Show)


data Struct = Struct Ty [(UniqId, Value)]
  deriving (Eq, Show)


data Adt = Adt UniqId Int [Value]
  deriving (Eq, Show)


data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueStr String
  | ValueModule Module
  | ValueFun Closure
  | ValueStruct Struct
  | ValueAdt Adt
  | ValueTuple [Value]
  | ValueList [Value]
  | ValueUnit
  | Err String
  deriving (Eq, Show)


type TyVarId = UniqId
type FieldName = UniqId
type CtorName = UniqId

data Ty =
    TyApp TyCon [Ty]
  | TyPoly [TyVarId] Ty
  | TyVar TyVarId
  | TyMeta TyVarId
  | TyRef (QualifiedId SourcePos UniqId) -- Only for recursive type definitions
  deriving (Eq, Show)

data ModuleBinding =
    ModuleBindingTyCon FieldName TyCon
  | ModuleBindingTy FieldName Ty
  deriving (Eq, Show)

data TCModule = TCModule
  { types :: Map.Map UniqId TyCon
  , vars :: Map.Map UniqId Ty
  , patFuns :: Map.Map UniqId Ty
  }
  deriving (Eq, Show)

mtTCModule :: TCModule
mtTCModule =
  TCModule { types = Map.empty
           , vars = Map.empty
           , patFuns = Map.empty
           }


addModuleVar :: TCModule -> UniqId -> Ty -> TCModule
addModuleVar mod id ty =
  mod { vars = Map.insert id ty (vars mod) }


addModuleTy :: TCModule -> UniqId -> TyCon -> TCModule
addModuleTy mod id tyCon =
  mod { types = Map.insert id tyCon (types mod) }


addModulePat :: TCModule -> UniqId -> Ty -> TCModule
addModulePat mod id ty =
  mod { patFuns = Map.insert id ty (patFuns mod) }


data TyCon =
    TyConInt
  | TyConBool
  | TyConString
  | TyConUnit
  | TyConList
  | TyConTuple
  | TyConArrow
  | TyConStruct [FieldName]
  | TyConAdt [CtorName]
  | TyConModule [TyVarId] TCModule
  | TyConInterface [ModuleBinding]
  | TyConTyFun [TyVarId] Ty
  | TyConUnique UniqId TyCon
  | TyConTyVar TyVarId -- In the body of a tyfun/poly
  deriving (Eq, Show)
