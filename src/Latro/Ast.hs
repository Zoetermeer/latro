{-# LANGUAGE DeriveGeneric #-}
module Latro.Ast where

import Text.PrettyPrint.GenericPretty

type LineNumber = Int
type ColNumber = Int
type SourceFilePath = String
data SourcePos = SourcePos SourceFilePath LineNumber ColNumber
  deriving (Eq, Generic, Show)


type RawId = String


type RawAst a = a SourcePos RawId
type UniqAst a = a SourcePos UniqId

instance Out SourcePos


instance Ord SourcePos where
  (SourcePos pathA lineA colA) <= (SourcePos pathB lineB colB) =
    pathA <= pathB && lineA <= lineB && colA <= colB


mtSourcePos :: SourcePos
mtSourcePos = SourcePos "??" 0 0


data QualifiedId a id =
    Id a id
  | Path a (QualifiedId a id) id
  deriving (Generic, Show)


instance Eq id => Eq (QualifiedId a id) where
  Id _ id1 == Id _ id2 = id1 == id2
  Path _ qid1 id1 == Path _ qid2 id2 =
    id1 == id2 && qid1 == qid2
  _ == _ = False


instance (Ord a, Ord id) => Ord (QualifiedId a id) where
  compare Id{} Path{} = LT
  compare Path{} Id{} = GT
  compare (Id _ ida) (Id _ idb) =
    ida `compare` idb

  compare (Path _ qida ida) (Path _ qidb idb) =
    let cq = qida `compare` qidb
        ci = ida `compare` idb
    in case cq of
        EQ -> ci
        _  -> cq


instance (Out a, Out id) => Out (QualifiedId a id)


mkPath :: Maybe (UniqAst QualifiedId) -> UniqId -> UniqAst QualifiedId
mkPath maybeQid id = maybe (Id mtSourcePos id) ((flip (Path mtSourcePos)) id) maybeQid


pathCombine :: QualifiedId a id -> QualifiedId a id -> QualifiedId a id
pathCombine qid (Path p qid' id) = Path p (qid `pathCombine` qid') id
pathCombine qid (Id p id) = Path p qid id


infixl 5 +.+
(+.+) = pathCombine


basePath :: UniqAst QualifiedId -> UniqAst QualifiedId
basePath (Path _ qid _) = qid
basePath id = id


stripPath :: UniqAst QualifiedId -> UniqId
stripPath (Id _ id) = id
stripPath (Path _ _ id) = id


class AstNode a where
  nodeData :: a b id -> b


instance AstNode QualifiedId where
  nodeData (Id d _) = d
  nodeData (Path d _ _) = d


class BindingOccurrence a where
  bindingId :: a d id -> id


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


-- This is unsafe!
assumeIdPat :: PatExp a id -> id
assumeIdPat (PatExpId _ id) = id


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


type UniqTyAnn a = TyAnn a UniqId


instance BindingOccurrence TyAnn where
  bindingId (TyAnn _ id _ _ _) = id


data FunDef a id =
    FunDefFun a id [PatExp a id] (Exp a id)
  deriving (Eq, Show)


instance AstNode FunDef where
  nodeData (FunDefFun d _ _ _) = d


data FieldInit a id = FieldInit id (Exp a id)
  deriving (Eq, Show)


data Constraint a id = Constraint a id id
  deriving (Eq, Show)


instance AstNode Constraint where
  nodeData (Constraint d _ _) = d


data ImportClause a id =
    ImportClauseExcept a [id]
  | ImportClauseRenaming a [(id, id)]
  deriving (Eq, Show)

instance AstNode ImportClause where
  nodeData (ImportClauseExcept p _) = p
  nodeData (ImportClauseRenaming p _) = p  


data Exp a id =
  ExpCons a (Exp a id) (Exp a id)
  | ExpInParens a (Exp a id)
  | ExpCustomInfix a (Exp a id) id (Exp a id)
  | ExpMemberAccess a (Exp a id) id
  | ExpApp a (Exp a id) [Exp a id]
  | ExpPrim a id
  | ExpImport a (QualifiedId a id)
  | ExpImportAs a (QualifiedId a id) id
    -- The exp is the original import exp (either regular or import-as).  Type could be refined here
    -- The list of ids is the import-subset (empty if none specified)
    -- Import clauses are the except/renaming clauses
  | ExpSelectiveImport a (Exp a id) [id] [ImportClause a id]
  | ExpTopLevelAssign a (PatExp a id) (Exp a id)
  | ExpAssign a (PatExp a id) (Exp a id)
  | ExpTypeDec a (TypeDec a id)
  | ExpDataDec a (TypeDec a id)
  | ExpProtoDec a id id [Constraint a id] [TyAnn a id]
  | ExpProtoImp a (SynTy a id) id [Constraint a id] [Exp a id]
  | ExpTopLevelTyAnn (TyAnn a id)
  | ExpTyAnn (TyAnn a id)
  | ExpWithAnn (TyAnn a id) (Exp a id)
  | ExpFunDef (FunDef a id)
  | ExpFunDefClauses a id [FunDef a id]
  | ExpInterfaceDec a id [id] [TyAnn a id]
  | ExpModule a (QualifiedId a id) [Exp a id]
  | ExpTypeModule a (QualifiedId a id) (TypeDec a id) [Exp a id]
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
      ExpImportAs d _ _ -> d
      ExpSelectiveImport d _ _ _ -> d
      ExpTopLevelAssign d _ _ -> d
      ExpAssign d _ _ -> d
      ExpTypeDec d _ -> d
      ExpDataDec d _ -> d
      ExpTopLevelTyAnn (TyAnn d _ _ _ _) -> d
      ExpTyAnn (TyAnn d _ _ _ _) -> d
      ExpProtoDec d _ _ _ _ -> d
      ExpProtoImp d _ _ _ _ -> d
      ExpWithAnn _ e -> nodeData e
      ExpFunDef (FunDefFun d _ _ _) -> d
      ExpInterfaceDec d _ _ _ -> d
      ExpModule d _ _ -> d
      ExpTypeModule d _ _ _ -> d
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
  | TypeDecImplicit a (TypeDec a id)
  | TypeDecEmpty a id [id]
  deriving (Eq, Show)


instance AstNode TypeDec where
  nodeData td =
    case td of
      TypeDecTy d _ _ _ -> d
      TypeDecAdt d _ _ _ -> d
      TypeDecImplicit d _ -> d
      TypeDecEmpty d _ _ -> d


getTypeDecId :: TypeDec a id -> Maybe id
getTypeDecId (TypeDecTy _ id _ _) = Just id
getTypeDecId (TypeDecAdt _ id _ _) = Just id
getTypeDecId (TypeDecImplicit _ _) = Nothing
getTypeDecId (TypeDecEmpty _ id _) = Just id


renameTypeDec :: TypeDec a id -> id -> TypeDec a id
renameTypeDec (TypeDecTy p id tyParamIds synTy) newId = TypeDecTy p newId tyParamIds synTy
renameTypeDec (TypeDecAdt p id tyParamIds alts) newId = TypeDecAdt p newId tyParamIds alts
renameTypeDec tyDec@TypeDecImplicit{} newId = tyDec
renameTypeDec (TypeDecEmpty p id tyParamIds) newId = TypeDecEmpty p newId tyParamIds


mapTyDecTys :: TypeDec a id -> (SynTy a id -> SynTy a id) -> TypeDec a id
mapTyDecTys (TypeDecTy p id tyParamIds sty) f = TypeDecTy p id tyParamIds $ f sty
mapTyDecTys (TypeDecAdt p id tyParamIds alts) f =
  TypeDecAdt p id tyParamIds $ map (\(AdtAlternative ap aid ai atys) -> AdtAlternative ap aid ai (map f atys)) alts

mapTyDecTys (TypeDecImplicit p tyDec) f = TypeDecImplicit p $ mapTyDecTys tyDec f
mapTyDecTys (TypeDecEmpty p id tyParamIds) _ = TypeDecEmpty p id tyParamIds


getTypeDecParams :: TypeDec a id -> [id]
getTypeDecParams tyDec =
  case tyDec of
    TypeDecTy _ _ tyParams _ -> tyParams
    TypeDecAdt _ _ tyParams _ -> tyParams
    TypeDecImplicit _ tyDec -> getTypeDecParams tyDec
    TypeDecEmpty _ _ tyParams -> tyParams


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
  | SynTyPrim a id
  | SynTyUnknown a id
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


fieldAccessorFunId :: RawId -> RawId -> RawId
fieldAccessorFunId tyId accId = "@" ++ tyId ++ "_" ++ accId


instance AstNode SynTy where
  nodeData sty =
    case sty of
      SynTyInt d -> d
      SynTyBool d -> d
      SynTyString d -> d
      SynTyChar d -> d
      SynTyUnit d -> d
      SynTyPrim d _ -> d
      SynTyUnknown d _ -> d
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


showFullUniqId :: UniqId -> String
showFullUniqId (UserId raw) = "(UserId '" ++ raw ++ "')"
showFullUniqId (UniqId i raw) = "(UniqId " ++ show i ++ " '" ++ raw ++ "')"

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


getRawId :: UniqId -> RawId
getRawId (UserId rawId) = rawId
getRawId (UniqId _ rawId) = rawId
