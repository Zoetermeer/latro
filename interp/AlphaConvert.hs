module AlphaConvert where

import Common
import Control.Monad.Except
import Control.Monad.State
import Data.List (find, nub)
import Prelude hiding (lookup)
import Syntax
import Text.Printf (printf)

data UniqId =
    UserId RawId
  | UniqId Int RawId

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

instance Show UniqId where
  show (UserId raw) = raw
  show (UniqId _ raw) = raw


showHum :: UniqId -> String
showHum (UserId id) = id
showHum (UniqId _ id) = id


data AlphaEnv = AlphaEnv Int [(RawId, UniqId)]
  deriving (Eq, Show)


type AlphaConverted a = ExceptT FailMessage (State AlphaEnv) a


fresh :: RawId -> AlphaEnv -> (UniqId, AlphaEnv)
fresh id (AlphaEnv counter table) =
  let counter' = counter + 1
      uniqId = UniqId counter id
  in
    (uniqId, AlphaEnv counter' ((id, uniqId):table))


freshM :: RawId -> AlphaConverted UniqId
freshM id = do
  alphaEnv <- lift get
  let (uniqId, alphaEnv') = fresh id alphaEnv
  lift $ put alphaEnv'
  return uniqId


lookup :: RawId -> AlphaConverted UniqId
lookup id = do
  (AlphaEnv _ table) <- lift get
  let maybeUniqId = find (\(key, uid) -> key == id) table
  case maybeUniqId of
    Just uniqId -> return $ snd uniqId
    Nothing ->
      throwError $ printf "Unbound identifier '%s'" id


convertBin :: (Exp UniqId -> Exp UniqId -> Exp UniqId) -> Exp RawId -> Exp RawId -> AlphaConverted (Exp UniqId)
convertBin c a b = do
  a' <- convert a
  b' <- convert b
  return $ c a' b'


convertQualId :: QualifiedId RawId -> AlphaConverted (QualifiedId UniqId)
convertQualId (Id id) = do
  id' <- lookup id
  return $ Id id'

convertQualId (Path qid id) = do
  qid' <- convertQualId qid
  id' <- lookup id
  return $ Path qid' id'

convertTy :: Ty RawId -> AlphaConverted (Ty UniqId)
convertTy TyInt = return TyInt
convertTy TyBool = return TyBool
convertTy TyUnit = return TyUnit
convertTy (TyArrow paramTys retTy) = do
  paramTys' <- mapM convertTy paramTys
  retTy' <- convertTy retTy
  return $ TyArrow paramTys' retTy'

convertTy TyModule = return TyModule
convertTy TyInterface = return TyInterface
convertTy (TyStruct fields) = do
  fields' <- mapM (\(id, ty) -> do { ty' <- convertTy ty; return (UserId id, ty') }) fields
  return $ TyStruct fields'

convertTy (TyTuple tys) = do
  tys' <- mapM convertTy tys
  return $ TyTuple tys'

convertTy (TyRef qid) = do
  qid' <- convertQualId qid
  return $ TyRef qid'


convertAdtAlternative :: AdtAlternative RawId -> AlphaConverted (AdtAlternative UniqId)
convertAdtAlternative (AdtAlternative id i tys) = do
  id' <- freshM id
  tys' <- mapM convertTy tys
  return $ AdtAlternative id' i tys'


convertPatExp :: PatExp RawId -> AlphaConverted (PatExp UniqId)
convertPatExp PatExpWildcard = return $ PatExpWildcard
convertPatExp (PatExpNumLiteral s) = return $ PatExpNumLiteral s
convertPatExp (PatExpBoolLiteral b) = return $ PatExpBoolLiteral b
convertPatExp (PatExpTuple es) = do
  es' <- mapM convertPatExp es
  return $ PatExpTuple es'

convertPatExp (PatExpId id) = do
  id' <- freshM id
  return $ PatExpId id'

convertPatExp (PatExpAdt id es) = do
  id' <- lookup id
  es' <- mapM convertPatExp es
  return $ PatExpAdt id' es'


convertFunDef :: FunDef RawId -> AlphaConverted (FunDef UniqId)
convertFunDef (FunDefFun id argPatEs bodyEs) = do
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- lookup id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefFun id' argPatEs' bodyEs'

convertFunDef (FunDefInstFun instPatE id argPatEs bodyEs) = do
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- freshM id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefInstFun instPatE' id' argPatEs' bodyEs'


convertCaseClause (CaseClause patE es) = do
  patE' <- convertPatExp patE
  es' <- mapM convert es
  return $ CaseClause patE' es'


funDefToCaseClause :: FunDef RawId -> AlphaConverted (CaseClause UniqId)
funDefToCaseClause (FunDefFun _ argPatEs bodyEs) = do
  let tupPat = PatExpTuple argPatEs
  tupPat' <- convertPatExp tupPat
  bodyEs' <- mapM convert bodyEs
  return $ CaseClause tupPat' bodyEs'


desugarFunDefs :: UniqId -> [FunDef RawId] -> AlphaConverted (FunDef UniqId, [UniqId])
desugarFunDefs fid funDefs =
  let paramsLen = nub $ map (\(FunDefFun _ patEs _) -> length patEs) funDefs
  in
    case paramsLen of
      [len] -> do
        paramIds <- mapM (\_ -> freshM "arg") $ replicate len ()
        let argsTup = ExpTuple $ map ExpRef paramIds
        cases <- mapM funDefToCaseClause funDefs
        return (FunDefFun fid (map PatExpId paramIds) [ExpSwitch argsTup cases], paramIds)
      _ ->
        throwError $ printf "Function definitions for '%s' must all have matching arity." $ show fid


convert :: Exp RawId -> AlphaConverted (Exp UniqId)
convert (ExpAdd a b) = convertBin ExpAdd a b
convert (ExpSub a b) = convertBin ExpSub a b
convert (ExpDiv a b) = convertBin ExpDiv a b
convert (ExpMul a b) = convertBin ExpMul a b
convert (ExpNot e) = do
  e' <- convert e
  return $ ExpNot e'

convert (ExpMemberAccess e id) = do
  e' <- convert e
  return $ ExpMemberAccess e' (UserId id)

convert (ExpApp ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp ratorE' randEs'

convert (ExpAssign patExp e) = do
  e' <- convert e
  patExp' <- convertPatExp patExp
  return $ ExpAssign patExp' e'

convert (ExpTypeDec (TypeDecTy id ty)) = do
  id' <- freshM id
  ty' <- convertTy ty
  return $ ExpTypeDec $ TypeDecTy id' ty'

convert (ExpTypeDec (TypeDecAdt id alts)) = do
  id' <- freshM id
  alts' <- mapM convertAdtAlternative alts
  return $ ExpTypeDec $ TypeDecAdt id' alts'

convert (ExpFunDec (FunDecFun id funTy fundefs)) = do
  id' <- freshM id
  funTy' <- convertTy funTy
  (fundef', paramIds) <- desugarFunDefs id' fundefs
  return $ ExpFunDec $ FunDecFun id' funTy' [fundef']

convert (ExpFunDec (FunDecInstFun id instTy funTy fundefs)) = do
  id' <- freshM id
  instTy' <- convertTy instTy
  funTy' <- convertTy funTy
  fundefs' <- mapM convertFunDef fundefs
  return $ ExpFunDec $ FunDecInstFun id' instTy' funTy' fundefs'

convert (ExpModule bodyEs) = do
  bodyEs' <- mapM convert bodyEs
  return $ ExpModule bodyEs'

convert (ExpStruct eDefiner fields) = do
  eDefiner' <- convert eDefiner
  fields' <- mapM (\(fieldId, fieldE) -> do { fieldE' <- convert fieldE; fieldId' <- freshM fieldId; return (fieldId', fieldE') }) fields
  return $ ExpStruct eDefiner' fields'

convert (ExpIfElse condE thenEs elseEs) = do
  condE' <- convert condE
  thenEs' <- mapM convert thenEs
  elseEs' <- mapM convert elseEs
  return $ ExpIfElse condE' thenEs' elseEs'

convert (ExpSwitch e clauses) = do
  e' <- convert e
  clauses' <- mapM convertCaseClause clauses
  return $ ExpSwitch e' clauses'

convert (ExpTuple es) = do
  es' <- mapM convert es
  return $ ExpTuple es'

convert (ExpNum s) = return $ ExpNum s
convert (ExpBool b) = return $ ExpBool b
convert ExpUnit = return ExpUnit
convert (ExpRef id) = do
  id' <- lookup id
  return $ ExpRef id'


alphaConvert :: CompUnit RawId -> Either FailMessage (CompUnit UniqId, AlphaEnv)
alphaConvert (CompUnit exps) = do
  let (eithExps, alphaEnv) = runState (runExceptT $ mapM convert exps) (AlphaEnv 1 [])
  exps' <- eithExps
  return (CompUnit exps', alphaEnv)
