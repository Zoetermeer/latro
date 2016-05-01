module Semant where

import qualified Data.Map as Map

type RawId = String


data QualifiedId id =
    Id id
  | Path (QualifiedId id) id
  deriving (Eq, Show)


data CompUnit id = CompUnit [Exp id]
  deriving (Eq, Show)


data PatExp id =
    PatExpNumLiteral String
  | PatExpBoolLiteral Bool
  | PatExpTuple [PatExp id]
  | PatExpAdt id [PatExp id]
  | PatExpList [PatExp id]
  | PatExpListCons (PatExp id) (PatExp id)
  | PatExpId id
  | PatExpWildcard
  deriving (Eq, Show)


data CaseClause id =
    CaseClause (PatExp id) [Exp id]
  deriving (Eq, Show)


data Exp id =
    ExpAdd (Exp id) (Exp id)
  | ExpSub (Exp id) (Exp id)
  | ExpDiv (Exp id) (Exp id)
  | ExpMul (Exp id) (Exp id)
  | ExpCons (Exp id) (Exp id)
  | ExpNot (Exp id)
  | ExpMemberAccess (Exp id) id
  | ExpApp (Exp id) [Exp id]
  | ExpImport (QualifiedId id)
  | ExpAssign (PatExp id) (Exp id)
  | ExpTypeDec (TypeDec id)
  | ExpAnnDec id [id] (SynTy id) [AnnDef id]
  | ExpInterfaceDec id [id] [TyAnn id]
  | ExpModule [id] [Exp id]
  | ExpStruct (Exp id) [(id, Exp id)]
  | ExpIfElse (Exp id) [Exp id] [Exp id]
  | ExpMakeAdt (SynTy id) Int [Exp id]
  | ExpTuple [Exp id]
  | ExpSwitch (Exp id) [CaseClause id]
  | ExpList [Exp id]
  | ExpFun [id] [Exp id]
  | ExpNum String
  | ExpBool Bool
  | ExpString String
  | ExpRef id
  | ExpUnit
  deriving (Eq, Show)

data TyAnn id = TyAnn id [id] (SynTy id)
  deriving (Eq, Show)


data AnnDef id =
    AnnDefModule id (Exp id)
  | AnnDefFun (FunDef id)
  | AnnDefExp (Exp id)
  deriving (Eq, Show)

isAnnDefFun :: AnnDef id -> Bool
isAnnDefFun (AnnDefFun _) = True
isAnnDefFun _ = False

isAnnDefModule :: AnnDef id -> Bool
isAnnDefModule (AnnDefModule _ _) = True
isAnnDefModule _ = False


data TypeDec id =
    TypeDecTy id (SynTy id)
  | TypeDecAdt id [AdtAlternative id]
  deriving (Eq, Show)


getTypeDecId :: TypeDec id -> id
getTypeDecId (TypeDecTy id _) = id
getTypeDecId (TypeDecAdt id _) = id


data AdtAlternative id =
    AdtAlternative id Int [SynTy id]
  deriving (Eq, Show)


data SynTy id =
    SynTyInt
  | SynTyBool
  | SynTyString
  | SynTyUnit
  | SynTyArrow [SynTy id] (SynTy id)
  | SynTyModule [SynTy id] (Maybe (SynTy id))
  | SynTyInterface [id]
  | SynTyDefault (QualifiedId id) [SynTy id]
  | SynTyStruct [(id, (SynTy id))]
  | SynTyAdt id [AdtAlternative id]
  | SynTyTuple [SynTy id]
  | SynTyList (SynTy id)
  | SynTyRef (QualifiedId id) [SynTy id]
  deriving (Eq, Show)


data FunDec id =
    FunDecFun id (SynTy id) [FunDef id]
  | FunDecInstFun id (SynTy id) (SynTy id) [FunDef id]
  deriving (Eq, Show)


data FunDef id =
    FunDefFun id [PatExp id] [Exp id]
  | FunDefInstFun (PatExp id) id [PatExp id] [Exp id]
  deriving (Eq, Show)


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
type TEnv = Map.Map UniqId (SynTy UniqId)


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


data Closure = Closure UniqId (SynTy UniqId) ClosureEnv [UniqId] [Exp UniqId]
  deriving (Eq, Show)


data Struct = Struct (SynTy UniqId) [(UniqId, Value)]
  deriving (Eq, Show)


data Adt = Adt (SynTy UniqId) Int [Value]
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
  | TyRef (QualifiedId UniqId) -- Only for recursive type definitions
  deriving (Eq, Show)

data ModuleBinding =
    ModuleBindingTyCon FieldName TyCon
  | ModuleBindingTy FieldName Ty
  deriving (Eq, Show)

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
  | TyConModule [TyVarId] [ModuleBinding]
  | TyConInterface [ModuleBinding]
  | TyConTyFun [TyVarId] Ty
  | TyConUnique UniqId TyCon
  | TyConTyVar TyVarId -- In the body of a tyfun/poly
  deriving (Eq, Show)

