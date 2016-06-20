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


nextIdIndex :: AlphaEnv -> Int
nextIdIndex (AlphaEnv i _) = i


lookup :: RawId -> AlphaConverted UniqId
lookup id = do
  (AlphaEnv _ table) <- lift get
  let maybeUniqId = find (\(key, uid) -> key == id) table
  case maybeUniqId of
    Just uniqId -> return $ snd uniqId
    Nothing ->
      throwError $ ErrUnboundRawIdentifier id


convertBin  :: (SourcePos -> UniqAst Exp -> UniqAst Exp -> UniqAst Exp)
            -> SourcePos
            -> RawAst Exp
            -> RawAst Exp
            -> AlphaConverted (UniqAst Exp)
convertBin c p a b = do
  a' <- convert a
  b' <- convert b
  return $ c p a' b'


convertQualId :: RawAst QualifiedId -> AlphaConverted (UniqAst QualifiedId)
convertQualId (Id p id) = do
  id' <- lookup id
  return $ Id p id'

convertQualId (Path p qid id) = do
  qid' <- convertQualId qid
  return $ Path p qid' $ UserId id


convertTyAnn :: RawAst TyAnn -> AlphaConverted (UniqAst TyAnn)
convertTyAnn (TyAnn p id tyParamIds ty) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  ty' <- convertTy ty
  return $ TyAnn p id' tyParamIds' ty'


convertTy :: RawAst SynTy -> AlphaConverted (UniqAst SynTy)
convertTy (SynTyInt p) = return $ SynTyInt p
convertTy (SynTyBool p) = return $ SynTyBool p
convertTy (SynTyChar p) = return $ SynTyChar p
convertTy (SynTyUnit p) = return $ SynTyUnit p
convertTy (SynTyArrow p paramTys retTy) = do
  paramTys' <- mapM convertTy paramTys
  retTy' <- convertTy retTy
  return $ SynTyArrow p paramTys' retTy'

convertTy (SynTyModule p paramTys maybeImplTy) = do
  paramTys' <- mapM convertTy paramTys
  case maybeImplTy of
    Just ty -> do
      implTy' <- convertTy ty
      return $ SynTyModule p paramTys' $ Just implTy'
    _ ->
      return $ SynTyModule p paramTys' Nothing

convertTy (SynTyInterface p paramIds) = do
  paramIds' <- mapM freshM paramIds
  return $ SynTyInterface p paramIds'

convertTy (SynTyDefault p qid tyArgs) = do
  qid' <- convertQualId qid
  tyArgs' <- mapM convertTy tyArgs
  return $ SynTyDefault p qid' tyArgs'

convertTy (SynTyStruct p fields) = do
  fields' <- mapM (\(id, ty) -> do { ty' <- convertTy ty; return (UserId id, ty') }) fields
  return $ SynTyStruct p fields'

convertTy (SynTyTuple p tys) = do
  tys' <- mapM convertTy tys
  return $ SynTyTuple p tys'

convertTy (SynTyList p ty) = do
  ty' <- convertTy ty
  return $ SynTyList p ty'

convertTy (SynTyRef p qid tyArgs) = do
  tyArgs' <- mapM convertTy tyArgs
  qid' <- convertQualId qid
  return $ SynTyRef p qid' tyArgs'


convertAdtAlternative :: Int -> RawAst AdtAlternative -> AlphaConverted (UniqAst AdtAlternative)
convertAdtAlternative index (AdtAlternative p id _ tys) = do
  id' <- freshM id
  tys' <- mapM convertTy tys
  return $ AdtAlternative p id' index tys'


convertPatExp :: RawAst PatExp -> AlphaConverted (UniqAst PatExp)
convertPatExp (PatExpWildcard p) = return $ PatExpWildcard p
convertPatExp (PatExpNumLiteral p s) = return $ PatExpNumLiteral p s
convertPatExp (PatExpBoolLiteral p b) = return $ PatExpBoolLiteral p b
convertPatExp (PatExpStringLiteral p s) = return $ PatExpStringLiteral p s
convertPatExp (PatExpCharLiteral p s) = return $ PatExpCharLiteral p s
convertPatExp (PatExpTuple p es) = do
  es' <- mapM convertPatExp es
  return $ PatExpTuple p es'

convertPatExp (PatExpId p id) = do
  id' <- freshM id
  return $ PatExpId p id'

convertPatExp (PatExpAdt p qid es) = do
  qid' <- convertQualId qid
  es' <- mapM convertPatExp es
  return $ PatExpAdt p qid' es'

convertPatExp (PatExpList p es) = do
  es' <- mapM convertPatExp es
  return $ PatExpList p es'

convertPatExp (PatExpListCons p eHd eTl) = do
  eHd' <- convertPatExp eHd
  eTl' <- convertPatExp eTl
  return $ PatExpListCons p eHd' eTl'


convertFunDef :: RawAst FunDef -> AlphaConverted (UniqAst FunDef)
convertFunDef (FunDefFun p id argPatEs bodyEs) = do
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- lookup id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefFun p id' argPatEs' bodyEs'

convertFunDef (FunDefInstFun p instPatE id argPatEs bodyEs) = do
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- freshM id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefInstFun p instPatE' id' argPatEs' bodyEs'


convertCaseClause :: RawAst CaseClause -> AlphaConverted (UniqAst CaseClause)
convertCaseClause (CaseClause p patE es) = do
  patE' <- convertPatExp patE
  es' <- mapM convert es
  return $ CaseClause p patE' es'


funDefToCaseClause :: RawAst FunDef -> AlphaConverted (UniqAst CaseClause)
funDefToCaseClause (FunDefFun p _ argPatEs bodyEs) = do
  let tupPat = PatExpTuple p argPatEs
  tupPat' <- convertPatExp tupPat
  bodyEs' <- mapM convert bodyEs
  return $ CaseClause p tupPat' bodyEs'

funDefToCaseClause (FunDefInstFun p instPatE _ argPatEs bodyEs) = do
  let tupPat = PatExpTuple p $ instPatE : argPatEs
  tupPat' <- convertPatExp tupPat
  bodyEs' <- mapM convert bodyEs
  return $ CaseClause p tupPat' bodyEs'


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
funDefArity :: RawAst FunDef -> Int
funDefArity (FunDefFun _ _ patEs _) = length patEs
funDefArity (FunDefInstFun _ _ _ patEs _) = length patEs


desugarFunDefs :: UniqId -> [RawAst FunDef] -> AlphaConverted (UniqAst FunDef, [UniqId])
desugarFunDefs fid funDefs =
  let arities = nub $ map funDefArity funDefs
      headFunDef = head funDefs
      startP = nodeData headFunDef
  in
    case arities of
      [len] -> do
        paramIds <- replicateM len ((\_ -> freshM "arg") ())
        cases <- mapM funDefToCaseClause funDefs
        let paramRefs = map (ExpRef startP) paramIds
            paramPats = map (PatExpId startP) paramIds
        case headFunDef of
          FunDefFun _ _ argPatEs bodyEs ->
            let argsTup = ExpTuple startP paramRefs
            in
              return (FunDefFun startP fid paramPats [ExpSwitch startP argsTup cases], paramIds)
          FunDefInstFun _ instPatE _ argPatEs bodyEs ->
            do instId <- freshM "this"
               let instRef = ExpRef startP instId
                   argsTup = ExpTuple startP (instRef : paramRefs)
               return (FunDefInstFun startP (PatExpId startP instId) fid paramPats [ExpSwitch startP argsTup cases], paramIds)
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
desugarCondClause :: RawAst CondCaseClause -> (RawAst Exp, [RawAst Exp])
desugarCondClause (CondCaseClause _ testE bodyEs) = (testE, bodyEs)
desugarCondClause (CondCaseClauseWildcard p bodyEs) = (ExpBool p True, bodyEs)


desugarCondClauses :: SourcePos -> [RawAst CondCaseClause] -> RawAst Exp
desugarCondClauses p (clause:clauses) =
  let (testE, bodyEs) = desugarCondClause clause
      elseEs = case clauses of
                 [] -> [ExpFail p "Inexhaustive cond expression"]
                 _ -> [desugarCondClauses p clauses]
  in
    ExpIfElse (nodeData testE) testE bodyEs elseEs


desugarCond :: RawAst Exp -> RawAst Exp
desugarCond (ExpCond p clauses) = desugarCondClauses p clauses


convert :: RawAst Exp -> AlphaConverted (UniqAst Exp)
convert (ExpAdd p a b) = convertBin ExpAdd p a b
convert (ExpSub p a b) = convertBin ExpSub p a b
convert (ExpDiv p a b) = convertBin ExpDiv p a b
convert (ExpMul p a b) = convertBin ExpMul p a b
convert (ExpCons p a b) = convertBin ExpCons p a b
convert (ExpCustomInfix p lhe id rhe) = do
  lhe' <- convert lhe
  rhe' <- convert rhe
  id' <- lookup id
  return $ ExpApp p (ExpRef p id') [lhe', rhe']

convert (ExpMemberAccess p e id) = do
  e' <- convert e
  return $ ExpMemberAccess p e' (UserId id)

convert (ExpApp p ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp p ratorE' randEs'

convert (ExpFunDef (FunDefFun p id argPatEs bodyEs)) = do
  id' <- freshM id
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  return $ ExpFunDef $ FunDefFun p id' argPatEs' bodyEs'

convert (ExpFunDef (FunDefInstFun p instPatE id argPatEs bodyEs)) = do
  id' <- freshM id
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  return $ ExpFunDef $ FunDefInstFun p instPatE' id' argPatEs' bodyEs'

convert (ExpFunDefClauses p id funDefs) = do
  id' <- freshM id
  funDef <- liftM fst $ desugarFunDefs id' funDefs
  return $ ExpFunDef funDef

convert (ExpAssign p patExp e) = do
  e' <- convert e
  patExp' <- convertPatExp patExp
  return $ ExpAssign p patExp' e'

convert (ExpTypeDec p (TypeDecTy pInner id tyParamIds ty)) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  ty' <- convertTy ty
  return $ ExpTypeDec p $ TypeDecTy pInner id' tyParamIds' ty'

convert (ExpTypeDec p (TypeDecAdt pInner id tyParamIds alts)) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  alts' <- mapMi convertAdtAlternative alts
  return $ ExpTypeDec p $ TypeDecAdt pInner id' tyParamIds' alts'

convert (ExpTyAnn (TyAnn _ id _ _)) =
  throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convert (ExpWithAnn (TyAnn p aid tyParamIds synTy) e) = do
  aid' <- freshM aid
  tyParamIds' <- mapM freshM tyParamIds
  synTy' <- convertTy synTy
  let tyAnn = TyAnn p aid' tyParamIds' synTy'
  case e of
    ExpFunDef (FunDefFun fp fid argPatEs bodyEs) ->
      do argPatEs' <- mapM convertPatExp argPatEs
         bodyEs' <- mapM convert bodyEs
         let e' = ExpFunDef (FunDefFun fp aid' argPatEs' bodyEs')
         return $ ExpWithAnn tyAnn e'
    ExpFunDefClauses p id funDefs ->
      do funDef <- liftM fst $ desugarFunDefs aid' funDefs
         return $ ExpWithAnn tyAnn $ ExpFunDef funDef
    ExpAssign ep (PatExpId pp pid) e ->
      do e' <- convert e
         return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp aid') e'
    _ -> throwError $ ErrInterpFailure $ "in convert ExpWithAnn: " ++ show e

convert (ExpInterfaceDec p id tyParamIds memberTyAnns) = do
  id' <- freshM id
  tyParamIds' <- mapM freshM tyParamIds
  memberTyAnns' <- mapM convertTyAnn memberTyAnns
  return $ ExpInterfaceDec p id' tyParamIds' memberTyAnns'

convert (ExpModule p paramIds bodyEs) = do
  paramIds' <- mapM freshM paramIds
  bodyEs' <- mapM convert bodyEs
  return $ ExpModule p paramIds' bodyEs'

convert (ExpStruct p synTy fields) = do
  synTy' <- convertTy synTy
  fields' <- mapM (\(fieldId, fieldE) -> do { fieldE' <- convert fieldE; fieldId' <- freshM fieldId; return (fieldId', fieldE') }) fields
  return $ ExpStruct p synTy' fields'

convert (ExpIfElse p condE thenEs elseEs) = do
  condE' <- convert condE
  thenEs' <- mapM convert thenEs
  elseEs' <- mapM convert elseEs
  return $ ExpIfElse p condE' thenEs' elseEs'

convert (ExpSwitch p e clauses) = do
  e' <- convert e
  clauses' <- mapM convertCaseClause clauses
  return $ ExpSwitch p e' clauses'

convert e@(ExpCond _ clauses) = convert $ desugarCond e

convert (ExpTuple p es) = do
  es' <- mapM convert es
  return $ ExpTuple p es'

convert (ExpList p es) = do
  es' <- mapM convert es
  return $ ExpList p es'

convert (ExpFun p argPatEs bodyEs) = do
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  return $ ExpFun p argPatEs' bodyEs'

convert (ExpPrecAssign p id level) = do
  id' <- lookup id
  -- TODO: Update the operator-precedence table
  return $ ExpBegin p [ExpUnit p]
  -- return $ ExpPrecAssign p id' level

convert (ExpNum p s) = return $ ExpNum p s
convert (ExpBool p b) = return $ ExpBool p b
convert (ExpString p s) = return $ ExpString p s
convert (ExpChar p s) = return $ ExpChar p s
convert (ExpUnit p) = return $ ExpUnit p
convert (ExpFail p msg) = return $ ExpFail p msg
convert (ExpRef p id) = do
  id' <- lookup id
  return $ ExpRef p id'


collectFunDefs :: RawId -> [RawAst Exp] -> ([RawAst FunDef], [RawAst Exp])
collectFunDefs _ [] = ([], [])
collectFunDefs id (eFunDef@(ExpFunDef funDef@(FunDefFun _ fid _ _)) : es)
  | id == fid =
    let (funDefs, es') = collectFunDefs id es
    in (funDef : funDefs, es')
  | otherwise = ([], eFunDef : es)

collectFunDefs _ es = ([], es)


collectInstFunDefs :: RawId -> [RawAst Exp] -> ([RawAst FunDef], [RawAst Exp])
collectInstFunDefs _ [] = ([], [])
collectInstFunDefs id (eFunDef@(ExpFunDef funDef@(FunDefInstFun _ _ fid _ _)) : es)
  | id == fid =
    let (funDefs, es') = collectInstFunDefs id es
    in (funDef : funDefs, es')
  | otherwise = ([], eFunDef : es)

collectInstFunDefs _ es = ([], es)


collapseBindingExp :: RawId -> [RawAst Exp] -> Either Err (RawAst Exp, [RawAst Exp])
collapseBindingExp id (e@(ExpAssign _ (PatExpId _ pid) _) : es)
  | id == pid = return (e, es)
  | otherwise = throwError $ ErrNoBindingAfterTyAnn id

collapseBindingExp id _ = throwError $ ErrNoBindingAfterTyAnn id


collapseEs :: [RawAst Exp] -> Either Err [RawAst Exp]
collapseEs [] = return []
collapseEs (ExpTyAnn tyAnn@(TyAnn ap aid _ synTy) : es) =
  case synTy of
    SynTyArrow {} ->
      let (funDefs, es') = collectFunDefs aid es
          eFunDef = ExpFunDefClauses ap aid funDefs
      in if null funDefs
           then throwError $ ErrNoBindingAfterTyAnn aid
           else do es'' <- collapseEs es'
                   return (ExpWithAnn tyAnn eFunDef : es'')
    _ ->
      do (e, es') <- collapseBindingExp aid es
         es'' <- collapseEs es'
         return (ExpWithAnn tyAnn e : es'')

collapseEs (ExpFunDef (FunDefFun p fid argPatEs bodyEs) : es) = do
  bodyEs' <- collapseEs bodyEs
  let (funDefs, es') = collectFunDefs fid es
      funDef = FunDefFun p fid argPatEs bodyEs'
      eFunDef = ExpFunDefClauses p fid (funDef : funDefs)
  es'' <- collapseEs es'
  return (eFunDef : es'')

collapseEs (ExpFunDef (FunDefInstFun p instPatE fid argPatEs bodyEs) : es) = do
  bodyEs' <- collapseEs bodyEs
  let (funDefs, es') = collectInstFunDefs fid es
      funDef = FunDefInstFun p instPatE fid argPatEs bodyEs'
      eFunDef = ExpFunDefClauses p fid (funDef : funDefs)
  es'' <- collapseEs es'
  return (eFunDef : es'')

collapseEs (e : es) = do
  e' <- collapse e
  es' <- collapseEs es
  return (e' : es')


collapse :: RawAst Exp -> Either Err (RawAst Exp)
collapse (ExpAssign p patE e) = do
  e' <- collapse e
  return $ ExpAssign p patE e'

collapse (ExpFunDef (FunDefFun p id argPatEs bodyEs)) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpFunDef $ FunDefFun p id argPatEs bodyEs'

collapse (ExpModule p paramIds bodyEs) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpModule p paramIds bodyEs'

collapse e = return e


alphaConvert :: RawAst CompUnit -> Either Err (UniqAst CompUnit, AlphaEnv)
alphaConvert (CompUnit pos exps) = do
  collapsedEs <- collapseEs exps
  let (eithExps, alphaEnv) = runState (runExceptT $ mapM convert collapsedEs) (AlphaEnv 1 [])
  exps' <- eithExps
  return (CompUnit pos exps', alphaEnv)
