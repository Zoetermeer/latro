{-# LANGUAGE FlexibleContexts, FlexibleInstances, NamedFieldPuns, TypeSynonymInstances #-}

{-|
Module      : AlphaConvert
Description : Rewrite the syntax tree such that all bound identifiers are unique

The rewriting guarantees that we cannot have shadowing or substitution problems
downstream.  As part of this transformation, we replace all qualified (raw) identifiers
with their unqualified, alpha-converted equivalents and factor out module definitions
altogether.

The only special case is member accesses, which cannot be alpha-converted because
the converter doesn't keep track of the types of variables.
-}
module Latro.AlphaConvert where

import Control.Monad (when)
import Control.Monad.Except
import Control.Monad.State
import Data.List (intercalate, nub)
import qualified Data.Map.Strict as Map
import Data.Maybe (fromJust)
import Debug.Trace
import Latro.Common
import Latro.Compiler
import Latro.Errors
import Latro.Semant
import Prelude hiding (lookup)
import Text.Printf (printf)

reportErrorAt a = reportPosOnFail a "AlphaConvert"


pushNewLexicalScope :: AlphaConverted LexicalScope
pushNewLexicalScope = do
  index <- nextIdIndexM
  let scope = mtLexicalScope index
  pushLexicalScope scope
  return scope


pushLexicalScope :: LexicalScope -> AlphaConverted ()
pushLexicalScope scope = do
  index <- nextIdIndexM
  modifyAC (\aEnv -> aEnv { stack = scope : stack aEnv })


pushNewOrExistingNamespace :: UniqId -> AlphaConverted Namespace
pushNewOrExistingNamespace id = do
  curPath <- getsAC curPath
  curNs <- getsAC curNs
  let nsPath = mkPath curPath id
  maybeNs <- lookupNsSafe nsPath
  ns <- case maybeNs of
          Just ns -> do { pushLexicalScope (scope ns); return ns }
          _       -> do { newScope <- pushNewLexicalScope; return $ mkNs id $ index newScope }
  modifyAC (\aEnv -> aEnv { curPath = Just nsPath, curNs = Just ns, nsEnv = Map.insert nsPath ns (nsEnv aEnv) })
  case (curPath, curNs) of
    (Just outerPath, Just outerNs) -> modifyAC (\aEnv -> aEnv { nsEnv = Map.insert outerPath outerNs (nsEnv aEnv) })
    _ -> return ()
  return ns


popNs :: AlphaConverted ()
popNs = do
  maybeNsPath <- getsAC curPath
  nsPath <- case maybeNsPath of
              Just path -> return path
              _         -> throwError $ ErrInterpFailure "Attempted to pop nonexistent namespace"
  let outerPath = case nsPath of
                    Id{} -> Nothing
                    Path _ qid _ -> Just qid
  nsLexicalScope <- popLexicalScope
  maybeNs <- getsAC curNs
  let ns = fromJust maybeNs
  outerNs <- case outerPath of
              Nothing -> return Nothing
              Just path -> do { theNs <- lookupNs path; return $ Just theNs }
  theNsEnv <- getsAC nsEnv
  modifyAC (\aEnv -> aEnv { nsEnv = Map.insert nsPath (ns { scope = nsLexicalScope }) theNsEnv
                          , curPath = outerPath
                          , curNs = outerNs
                          })


popLexicalScope :: AlphaConverted LexicalScope
popLexicalScope = do
  scopes <- getsAC stack
  modifyAC (\aEnv -> aEnv { stack = tail scopes })
  return $ head scopes


inNewLexicalScope :: AlphaConverted a -> AlphaConverted a
inNewLexicalScope thunk = do
  pushNewLexicalScope
  v <- thunk
  popLexicalScope
  return v


modifyLexicalScope :: (LexicalScope -> LexicalScope) -> AlphaConverted ()
modifyLexicalScope fModify = do
  (scope : scopes) <- getsAC stack
  modifyAC (\aEnv -> aEnv { stack = fModify scope : scopes })


exportVar :: UniqId -> UniqId -> AlphaConverted ()
exportVar (UserId rawId) uid = do
  maybeNs <- getsAC curNs
  case maybeNs of
    Just ns -> let exports' = (exports ns) { varIdEnv = Map.insert rawId uid (varIdEnv (exports ns)) }
               in modifyAC (\aEnv -> aEnv { curNs = Just $ ns { exports = exports' } })
    _       -> return ()


exportTy :: UniqId -> UniqId -> AlphaConverted ()
exportTy (UserId rawId) uid = do
  maybeNs <- getsAC curNs
  case maybeNs of
    Just ns -> let exports' = (exports ns) { typeIdEnv = Map.insert rawId uid (typeIdEnv (exports ns)) }
               in modifyAC (\aEnv -> aEnv { curNs = Just $ ns { exports = exports' } })
    _       -> return ()
exportTy UniqId{} _ = return ()


freshVarId :: Bool -> UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshVarId bindInLexicalScope (UserId id) aEnv@AlphaEnv { counter, stack } =
    (uniqId, aEnv { counter = counter', stack = scope' : scopes })
  where
    counter' = counter + 1
    uniqId = UniqId counter id
    (scope : scopes) = stack
    scope' = if bindInLexicalScope
             then scope { varIdEnv = Map.insert id uniqId $ varIdEnv scope }
             else scope

freshVarId _ id aEnv = (id, aEnv)


freshTypeId :: UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshTypeId (UserId id) aEnv@AlphaEnv { counter, stack } =
    (uniqId, aEnv { counter = counter', stack = scope' : scopes })
  where
    counter' = counter + 1
    uniqId = UniqId counter id
    (scope : scopes) = stack
    scope' = scope { typeIdEnv = Map.insert id uniqId $ typeIdEnv scope }

freshTypeId id aEnv = (id, aEnv)


freshM :: UniqId -> (UniqId -> AlphaEnv -> (UniqId, AlphaEnv)) -> AlphaConverted UniqId
freshM userId@(UserId id) fMake = do
  alphaEnv <- getAC
  let (uniqId, alphaEnv') = fMake userId alphaEnv
  putAC alphaEnv'
  return uniqId

freshM id _ = return id


freshIdIfNotBoundM :: UniqId -> (LexicalScope -> RawIdEnv UniqId) -> (UniqId -> AlphaConverted UniqId) -> AlphaConverted UniqId
freshIdIfNotBoundM uid@UniqId{} _ _ = return uid
freshIdIfNotBoundM userId getEnv makeFreshId = do
  curLexicalScope <- getsAC $ head . stack
  when (isBoundIn userId [curLexicalScope] getEnv) (throwError $ ErrIdAlreadyBound userId)
  makeFreshId userId



freshVarIdM :: UniqId -> AlphaConverted UniqId
freshVarIdM id = freshM id $ freshVarId True


freshVarIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshVarIdIfNotBoundM id = freshIdIfNotBoundM id varIdEnv freshVarIdM


freshTypeIdM :: UniqId -> AlphaConverted UniqId
freshTypeIdM id = freshM id freshTypeId


freshTypeIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshTypeIdIfNotBoundM id = freshIdIfNotBoundM id typeIdEnv freshTypeIdM


nextIdIndex :: AlphaEnv -> Int
nextIdIndex AlphaEnv{ counter } = counter


nextIdIndexM :: AlphaConverted Int
nextIdIndexM = do
  aEnv <- getAC
  let next = nextIdIndex aEnv
  putAC $ aEnv { counter = next }
  return next


freshCtorIdM :: UniqId -> AlphaConverted UniqId
freshCtorIdM id@(UserId rawId) = do
  id' <- freshVarIdIfNotBoundM id
  modifyLexicalScope (\sc -> sc { ctorEnv = Map.insert rawId id' (ctorEnv sc) })
  return id'


isBoundIn :: UniqId -> [LexicalScope] -> (LexicalScope -> RawIdEnv a) -> Bool
isBoundIn uid@UniqId{} _ _ = True
isBoundIn id [] _ = False
isBoundIn userId@(UserId id) (scope : scopes) getEnv =
  case Map.lookup id (getEnv scope) of
    Just _ -> True
    _      -> isBoundIn userId scopes getEnv


lookupNsSafe :: UniqAst QualifiedId -> AlphaConverted (Maybe Namespace)
lookupNsSafe qid = do
  nsEnv <- getsAC nsEnv
  return $ Map.lookup qid nsEnv


lookupNs :: UniqAst QualifiedId -> AlphaConverted Namespace
lookupNs qid = do
  maybeNs <- lookupNsSafe qid
  case maybeNs of
    Just ns -> return ns
    _       -> throwError $ ErrInvalidUniqModulePath qid


lookupIn :: UniqId -> [LexicalScope] -> (LexicalScope -> RawIdEnv UniqId) -> AlphaConverted UniqId
lookupIn id [] _ = throwError $ ErrUnboundUniqIdentifier id
lookupIn id (scope : scopes) getEnv =
  case lookupUniqId id (getEnv scope) of
    Just id -> return id
    _       -> lookupIn id scopes getEnv


lookup :: UniqId -> (LexicalScope -> RawIdEnv UniqId) -> AlphaConverted UniqId
lookup id getEnv = do
  stack <- getsAC stack
  lookupIn id stack getEnv


class ACLookup a where
  lookupVar   :: a -> AlphaConverted UniqId
  lookupTy    :: a -> AlphaConverted UniqId
  lookupCtor  :: a -> AlphaConverted UniqId


instance ACLookup (UniqAst QualifiedId) where
  lookupVar (Id p id) = lookup id varIdEnv
  lookupVar qid@(Path p innerQid id) = do
    ns <- lookupNs innerQid `reportErrorAt` nodeData innerQid
    catchError (lookupIn id [exports ns] varIdEnv) (\_ -> throwError $ ErrUnboundQualIdentifier qid) `reportErrorAt` p


  lookupTy (Id p id) = lookup id typeIdEnv
  lookupTy (Path p qid id) = do
    ns <- lookupNs qid
    lookupIn id [exports ns] typeIdEnv `reportErrorAt` p


  lookupCtor (Id p id) = lookup id ctorEnv
  lookupCtor (Path p qid id) = do
    ns <- lookupNs qid
    lookupIn id [exports ns] ctorEnv `reportErrorAt` p


instance ACLookup UniqId where
  lookupVar uid@UniqId{} = return uid
  lookupVar uid = do
    scopes <- getsAC stack
    lookupIn uid scopes varIdEnv


  lookupTy uid@UniqId{} = return uid
  lookupTy uid = do
    scopes <- getsAC stack
    lookupIn uid scopes typeIdEnv


  lookupCtor uid@UniqId{} = return uid
  lookupCtor userId = do
    scopes <- getsAC stack
    lookupIn userId scopes ctorEnv


-- |Find the environment for the module at the base path of the given
-- qualified ID.  If it's not a path, just return the current
-- frame.
baseStackLexicalScope :: UniqAst QualifiedId -> AlphaConverted [LexicalScope]
baseStackLexicalScope Id{} = getsAC stack
baseStackLexicalScope (Path _ qid _) = do
  ns <- lookupNs qid
  return [scope ns]


convertTyAnn :: UniqAst TyAnn -> AlphaConverted (UniqAst TyAnn)
convertTyAnn (TyAnn p id tyParamIds ty constrs) = do
  id' <- freshVarIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  ty' <- convertTy ty
  return $ TyAnn p id' tyParamIds' ty' constrs


convertTy :: UniqAst SynTy -> AlphaConverted (UniqAst SynTy)
convertTy (SynTyInt p) = return $ SynTyInt p
convertTy (SynTyBool p) = return $ SynTyBool p
convertTy (SynTyChar p) = return $ SynTyChar p
convertTy (SynTyUnit p) = return $ SynTyUnit p
convertTy (SynTyArrow p paramTys retTy) = do
  paramTys' <- mapM convertTy paramTys `reportErrorAt` p
  retTy' <- convertTy retTy
  return $ SynTyArrow p paramTys' retTy'

convertTy (SynTyStruct p fields) = do
  fields' <- mapM (\(id, ty) -> do { ty' <- convertTy ty; return (id, ty') }) fields
  return $ SynTyStruct p fields'

convertTy (SynTyTuple p tys) = do
  tys' <- mapM convertTy tys
  return $ SynTyTuple p tys'

convertTy (SynTyList p ty) = do
  ty' <- convertTy ty
  return $ SynTyList p ty'

convertTy (SynTyRef p qid tyArgs) = do
  tyArgs' <- mapM convertTy tyArgs
  tid' <- lookupTy qid `reportErrorAt` p
  return $ SynTyRef p (Id p tid') tyArgs'


convertPatExp :: Bool -> UniqAst PatExp -> AlphaConverted (UniqAst PatExp)
convertPatExp _ (PatExpWildcard p) = return $ PatExpWildcard p
convertPatExp _ (PatExpNumLiteral p s) = return $ PatExpNumLiteral p s
convertPatExp _ (PatExpBoolLiteral p b) = return $ PatExpBoolLiteral p b
convertPatExp _ (PatExpStringLiteral p s) = return $ PatExpStringLiteral p s
convertPatExp _ (PatExpCharLiteral p s) = return $ PatExpCharLiteral p s
convertPatExp inTopLevel (PatExpTuple p es) = do
  es' <- mapM (convertPatExp inTopLevel) es
  return $ PatExpTuple p es'

convertPatExp inTopLevel (PatExpId p id) = do
  maybeCtorId <- fmap Just (lookupCtor id) `catchError` (\_ -> return Nothing)
  case maybeCtorId of
    Just ctorId -> convertPatExp inTopLevel $ PatExpAdt p (Id p ctorId) []
    Nothing -> do
      id' <- freshVarIdIfNotBoundM id `reportErrorAt` p
      when inTopLevel $ exportVar id id'
      return $ PatExpId p id'

convertPatExp inTopLevel (PatExpAdt p qid es) = do
  uniqId <- lookupVar qid `catchError` (\err -> throwError (ErrUnboundConstructor qid) `reportErrorAt` nodeData qid)
  es' <- mapM (convertPatExp inTopLevel) es
  return $ PatExpAdt p (Id p uniqId) es'

convertPatExp inTopLevel (PatExpList p es) = do
  es' <- mapM (convertPatExp inTopLevel) es
  return $ PatExpList p es'

convertPatExp inTopLevel (PatExpListCons p eHd eTl) = do
  eHd' <- convertPatExp inTopLevel eHd
  eTl' <- convertPatExp inTopLevel eTl
  return $ PatExpListCons p eHd' eTl'


convertFunDef :: UniqAst FunDef -> AlphaConverted (UniqAst FunDef)
convertFunDef (FunDefFun p id argPatEs bodyE) = do
  argPatEs' <- mapM (convertPatExp False) argPatEs
  id' <- lookupVar id
  bodyE' <- convert bodyE
  return $ FunDefFun p id' argPatEs' bodyE'


convertCaseClause :: UniqAst CaseClause -> AlphaConverted (UniqAst CaseClause)
convertCaseClause (CaseClause p patE e) = do
  pushNewLexicalScope
  patE' <- convertPatExp False patE
  e' <- convert e
  popLexicalScope
  return $ CaseClause p patE' e'


funDefToCaseClause :: UniqAst FunDef -> AlphaConverted (UniqAst CaseClause)
funDefToCaseClause (FunDefFun p _ argPatEs bodyE) = do
  let tupPat = PatExpTuple p argPatEs
  return $ CaseClause p tupPat bodyE


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
funDefArity :: UniqAst FunDef -> Int
funDefArity (FunDefFun _ _ patEs _) = length patEs


desugarFunDefs :: UniqId -> [UniqAst FunDef] -> AlphaConverted (UniqAst FunDef)
desugarFunDefs fid funDefs =
    case arities of
      [len] ->
        let paramIds = map (\i -> UserId ("@arg" ++ show i)) [1..len]
            paramRefs = map (ExpRef startP) paramIds
            paramPats = map (PatExpId startP) paramIds
            argsTup = ExpTuple startP paramRefs
        in do
          cases <- mapM funDefToCaseClause funDefs
          return $ FunDefFun startP fid paramPats (ExpSwitch startP argsTup cases)
      _ ->
        throwError $ ErrFunDefArityMismatch fid
  where arities = nub $ map funDefArity funDefs
        (FunDefFun startP _ argPatEs bodyE) = head funDefs


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
desugarCondClause :: UniqAst CondCaseClause -> (UniqAst Exp, UniqAst Exp)
desugarCondClause (CondCaseClause _ testE bodyE) = (testE, bodyE)
desugarCondClause (CondCaseClauseWildcard p bodyE) = (ExpBool p True, bodyE)


desugarCondClauses :: SourcePos -> [UniqAst CondCaseClause] -> UniqAst Exp
desugarCondClauses p (clause:clauses) =
  let (testE, bodyE) = desugarCondClause clause
      elseE = case clauses of
                 [] -> ExpFail p "Inexhaustive cond expression"
                 _  -> desugarCondClauses p clauses
  in
    ExpIfElse (nodeData testE) testE bodyE elseE


desugarCond :: UniqAst Exp -> UniqAst Exp
desugarCond (ExpCond p clauses) = desugarCondClauses p clauses


stripImplicitTypeDecs :: [UniqAst Exp] -> ([UniqAst TypeDec], [UniqAst Exp])
stripImplicitTypeDecs [] = ([], [])
stripImplicitTypeDecs (ExpTypeDec _ tyDec@(TypeDecImplicit _ innerTyDec) : es) =
    (innerTyDec : tyDecs, es')
  where
    (tyDecs, es') = stripImplicitTypeDecs es

stripImplicitTypeDecs (e : es) =
  let (typeDecs, es') = stripImplicitTypeDecs es in (typeDecs, e : es')


renameTo :: UniqAst TypeDec -> UniqId -> UniqAst Exp
renameTo (TypeDecTy p _ tyParamIds synTy) id = ExpTypeDec p $ TypeDecTy p id tyParamIds synTy
renameTo (TypeDecAdt p _ tyParamIds alts) id = ExpTypeDec p $ TypeDecAdt p id tyParamIds alts


convertBin :: (SourcePos -> UniqAst Exp -> UniqAst Exp -> UniqAst Exp)
           -> SourcePos
           -> UniqAst Exp
           -> UniqAst Exp
           -> AlphaConverted (UniqAst Exp)
convertBin c p a b = do
  a' <- convert a
  b' <- convert b
  return $ c p a' b'


convertBindingAdtAlternative :: Int -> UniqAst AdtAlternative -> AlphaConverted (UniqAst AdtAlternative)
convertBindingAdtAlternative index (AdtAlternative p id _ tys) = do
  id' <- freshCtorIdM id `reportErrorAt` p
  exportVar id id'
  return $ AdtAlternative p id' index tys


-- Populate the symbol table with alpha id's, but do
-- not try to rewrite any bound occurrences of either variable,
-- type, or type param references
convertBinding :: UniqAst Exp -> AlphaConverted (UniqAst Exp)
convertBinding (ExpTypeDec p (TypeDecAdt pInner id tyParamIds alts)) = do
  id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
  exportTy id id'
  alts' <- mapMi convertBindingAdtAlternative alts
  return $ ExpTypeDec p $ TypeDecAdt pInner id' tyParamIds alts'

convertBinding (ExpTypeDec p (TypeDecTy pInner id tyParamIds (SynTyStruct stp fieldDefs))) = do
    id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
    exportTy id id'
    return $ ExpTypeDec p $ TypeDecTy pInner id' tyParamIds $ SynTyStruct stp fieldDefs
  where (fieldIds, fieldTys) = unzip fieldDefs

convertBinding (ExpTypeDec p tyDec) = do
  id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
  exportTy id id'
  return $ ExpTypeDec p $ renameTypeDec tyDec id'
  where
    (Just id) = getTypeDecId tyDec

convertBinding (ExpBegin p es) = do
  es' <- mapM convertBinding es
  return $ ExpBegin p es'

convertBinding (ExpModule p id bodyEs) = do
  case implicitTyDecs of
    [] -> do
      ns <- pushNewOrExistingNamespace id
      bodyEs' <- mapM convertBinding otherEs
      popNs `reportErrorAt` p
      return $ ExpModule p id bodyEs'
    [tyDec] ->
      convertBinding $ ExpTypeModule p id tyDec otherEs
    _ -> throwError (ErrMultipleDataDecs id) `reportErrorAt` p
  where
    (implicitTyDecs, otherEs) = stripImplicitTypeDecs bodyEs

convertBinding (ExpTypeModule p id tyDec bodyEs) = do
  curPath <- getsAC curPath
  typeId <- freshTypeIdM (UserId "@__data")
  let absoluteModulePath = case curPath of
                            Just outerPath -> Path p outerPath id
                            _              -> Id p id
      tyDecExp = tyDec `renameTo` typeId
      tyParamIds = getTypeDecParams tyDec
      expModule = ExpModule p id (tyDecExp : bodyEs)
      typeParamIdRefs = map (\id -> SynTyRef p (Id p id) []) tyParamIds
      aliasTyDec = ExpTypeDec p (TypeDecTy p id tyParamIds (SynTyRef p (Path p absoluteModulePath typeId) typeParamIdRefs))

  aliasTyDec' <- convertBinding aliasTyDec
  expModule' <- convertBinding expModule
  return $ ExpBegin p [aliasTyDec', expModule']

convertBinding (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
  id' <- freshVarIdIfNotBoundM id
  exportVar id id'
  return $ ExpFunDef $ FunDefFun p id' argPatEs bodyE

convertBinding (ExpFunDefClauses p id funDefs) = do
  id' <- freshVarIdM id
  exportVar id id'
  funDef <- desugarFunDefs id' funDefs
  return $ ExpFunDef funDef

convertBinding (ExpTopLevelAssign p patExp e) = do
  patExp' <- convertPatExp True patExp
  return $ ExpTopLevelAssign p patExp' e

convertBinding (ExpAssign p patExp e) = do
  patExp' <- convertPatExp False patExp
  return $ ExpAssign p patExp' e

convertBinding (ExpTopLevelTyAnn (TyAnn _ id _ _ _)) =
  throwError $ ErrInterpFailure $ "ExpTopLevelTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convertBinding (ExpTyAnn (TyAnn _ id _ _ _)) =
  throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convertBinding (ExpWithAnn (TyAnn p aid tyParamIds synTy constrs) e) =
  case e of
    ExpFunDefClauses{} ->
      do e'@(ExpFunDef (FunDefFun fp fid argPatEs bodyE)) <- convertBinding e
         let tyAnn = TyAnn p fid tyParamIds synTy constrs
         return $ ExpWithAnn tyAnn e'
    ExpAssign ep patExp@(PatExpId pp pid) e -> do
      (PatExpId _ pid') <- convertPatExp False patExp
      let tyAnn = TyAnn p pid' tyParamIds synTy constrs
      return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp pid') e
    ExpTopLevelAssign ep patExp@(PatExpId pp pid) e -> do
      (PatExpId _ pid') <- convertPatExp True patExp
      let tyAnn = TyAnn p pid' tyParamIds synTy constrs
      exportVar pid pid'
      return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp pid') e
    ExpFunDef{} ->
      do e'@(ExpFunDef (FunDefFun fp fid argPatEs bodyE)) <- convertBinding e
         let tyAnn = TyAnn p fid tyParamIds synTy constrs
         return $ ExpWithAnn tyAnn e'
    _ ->
      throwError $ ErrInterpFailure $ "in convert ExpWithAnn: " ++ show e

convertBinding e = return e


convertAdtAlternative :: Int -> UniqAst AdtAlternative -> AlphaConverted (UniqAst AdtAlternative)
convertAdtAlternative index (AdtAlternative p id _ tys) = do
  tys' <- mapM convertTy tys
  return $ AdtAlternative p id index tys'


convert :: UniqAst Exp -> AlphaConverted (UniqAst Exp)
convert (ExpCons p a b) = convertBin ExpCons p a b
convert (ExpInParens p e) = do
  e' <- convert e
  return $ ExpInParens p e'

convert (ExpCustomInfix p lhe id rhe) = do
  lhe' <- convert lhe
  rhe' <- convert rhe
  id' <- lookupVar id `reportErrorAt` p
  return $ ExpCustomInfix p lhe' id' rhe'

convert (ExpMemberAccess p e@(ExpQualifiedRef qp qid) id) = do
  qid' <- lookupVar qid
  return $ ExpMemberAccess p (ExpRef qp qid') id

convert (ExpMemberAccess p e id) = do
  e' <- convert e
  return $ ExpMemberAccess p e' id

convert (ExpApp p ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp p ratorE' randEs'

convert (ExpPrim p ratorId) = return $ ExpPrim p ratorId

convert (ExpImport p qid) = do
  ns <- lookupNs qid `reportErrorAt` p
  theStack <- getsAC stack
  let curLexicalScope     = head theStack
      curVarIdEnv         = varIdEnv curLexicalScope
      curTypeIdEnv        = typeIdEnv curLexicalScope
      nsExports           = exports ns
      modVarIdEnv         = varIdEnv nsExports
      modTypeIdEnv        = typeIdEnv nsExports
      overlappingVarIds   = Map.keys $ Map.intersection curVarIdEnv modVarIdEnv
      overlappingTypeIds  = Map.keys $ Map.intersection curTypeIdEnv modTypeIdEnv
  unless (null overlappingVarIds) $ throwError (ErrOverlappingVarImport qid overlappingVarIds) `reportErrorAt` p
  unless (null overlappingTypeIds) $ throwError (ErrOverlappingTyImport qid overlappingTypeIds) `reportErrorAt` p
  modifyLexicalScope (\(curLexicalScope@LexicalScope{ varIdEnv, typeIdEnv }) ->
                        curLexicalScope { varIdEnv = Map.union varIdEnv modVarIdEnv
                                        , typeIdEnv = Map.union typeIdEnv modTypeIdEnv })
  return $ ExpUnit p

convert (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
  id' <- freshVarIdIfNotBoundM id
  pushNewLexicalScope
  argPatEs' <- mapM (convertPatExp False) argPatEs
  bodyE' <- convert bodyE
  popLexicalScope
  return $ ExpFunDef $ FunDefFun p id' argPatEs' bodyE'

convert (ExpTopLevelAssign p patExp e) = do
  e' <- convert e
  return $ ExpAssign p patExp e'

-- The pat exp must be converted after the right-hand side,
-- so bindings occurring in the former do not show
-- up in the latter
convert (ExpAssign p patExp e) = do
  e' <- convert e
  patExp' <- convertPatExp False patExp
  return $ ExpAssign p patExp' e'

convert (ExpTyAnn (TyAnn _ id _ _ _)) =
  throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convert (ExpWithAnn (TyAnn p aid tyParamIds synTy constrs) e) = do
  pushNewLexicalScope
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  synTy' <- convertTy synTy
  let tyAnn = TyAnn p aid tyParamIds' synTy' constrs
  case e of
    ExpFunDef (FunDefFun fp fid argPatEs bodyE) ->
      do pushNewLexicalScope
         argPatEs' <- mapM (convertPatExp False) argPatEs
         bodyE' <- convert bodyE
         popLexicalScope -- body frame
         popLexicalScope -- enclosing frame for type param id's
         let e' = ExpFunDef (FunDefFun fp aid argPatEs' bodyE')
         return $ ExpWithAnn tyAnn e'
    ExpAssign ep pat@(PatExpId pp pid) e ->
      do popLexicalScope -- enclosing frame for type param id's
         e' <- convert e
         convertPatExp False pat
         return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp aid) e'
    ExpTopLevelAssign ep (PatExpId pp pid) e ->
      do e' <- convert e
         popLexicalScope -- enclosing frame for type param id's
         return $ ExpWithAnn tyAnn $ ExpTopLevelAssign ep (PatExpId pp aid) e'
    _ -> throwError $ ErrInterpFailure $ "in convert ExpWithAnn: " ++ show e

convert (ExpStruct p qid fields) = do
  tid' <- lookupTy qid `reportErrorAt` nodeData qid
  fields' <- mapM (\(FieldInit fieldId fieldE) ->
                      do fieldE' <- convert fieldE
                         return $ FieldInit fieldId fieldE')
                  fields
  return $ ExpStruct p (Id (nodeData qid) tid') fields'

convert (ExpIfElse p condE thenE elseE) = do
  condE' <- convert condE
  thenE' <- inNewLexicalScope $ convert thenE
  elseE' <- inNewLexicalScope $ convert elseE
  return $ ExpIfElse p condE' thenE' elseE'

convert (ExpSwitch p e clauses) = do
  e' <- convert e
  clauses' <- mapM convertCaseClause clauses
  return $ ExpSwitch p e' clauses'

convert e@ExpCond{} = convert e'
  where e' = desugarCond e

convert (ExpTuple p es) = do
  es' <- mapM convert es
  return $ ExpTuple p es'

convert (ExpList p es) = do
  es' <- mapM convert es
  return $ ExpList p es'

convert (ExpFun p argPatEs bodyE) = do
  pushNewLexicalScope
  argPatEs' <- mapM (convertPatExp False) argPatEs
  bodyE' <- convert bodyE
  popLexicalScope
  return $ ExpFun p argPatEs' bodyE'

convert (ExpPrecAssign p id level) = do
  id' <- lookupVar id
  return $ ExpPrecAssign p id' level

convert (ExpNum p s) = return $ ExpNum p s
convert (ExpBool p b) = return $ ExpBool p b
convert (ExpString p s) = return $ ExpString p s
convert (ExpChar p s) = return $ ExpChar p s
convert (ExpUnit p) = return $ ExpUnit p
convert (ExpFail p msg) = return $ ExpFail p msg

convert (ExpBegin p es) = do
  es' <- mapM convert es
  return $ ExpBegin p es'

convert (ExpModule p id bodyEs) = do
  ns <- pushNewOrExistingNamespace id
  bodyEs' <- mapM convert bodyEs
  popNs `reportErrorAt` p
  return $ ExpBegin p bodyEs'

convert (ExpQualifiedRef p id) = do
  id' <- lookupVar id `reportErrorAt` p
  return $ ExpRef p id'

convert (ExpRef p id) = do
  id' <- lookupVar id `reportErrorAt` p
  return $ ExpRef p id'

convert (ExpTypeDec p (TypeDecTy tp tid tyParamIds synTy)) = do
  tid' <- lookupTy tid
  pushNewLexicalScope
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  synTy' <- convertTy synTy
  popLexicalScope
  return $ ExpTypeDec p $ TypeDecTy tp tid' tyParamIds' synTy'

convert (ExpTypeDec p (TypeDecAdt tp tid tyParamIds alts)) = do
  tid' <- lookupTy tid
  pushNewLexicalScope
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  alts' <- mapMi convertAdtAlternative alts
  popLexicalScope
  return $ ExpTypeDec p $ TypeDecAdt tp tid' tyParamIds' alts'

convert (ExpTypeDec p (TypeDecEmpty tp tid tyParamIds)) = do
  tid'  <- lookupTy tid
  pushNewLexicalScope
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  popLexicalScope
  return $ ExpTypeDec p $ TypeDecEmpty tp tid' tyParamIds'

convert e = throwError $ ErrInterpFailure $ printf "convert failed for: %s" $ show e


class InjectUserIds a where
  inject :: RawAst a -> UniqAst a


instance InjectUserIds QualifiedId where
  inject (Id p id) = Id p $ UserId id
  inject (Path p qid id) = Path p (inject qid) (UserId id)


instance InjectUserIds CaseClause where
  inject (CaseClause p patE bodyE) =
    CaseClause p (inject patE) (inject bodyE)


instance InjectUserIds CondCaseClause where
  inject (CondCaseClause p testE bodyE) =
    CondCaseClause p (inject testE) (inject bodyE)
  inject (CondCaseClauseWildcard p bodyE) =
    CondCaseClauseWildcard p $ inject bodyE


instance InjectUserIds PatExp where
  inject patE =
    case patE of
      PatExpNumLiteral p s -> PatExpNumLiteral p s
      PatExpBoolLiteral p b -> PatExpBoolLiteral p b
      PatExpStringLiteral p s -> PatExpStringLiteral p s
      PatExpCharLiteral p s -> PatExpCharLiteral p s
      PatExpTuple p patEs -> PatExpTuple p $ map inject patEs
      PatExpAdt p qid patEs -> PatExpAdt p (inject qid) (map inject patEs)
      PatExpList p patEs -> PatExpList p $ map inject patEs
      PatExpListCons p hdE tlE -> PatExpListCons p (inject hdE) (inject tlE)
      PatExpId p id -> PatExpId p $ UserId id
      PatExpWildcard p -> PatExpWildcard p


instance InjectUserIds FieldInit where
  inject (FieldInit id e) = FieldInit (UserId id) (inject e)


instance InjectUserIds FunDef where
  inject (FunDefFun p id argPatEs bodyE) =
    FunDefFun p (UserId id) (map inject argPatEs) (inject bodyE)


instance InjectUserIds SynTy where
  inject synTy =
    case synTy of
      SynTyInt p -> SynTyInt p
      SynTyBool p -> SynTyBool p
      SynTyString p -> SynTyString p
      SynTyChar p -> SynTyChar p
      SynTyUnit p -> SynTyUnit p
      SynTyArrow p argTys retTy -> SynTyArrow p (map inject argTys) (inject retTy)
      SynTyStruct p fieldInitPairs ->
        let (ids, tys) = unzip fieldInitPairs
            ids' = map UserId ids
            tys' = map inject tys
        in
          SynTyStruct p $ zip ids' tys'
      SynTyTuple p elemTys -> SynTyTuple p $ map inject elemTys
      SynTyAdt p id alts -> SynTyAdt p (UserId id) (map inject alts)
      SynTyList p elemTy -> SynTyList p $ inject elemTy
      SynTyRef p qid paramTys -> SynTyRef p (inject qid) (map inject paramTys)


instance InjectUserIds TyAnn where
  inject (TyAnn p id tyParamIds synTy constrs) =
    TyAnn p (UserId id) (map UserId tyParamIds) (inject synTy) (map inject constrs)


instance InjectUserIds AdtAlternative where
  inject (AdtAlternative p id i synTy) =
    AdtAlternative p (UserId id) i (map inject synTy)


instance InjectUserIds TypeDec where
  inject (TypeDecTy p id tyParamIds synTy) =
    TypeDecTy p (UserId id) (map UserId tyParamIds) (inject synTy)
  inject (TypeDecAdt p id tyParamIds alts) =
    TypeDecAdt p (UserId id) (map UserId tyParamIds) (map inject alts)
  inject (TypeDecImplicit p tyDec) = TypeDecImplicit p $ inject tyDec


instance InjectUserIds Constraint where
  inject (Constraint p tyId protoId) = Constraint p (UserId tyId) (UserId protoId)


instance InjectUserIds Exp where
  inject e =
    case e of
      ExpCons p a b -> ExpCons p (r a) (r b)
      ExpInParens p e -> ExpInParens p (r e)
      ExpCustomInfix p a rator b ->
        ExpCustomInfix p (r a) (UserId rator) (r b)
      ExpMemberAccess p e id -> ExpMemberAccess p (r e) (UserId id)
      ExpApp p rator rands -> ExpApp p (r rator) (map r rands)
      ExpPrim p rator -> ExpPrim p $ UserId rator
      ExpImport p qid -> ExpImport p $ inject qid
      ExpAssign p patE e -> ExpAssign p (inject patE) (r e)
      ExpTopLevelAssign p patE e -> ExpTopLevelAssign p (inject patE) (r e)
      ExpTypeDec p typeDec -> ExpTypeDec p $ inject typeDec
      ExpDataDec p typeDec -> ExpDataDec p $ inject typeDec
      ExpProtoDec p id tyId constrs tyAnns ->
        ExpProtoDec p (UserId id) (UserId tyId) (map inject constrs) (map inject tyAnns)
      ExpProtoImp p synTy protoId constrs bodyEs ->
        ExpProtoImp p (inject synTy) (UserId protoId) (map inject constrs) (map inject bodyEs)
      ExpTyAnn tyAnn -> ExpTyAnn $ inject tyAnn
      ExpTopLevelTyAnn tyAnn -> ExpTopLevelTyAnn $ inject tyAnn
      ExpWithAnn tyAnn e -> ExpWithAnn (inject tyAnn) $ inject e
      ExpFunDef funDef -> ExpFunDef $ inject funDef
      ExpFunDefClauses p id funDefs ->
        ExpFunDefClauses p (UserId id) (map inject funDefs)
      ExpInterfaceDec p id paramIds tyAnns ->
        ExpInterfaceDec p (UserId id) (map UserId paramIds) (map inject tyAnns)
      ExpModule p id bodyEs ->
        ExpModule p (UserId id) (map inject bodyEs)
      ExpTypeModule p id tyDec bodyEs ->
        ExpTypeModule p (UserId id) (inject tyDec) (map inject bodyEs)
      ExpStruct p qid fieldInits ->
        ExpStruct p (inject qid) (map inject fieldInits)
      ExpIfElse p e thenE elseE ->
        ExpIfElse p (inject e) (inject thenE) (inject elseE)
      ExpMakeAdt p id i argEs ->
        ExpMakeAdt p (UserId id) i (map inject argEs)
      ExpGetAdtField p e i -> ExpGetAdtField p (inject e) i
      ExpTuple p es -> ExpTuple p $ map inject es
      ExpSwitch p e clauses -> ExpSwitch p (inject e) (map inject clauses)
      ExpCond p clauses -> ExpCond p $ map inject clauses
      ExpList p es -> ExpList p $ map inject es
      ExpFun p argPatEs bodyE ->
        ExpFun p (map inject argPatEs) (inject bodyE)
      ExpNum p s -> ExpNum p s
      ExpBool p b -> ExpBool p b
      ExpString p s -> ExpString p s
      ExpChar p s -> ExpChar p s
      ExpRef p id -> ExpRef p $ UserId id
      ExpQualifiedRef p qid -> ExpQualifiedRef p $ inject qid
      ExpUnit p -> ExpUnit p
      ExpBegin p es -> ExpBegin p $ map inject es
      ExpPrecAssign p id i -> ExpPrecAssign p (UserId id) i
      ExpFail p s -> ExpFail p s
    where r = inject


type AlphaConverted a = CompilerPass CompilerEnv a


getAC :: AlphaConverted AlphaEnv
getAC = gets alphaEnv


getsAC :: (AlphaEnv -> a) -> AlphaConverted a
getsAC f = gets (f . alphaEnv)


putAC :: AlphaEnv -> AlphaConverted ()
putAC aEnv = modify (\cEnv -> cEnv { alphaEnv = aEnv })


modifyAC :: (AlphaEnv -> AlphaEnv) -> AlphaConverted ()
modifyAC f = modify (\cEnv -> cEnv { alphaEnv = f (alphaEnv cEnv) })


runAlphaConvert :: RawAst CompUnit -> AlphaConverted (UniqAst CompUnit)
runAlphaConvert (CompUnit pos es) = do
  let withUserIds = map inject es
  es' <- mapM convertBinding withUserIds
  es'' <- mapM convert es'
  return $ CompUnit pos es''
