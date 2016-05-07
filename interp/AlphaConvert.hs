module AlphaConvert where

import Common
import Control.Monad.Except
import Control.Monad.State
import Data.List (all, find, nub)
import Errors
import Prelude hiding (lookup)
import Semant
import Text.Printf (printf)


data AlphaEnv = AlphaEnv Int [(RawId, UniqId)]
  deriving (Eq)


type AlphaConverted a = ExceptT Err (State AlphaEnv) a


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
      throwError $ ErrUnboundRawIdentifier id


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

convertTyAnn :: TyAnn RawId -> AlphaConverted (TyAnn UniqId)
convertTyAnn (TyAnn id tyParamIds ty) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  ty' <- convertTy ty
  return $ TyAnn id' tyParamIds' ty'

convertTy :: SynTy RawId -> AlphaConverted (SynTy UniqId)
convertTy SynTyInt = return SynTyInt
convertTy SynTyBool = return SynTyBool
convertTy SynTyString = return SynTyString
convertTy SynTyUnit = return SynTyUnit
convertTy (SynTyArrow paramTys retTy) = do
  paramTys' <- mapM convertTy paramTys
  retTy' <- convertTy retTy
  return $ SynTyArrow paramTys' retTy'

convertTy (SynTyModule paramTys maybeImplTy) = do
  paramTys' <- mapM convertTy paramTys
  case maybeImplTy of
    Just ty -> do
      implTy' <- convertTy ty
      return $ SynTyModule paramTys' $ Just implTy'
    _ ->
      return $ SynTyModule paramTys' Nothing

convertTy (SynTyInterface paramIds) = do
  paramIds' <- mapM freshM paramIds
  return $ SynTyInterface paramIds'

convertTy (SynTyDefault qid tyArgs) = do
  qid' <- convertQualId qid
  tyArgs' <- mapM convertTy tyArgs
  return $ SynTyDefault qid' tyArgs'

convertTy (SynTyStruct fields) = do
  fields' <- mapM (\(id, ty) -> do { ty' <- convertTy ty; return (UserId id, ty') }) fields
  return $ SynTyStruct fields'

convertTy (SynTyTuple tys) = do
  tys' <- mapM convertTy tys
  return $ SynTyTuple tys'

convertTy (SynTyList ty) = do
  ty' <- convertTy ty
  return $ SynTyList ty'

convertTy (SynTyRef qid tyArgs) = do
  tyArgs' <- mapM convertTy tyArgs
  qid' <- convertQualId qid
  return $ SynTyRef qid' tyArgs'


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

convertPatExp (PatExpList es) = do
  es' <- mapM convertPatExp es
  return $ PatExpList es'

convertPatExp (PatExpListCons eHd eTl) = do
  eHd' <- convertPatExp eHd
  eTl' <- convertPatExp eTl
  return $ PatExpListCons eHd' eTl'


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


-- The rule is as follows (with this particular
-- example for a 3-arity function):
-- F1 (P11, P12, P13) --> BODY1
-- F2 (P21, P22, P23) --> BODY2
--
-- ==>
--
-- F(ID1, ID2, ID3) {
--   switch ((ID1, ID2, ID3)) {
--     case (P11, P12, P13) -> BODY1'
--     case (P21, P22, P23) -> BODY2'
--   }
-- }
--
-- where:
--    * ID1, ID2, ID3 are all (fresh) unique identifiers
--      not already occurring in the environment.
--    * BODY1' = alphaConvert BODY1 (alphaEnv + ID1, ID2, ID3)
--    * BODY2' = alphaConvert BODY2 (alphaEnv + ID1, ID2, ID3)
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
        throwError $ ErrFunDefArityMismatch fid


-- cond {
--   test1 -> es1
--   test2 -> es2
--   _ -> es3
-- }
--
-- ==>
--
-- if (test1) {
--   es1
-- } else (
--   if (test2) {
--     es2
--   } else (
--     if (True) {
--       es3
--     } else {
--       fail("Inexhaustive cond")
--     }))
desugarCondClause :: CondCaseClause RawId -> (Exp RawId, [Exp RawId])
desugarCondClause (CondCaseClause testE bodyEs) = (testE, bodyEs)
desugarCondClause (CondCaseClauseWildcard bodyEs) = (ExpBool True, bodyEs)


desugarCondClauses :: [CondCaseClause RawId] -> Exp RawId
desugarCondClauses (clause:clauses) =
  let (testE, bodyEs) = desugarCondClause clause
      elseEs = case clauses of
                 [] -> [ExpFail "Inexhaustive cond expression"]
                 _ -> [desugarCondClauses clauses]
  in
    ExpIfElse testE bodyEs elseEs


desugarCond :: Exp RawId -> Exp RawId
desugarCond (ExpCond clauses) = desugarCondClauses clauses


convertAnnDec :: Exp RawId -> AlphaConverted (Exp UniqId)
convertAnnDec (ExpAnnDec id tyParamIds ty annDefs) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  ty' <- convertTy ty
  case ty' of
    (SynTyModule _ _) ->
      if length annDefs /= 1
      then throwError $ ErrTooManyModuleDefs id'
      else
        if not $ all isAnnDefModule annDefs
        then throwError $ ErrNoModuleDefInModuleDec id'
        else
          let (AnnDefModule defId defE) = head annDefs
          in do
            defId' <- lookup defId
            defE' <- convert defE
            return $ ExpAnnDec id' tyParamIds' ty' [AnnDefModule defId' defE']
    (SynTyArrow _ _) ->
      if not $ all isAnnDefFun annDefs
      then throwError $ ErrNonFunDefsInFunDec id'
      else
        let funDefs = map (\(AnnDefFun funDef) -> funDef) annDefs
        in do funDef' <- (liftM fst) $ desugarFunDefs id' funDefs
              return $ ExpAnnDec id' tyParamIds' ty' [AnnDefFun funDef']
    _ ->
      if length annDefs /= 1
      then throwError $ ErrMultipleDefsInSimpleAnnDec id'
      else
        let (AnnDefExp e) = head annDefs
        in do e' <- convert e
              return $ ExpAnnDec id' tyParamIds' ty' [AnnDefExp e']


convert :: Exp RawId -> AlphaConverted (Exp UniqId)
convert (ExpAdd a b) = convertBin ExpAdd a b
convert (ExpSub a b) = convertBin ExpSub a b
convert (ExpDiv a b) = convertBin ExpDiv a b
convert (ExpMul a b) = convertBin ExpMul a b
convert (ExpCons a b) = convertBin ExpCons a b
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

-- Function bindings must be done early
-- for recursive applications
convert (ExpAssign patExp (ExpFun paramIds bodyEs)) = do
  patExp' <- convertPatExp patExp
  paramIds' <- mapM freshM paramIds
  bodyEs' <- mapM convert bodyEs
  return $ ExpAssign patExp' $ ExpFun paramIds' bodyEs'

convert (ExpAssign patExp e) = do
  e' <- convert e
  patExp' <- convertPatExp patExp
  return $ ExpAssign patExp' e'

convert (ExpTypeDec (TypeDecTy id ty)) = do
  id' <- freshM id
  ty' <- convertTy ty
  return $ ExpTypeDec $ TypeDecTy id' ty'

convert (ExpTypeDec (TypeDecAdt id tyParamIds alts)) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  alts' <- mapM convertAdtAlternative alts
  return $ ExpTypeDec $ TypeDecAdt id' tyParamIds' alts'

convert expAnnDec@(ExpAnnDec _ _ _ _) = convertAnnDec expAnnDec

convert (ExpInterfaceDec id tyParamIds memberTyAnns) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  memberTyAnns' <- mapM convertTyAnn memberTyAnns
  return $ ExpInterfaceDec id' tyParamIds' memberTyAnns'

convert (ExpModule paramIds bodyEs) = do
  paramIds' <- mapM freshM paramIds
  bodyEs' <- mapM convert bodyEs
  return $ ExpModule paramIds' bodyEs'

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

convert e@(ExpCond clauses) = convert $ desugarCond e

convert (ExpTuple es) = do
  es' <- mapM convert es
  return $ ExpTuple es'

convert (ExpList es) = do
  es' <- mapM convert es
  return $ ExpList es'

convert (ExpFun paramIds bodyEs) = do
  paramIds' <- mapM (\id -> freshM id) paramIds
  bodyEs' <- mapM convert bodyEs
  return $ ExpFun paramIds' bodyEs'

convert (ExpNum s) = return $ ExpNum s
convert (ExpBool b) = return $ ExpBool b
convert (ExpString s) = return $ ExpString s
convert ExpUnit = return ExpUnit
convert (ExpFail msg) = return $ ExpFail msg
convert (ExpRef id) = do
  id' <- lookup id
  return $ ExpRef id'


alphaConvert :: CompUnit RawId -> Either Err (CompUnit UniqId, AlphaEnv)
alphaConvert (CompUnit exps) = do
  let (eithExps, alphaEnv) = runState (runExceptT $ mapM convert exps) (AlphaEnv 1 [])
  exps' <- eithExps
  return (CompUnit exps', alphaEnv)
