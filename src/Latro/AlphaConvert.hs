{-# LANGUAGE Strict, FlexibleContexts, FlexibleInstances, NamedFieldPuns, TypeSynonymInstances #-}

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

import Control.Error.Util (hoistEither)
import Control.Monad (when)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.List (intercalate, nub)
import qualified Data.Map.Strict as Map
import Data.Maybe (isJust)
import Debug.Trace
import Latro.Common
import Latro.Compiler
import Latro.Errors
import Latro.Output
import Latro.Semant
import Latro.Semant.Display ()
import Prelude hiding (lookup)
import Text.Printf (printf)

reportErrorAt a = reportPosOnFail a "AlphaConvert"


getCurNs :: AlphaConverted NamespaceScope
getCurNs = getsAC curNamespace


pushNs :: NamespaceScope -> AlphaConverted NamespaceScope
pushNs ns = do
  modifyAC (\aEnv -> aEnv { curNamespace = ns })
  return ns


modifyCurNs :: (NamespaceScope -> NamespaceScope) -> AlphaConverted ()
modifyCurNs f = do
  ns <- getCurNs
  modifyAC (\aEnv -> aEnv { curNamespace = f ns })


getCurLocalScope :: AlphaConverted LocalScope
getCurLocalScope = do
  curNs <- getCurNs
  return $ head $ localScopeStack curNs


innerMostVarEnv :: AlphaConverted (RawIdEnv UniqId)
innerMostVarEnv = do
  curNs <- getCurNs
  case localScopeStack curNs of
    [] -> return $ varIdEnv curNs
    (sc : _) -> return $ localVarIdEnv sc


innerMostTypeEnv :: AlphaConverted (RawIdEnv UniqId)
innerMostTypeEnv = do
  curNs <- getCurNs
  case localScopeStack curNs of
    [] -> return $ typeIdEnv curNs
    (sc : _) -> return $ localTypeIdEnv sc


pushNewLocalScope :: AlphaConverted LocalScope
pushNewLocalScope = do
  ns <- getCurNs
  let _localScopeStack = localScopeStack ns
      (_varIdEnv, _typeIdEnv) = case _localScopeStack of
                                  [] -> (varIdEnv ns, typeIdEnv ns)
                                  (sc : _) -> (localVarIdEnv sc, localTypeIdEnv sc)
      scope = mtScope { localVarIdEnv  = _varIdEnv
                      , localTypeIdEnv = _typeIdEnv
                      }
  modifyCurNs (\ns -> ns { localScopeStack = scope : _localScopeStack })
  return scope


popLocalScope :: AlphaConverted ()
popLocalScope =
  modifyCurNs (\ns -> ns { localScopeStack = tail $ localScopeStack ns })


openNewNamespaceDef :: UniqAst QualifiedId -> AlphaConverted NamespaceScope
openNewNamespaceDef qid = do
    -- traceM ("pushNewTopLevelNamespace " ++ render qid)
    modifyAC (\aEnv -> aEnv { curNamespace = ns })
    return ns
  where ns = mkNs qid


openNamespaceDef :: UniqAst QualifiedId -> AlphaConverted NamespaceScope
openNamespaceDef qid = do
  maybeNs <- lookupNsGlobalSafe qid
  case maybeNs of
    Nothing -> openNewNamespaceDef qid
    Just ns -> pushNs $ ns { nsEnv = Map.empty }


-- Modules cannot be reopened.  This is only for second-pass alpha conversion
-- work, so in this case nothing must be inherited from the global scope
openNamespaceForConvert :: UniqAst QualifiedId -> AlphaConverted NamespaceScope
openNamespaceForConvert qid = do
  ns <- lookupNsGlobal qid `reportErrorAt` nodeData qid
  pushNs $ ns { nsEnv     = Map.empty
              , varIdEnv  = exportVarIdEnv ns
              , typeIdEnv = exportTypeIdEnv ns
              , ctorIdEnv = exportCtorIdEnv ns
              }


popNs :: NamespaceScope -> AlphaConverted NamespaceScope
popNs _ = do
  ns <- getCurNs
  -- traceM ("popNs " ++ render (path ns))
  modifyAC (\aEnv -> aEnv { globalNsEnv  = Map.insert (path ns) ns (globalNsEnv aEnv)
                          , curNamespace = topLevelNs
                          })
  return ns


inNewLocalScope :: AlphaConverted a -> AlphaConverted a
inNewLocalScope thunk = do
  pushNewLocalScope
  v <- thunk
  popLocalScope
  return v


modifyLocalScope :: (LocalScope -> LocalScope) -> AlphaConverted ()
modifyLocalScope fModify = do
  _curNs <- getCurNs
  let _localScopeStack          = localScopeStack _curNs
      (_curScope : outerScopes) = _localScopeStack
  modifyCurNs (\ns -> ns { localScopeStack = fModify _curScope : outerScopes })


ensureVarBoundInNsScope :: UniqId -> AlphaConverted UniqId
ensureVarBoundInNsScope uid@(UniqId _ rawId) = do
  modifyCurNs (\ns -> ns { varIdEnv = Map.insert rawId uid (varIdEnv ns) })
  return uid

ensureVarBoundInNsScope uid = return uid


exportVar :: UniqId -> UniqId -> AlphaConverted ()
exportVar (UserId rawId) uid = do
  modifyCurNs (\ns -> ns { exportVarIdEnv = Map.insert rawId uid (exportVarIdEnv ns)
                         , varIdEnv       = Map.insert rawId uid (varIdEnv ns)
                         })


exportTy :: UniqId -> UniqId -> AlphaConverted ()
exportTy (UserId rawId) uid = do
  modifyCurNs (\ns -> ns { exportTypeIdEnv = Map.insert rawId uid (exportTypeIdEnv ns)
                         , typeIdEnv       = Map.insert rawId uid (typeIdEnv ns)
                         })
exportTy UniqId{} _ = return ()


exportCtor :: UniqId -> UniqId -> AlphaConverted ()
exportCtor userId@(UserId rawId) uid = do
  modifyCurNs (\ns -> ns { exportCtorIdEnv = Map.insert rawId uid (exportCtorIdEnv ns)
                         , ctorIdEnv       = Map.insert rawId uid (ctorIdEnv ns)
                         })
  exportVar userId uid
exportCtor UniqId{} _ = return ()


freshVarId :: UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshVarId (UserId id) aEnv@AlphaEnv { counter } =
    (uniqId, aEnv { counter = counter' })
  where
    counter' = counter + 1
    uniqId = UniqId counter id

freshVarId  id aEnv = (id, aEnv)


freshTypeId :: UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshTypeId (UserId id) aEnv@AlphaEnv { counter } =
    (uniqId, aEnv { counter = counter' })
  where
    counter' = counter + 1
    uniqId = UniqId counter id

freshTypeId id aEnv = (id, aEnv)


freshM :: UniqId -> (UniqId -> AlphaEnv -> (UniqId, AlphaEnv)) -> AlphaConverted UniqId
freshM userId@(UserId id) fMake = do
  alphaEnv <- getAC
  let (uniqId, alphaEnv') = fMake userId alphaEnv
  putAC alphaEnv'
  return uniqId

freshM id _ = return id


freshIdIfNotBoundM :: UniqId -> RawIdEnv UniqId -> (UniqId -> AlphaConverted UniqId) -> AlphaConverted UniqId
freshIdIfNotBoundM uid@UniqId{} _ _ = return uid
freshIdIfNotBoundM userId env makeFreshId = do
  when (isBoundIn userId env) (throwError $ ErrIdAlreadyBound userId)
  makeFreshId userId


freshVarIdM :: UniqId -> AlphaConverted UniqId
freshVarIdM id = freshM id $ freshVarId


freshVarIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshVarIdIfNotBoundM id = do
  curNs <- getCurNs
  let env = case localScopeStack curNs of
              [] -> varIdEnv curNs
              (scope : _) -> localVarIdEnv scope
  freshIdIfNotBoundM id env freshVarIdM


freshTypeIdM :: UniqId -> AlphaConverted UniqId
freshTypeIdM id = freshM id freshTypeId


freshTypeIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshTypeIdIfNotBoundM id = do
  curNs <- getCurNs
  freshIdIfNotBoundM id (typeIdEnv curNs) freshTypeIdM


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
  return id'


isBoundIn :: UniqId -> RawIdEnv a -> Bool
isBoundIn uid@UniqId{} _ = True
isBoundIn userId@(UserId id) env =
  isJust $ Map.lookup id env


bindLocalVar :: UniqId -> AlphaConverted UniqId
bindLocalVar uid@(UniqId _ rawId) = do
  modifyLocalScope (\scope -> scope { localVarIdEnv = Map.insert rawId uid (localVarIdEnv scope) })
  return uid

bindLocalVar uid = freshVarIdM uid >>= bindLocalVar


bindLocalType :: UniqId -> AlphaConverted UniqId
bindLocalType uid@(UniqId _ rawId) = do
  modifyLocalScope (\scope -> scope { localTypeIdEnv = Map.insert rawId uid (localTypeIdEnv scope) })
  return uid

bindLocalType uid = freshTypeIdM uid >>= bindLocalType


bindNsImport :: UniqAst QualifiedId -> NamespaceScope -> AlphaConverted ()
bindNsImport qid importedNs = do
  modifyCurNs (\ns -> ns { nsEnv = Map.insert qid importedNs (nsEnv ns) })


lookupNsGlobalSafe :: UniqAst QualifiedId -> AlphaConverted (Maybe NamespaceScope)
lookupNsGlobalSafe qid = do
  _globalNsEnv <- getsAC globalNsEnv
  return $ Map.lookup qid _globalNsEnv


lookupNsGlobal :: UniqAst QualifiedId -> AlphaConverted NamespaceScope
lookupNsGlobal qid = do
  maybeNs <- lookupNsGlobalSafe qid
  hoistEither $ maybeToEither (ErrUnboundUniqModulePath qid) maybeNs


lookupNsSafe :: UniqAst QualifiedId -> AlphaConverted (Maybe NamespaceScope)
lookupNsSafe qid = do
  curNs <- getCurNs
  return $ Map.lookup qid $ nsEnv curNs


-- Lookup a namespace given a qualified id in the current
-- namespace's imported namespace environment
-- Note that we cannot refer to fully-qualified paths
-- that have not been explicitly imported in the current namespace
lookupNs :: UniqAst QualifiedId -> AlphaConverted NamespaceScope
lookupNs qid = do
  maybeNs <- lookupNsSafe qid
  hoistEither $ maybeToEither (ErrUnboundUniqModulePath qid) maybeNs


lookup :: UniqId -> (NamespaceScope -> RawIdEnv UniqId) -> AlphaConverted UniqId
lookup uid fGetTable = getCurNs >>= lookupIn uid fGetTable


lookupIn :: UniqId -> (a -> RawIdEnv UniqId) -> a -> AlphaConverted UniqId
lookupIn uid@UniqId{} _ _ = return uid
lookupIn uid@(UserId id) fGetTable scope = do
  let entry = Map.lookup id $ fGetTable scope
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier uid) entry


lookupInEnv :: UniqId -> RawIdEnv UniqId -> AlphaConverted UniqId
lookupInEnv uid@UniqId{} _ = return uid
lookupInEnv uid@(UserId id) env = do
  let entry = Map.lookup id env
  hoistEither $ maybeToEither (ErrUnboundUniqIdentifier uid) entry


class AlphaIndex a where
  lookupVar   :: a -> AlphaConverted UniqId
  lookupTy    :: a -> AlphaConverted UniqId
  lookupCtor  :: a -> AlphaConverted UniqId


instance AlphaIndex (UniqAst QualifiedId) where
  lookupVar (Id p id) = innerMostVarEnv >>= lookupInEnv id
  lookupVar qid@(Path p innerQid id) = do
    ns <- lookupNs innerQid `reportErrorAt` nodeData innerQid
    -- traceM ("lookupNs " ++ render innerQid)
    -- traceM ("ns path: " ++ render (path ns))
    -- traceM ("ns exports: " ++ show (exportVarIdEnv ns))
    -- traceM $ show id
    -- lookupIn id exportVarIdEnv ns
    catchError (lookupIn id exportVarIdEnv ns) (\_ -> throwError $ ErrUnboundQualIdentifier qid) `reportErrorAt` p


  lookupTy (Id p id) = innerMostTypeEnv >>= lookupInEnv id
  lookupTy (Path p qid id) = do
    ns <- lookupNs qid
    catchError (lookupIn id exportTypeIdEnv ns) (\_ -> throwError $ ErrUnboundQualIdentifier qid) `reportErrorAt` p


  lookupCtor (Id p id) = lookup id ctorIdEnv
  lookupCtor (Path p qid id) = do
    ns <- lookupNs qid
    catchError (lookupIn id exportCtorIdEnv ns) (\_ -> throwError $ ErrUnboundQualIdentifier qid) `reportErrorAt` p


instance AlphaIndex UniqId where
  lookupVar uid@UniqId{} = return uid
  lookupVar uid = innerMostVarEnv >>= lookupInEnv uid


  lookupTy uid@UniqId{} = return uid
  lookupTy uid = innerMostTypeEnv >>= lookupInEnv uid


  lookupCtor uid@UniqId{} = return uid
  lookupCtor userId = getCurNs >>= lookupIn userId ctorIdEnv


-- Any type that should update non-local environments
-- with new alpha id's should implement (anything that can
-- occur on a left-hand side)
class AlphaTopLevel a where
  convertTop :: a -> AlphaConverted a


-- Any type of element that requires references in its tree
-- to be rewritten to point to alpha id's
class AlphaLocal a where
  convertLoc :: a -> AlphaConverted a


instance AlphaLocal (UniqAst TyAnn) where
  convertLoc (TyAnn p id tyParamIds ty constrs) = do
    id' <- freshVarIdM id
    tyParamIds' <- mapM freshTypeIdM tyParamIds
    ty' <- convertLoc ty
    return $ TyAnn p id' tyParamIds' ty' constrs


instance AlphaLocal (UniqAst SynTy) where
  convertLoc (SynTyInt p) = return $ SynTyInt p
  convertLoc (SynTyBool p) = return $ SynTyBool p
  convertLoc (SynTyChar p) = return $ SynTyChar p
  convertLoc  (SynTyUnit p) = return $ SynTyUnit p
  convertLoc (SynTyPrim p id) = return $ SynTyPrim p id
  convertLoc (SynTyArrow p paramTys retTy) = do
    paramTys' <- mapM convertLoc paramTys `reportErrorAt` p
    retTy' <- convertLoc retTy
    return $ SynTyArrow p paramTys' retTy'

  convertLoc (SynTyStruct p fields) = do
    fields' <- mapM (\(id, ty) -> do { ty' <- convertLoc ty; return (id, ty') }) fields
    return $ SynTyStruct p fields'

  convertLoc (SynTyTuple p tys) = do
    tys' <- mapM convertLoc tys
    return $ SynTyTuple p tys'

  convertLoc (SynTyList p ty) = do
    ty' <- convertLoc ty
    return $ SynTyList p ty'

  convertLoc (SynTyRef p qid tyArgs) = do
    tyArgs' <- mapM convertLoc tyArgs
    tid' <- lookupTy qid `reportErrorAt` p
    return $ SynTyRef p (Id p tid') tyArgs'


-- We only apply convert to "top-level" patterns -- it is
-- not used on right-hand sides
instance AlphaTopLevel (UniqAst PatExp) where
  convertTop (PatExpWildcard p) = return $ PatExpWildcard p
  convertTop (PatExpNumLiteral p s) = return $ PatExpNumLiteral p s
  convertTop (PatExpBoolLiteral p b) = return $ PatExpBoolLiteral p b
  convertTop (PatExpStringLiteral p s) = return $ PatExpStringLiteral p s
  convertTop (PatExpCharLiteral p s) = return $ PatExpCharLiteral p s
  convertTop (PatExpTuple p es) = do
    es' <- mapM convertTop es
    return $ PatExpTuple p es'

  convertTop (PatExpId p id) = do
    maybeCtorId <- fmap Just (lookupCtor id) `catchError` (\_ -> return Nothing)
    case maybeCtorId of
      Just ctorId -> convertTop $ PatExpAdt p (Id p ctorId) []
      Nothing -> do
        id' <- freshVarIdIfNotBoundM id `reportErrorAt` p
        exportVar id id'
        return $ PatExpId p id'

  convertTop (PatExpAdt p qid es) = do
    uniqId <- lookupVar qid `catchError` (\err -> throwError (ErrUnboundConstructor qid) `reportErrorAt` nodeData qid)
    es' <- mapM convertTop es
    return $ PatExpAdt p (Id p uniqId) es'

  convertTop (PatExpList p es) = do
    es' <- mapM convertTop es
    return $ PatExpList p es'

  convertTop (PatExpListCons p eHd eTl) = do
    eHd' <- convertTop eHd
    eTl' <- convertTop eTl
    return $ PatExpListCons p eHd' eTl'


-- `convertLoc` on the other hand is only applied on a right-hand
-- side, e.g. in a function body
instance AlphaLocal (UniqAst PatExp) where
  convertLoc (PatExpWildcard p) = return $ PatExpWildcard p
  convertLoc (PatExpNumLiteral p s) = return $ PatExpNumLiteral p s
  convertLoc (PatExpBoolLiteral p bl) = return $ PatExpBoolLiteral p bl
  convertLoc (PatExpStringLiteral p s) = return $ PatExpStringLiteral p s
  convertLoc (PatExpCharLiteral p s) = return $ PatExpCharLiteral p s
  convertLoc (PatExpTuple p es) = do
    es' <- mapM convertLoc  es
    return $ PatExpTuple p es'

  convertLoc (PatExpId p id) = do
    maybeCtorId <- fmap Just (lookupCtor id) `catchError` (\_ -> return Nothing)
    case maybeCtorId of
      Just ctorId -> convertLoc $ PatExpAdt p (Id p ctorId) []
      Nothing -> do id' <- freshVarIdIfNotBoundM id `reportErrorAt` p
                    bindLocalVar id'
                    return $ PatExpId p id'

  convertLoc (PatExpAdt p qid es) = do
    uniqId <- lookupVar qid `catchError` (\err -> throwError (ErrUnboundConstructor qid) `reportErrorAt` nodeData qid)
    es' <- mapM convertLoc  es
    return $ PatExpAdt p (Id p uniqId) es'

  convertLoc (PatExpList p es) = do
    es' <- mapM convertLoc es
    return $ PatExpList p es'

  convertLoc (PatExpListCons p eHd eTl) = do
    eHd' <- convertLoc eHd
    eTl' <- convertLoc eTl
    return $ PatExpListCons p eHd' eTl'


instance AlphaLocal (UniqAst CaseClause) where
  convertLoc (CaseClause p patE e) = do
    pushNewLocalScope
    patE' <- convertLoc patE
    e' <- convertLoc e
    popLocalScope
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
  a' <- convertLoc a
  b' <- convertLoc b
  return $ c p a' b'


instance AlphaTopLevel (Int, UniqAst AdtAlternative) where
  convertTop (index, AdtAlternative p id _ tys) = do
    id' <- freshCtorIdM id `reportErrorAt` p
    exportCtor id id'
    return (index, AdtAlternative p id' index tys)


-- Populate the symbol table with alpha id's, but do
-- not try to rewrite any bound occurrences of either variable,
-- type, or type param references
instance AlphaTopLevel (UniqAst Exp) where
  convertTop (ExpTypeDec p (TypeDecAdt pInner id tyParamIds alts)) = do
    id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
    exportTy id id'
    (_, alts') <- liftM unzip $ mapMi (\i alt -> convertTop (i, alt)) alts
    return $ ExpTypeDec p $ TypeDecAdt pInner id' tyParamIds alts'

  convertTop (ExpTypeDec p (TypeDecTy pInner id tyParamIds (SynTyStruct stp fieldDefs))) = do
      id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
      exportTy id id'
      return $ ExpTypeDec p $ TypeDecTy pInner id' tyParamIds $ SynTyStruct stp fieldDefs
    where (fieldIds, fieldTys) = unzip fieldDefs

  convertTop (ExpTypeDec p tyDec) = do
    id' <- freshTypeIdIfNotBoundM id `reportErrorAt` p
    exportTy id id'
    traceM ("convertTop " ++ show (ExpTypeDec p (renameTypeDec tyDec id')))
    traceM ("  id: " ++ showFullUniqId id')
    return $ ExpTypeDec p $ renameTypeDec tyDec id'
    where
      (Just id) = getTypeDecId tyDec

  convertTop (ExpBegin p es) = do
    es' <- mapM convertTop es
    return $ ExpBegin p es'

  convertTop (ExpModule p qid bodyEs) = do
    traceM ("convertTop " ++ render qid)
    case implicitTyDecs of
      [] -> do
        ns <- openNamespaceDef qid
        bodyEs' <- mapM convertTop otherEs
        ns' <- popNs ns `reportErrorAt` p
        return $ ExpModule p qid bodyEs'
      [tyDec] ->
        convertTop $ ExpTypeModule p qid tyDec otherEs
      _ -> throwError (ErrMultipleDataDecs qid) `reportErrorAt` p
    where
      (implicitTyDecs, otherEs) = stripImplicitTypeDecs bodyEs

  convertTop (ExpTypeModule p qid@(Id _ id) _ _) =
    throwError (ErrIllegalTopLevelTypeModule qid) `reportErrorAt` p

  convertTop (ExpTypeModule p qid tyDec bodyEs) = do
    curPath <- getCurNs >>= return . path
    typeId <- freshTypeIdM (UserId "@__data")
    -- traceM $ show qid
    let tyDecExp = tyDec `renameTo` typeId
        tyParamIds = getTypeDecParams tyDec
        expModule = ExpModule p qid (bodyEs ++ [tyDecExp])
        typeParamIdRefs = map (\id -> SynTyRef p (Id p id) []) tyParamIds
        dataTypePath = Path p qid typeId
        aliasTyDec = ExpTypeDec p (TypeDecTy p (stripPath qid) tyParamIds (SynTyRef p dataTypePath typeParamIdRefs))

    aliasModule' <- convertTop $ ExpModule p (basePath qid) [ExpImport p qid, aliasTyDec]
    expModule' <- convertTop expModule
    return $ ExpBegin p [aliasModule', expModule']

  convertTop (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
    id' <- freshVarIdIfNotBoundM id
    exportVar id id'
    return $ ExpFunDef $ FunDefFun p id' argPatEs bodyE

  convertTop (ExpFunDefClauses p id funDefs) = do
    id' <- freshVarIdM id
    exportVar id id'
    funDef <- desugarFunDefs id' funDefs
    return $ ExpFunDef funDef

  convertTop (ExpTopLevelAssign p patExp e) = do
    patExp' <- convertTop patExp
    return $ ExpTopLevelAssign p patExp' e

  convertTop (ExpAssign p patExp e) = do
    patExp' <- convertTop patExp
    return $ ExpAssign p patExp' e

  convertTop (ExpTopLevelTyAnn (TyAnn _ id _ _ _)) =
    throwError $ ErrInterpFailure $ "ExpTopLevelTyAnn " ++ show id ++ " not removed before alpha-conversion!"

  convertTop (ExpTyAnn (TyAnn _ id _ _ _)) =
    throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

  convertTop (ExpWithAnn (TyAnn p aid tyParamIds synTy constrs) e) =
    case e of
      ExpFunDefClauses{} ->
        do e'@(ExpFunDef (FunDefFun fp fid argPatEs bodyE)) <- convertTop e
           let tyAnn = TyAnn p fid tyParamIds synTy constrs
           return $ ExpWithAnn tyAnn e'
      ExpAssign ep patExp@(PatExpId pp pid) e -> do
        (PatExpId _ pid') <- convertLoc patExp
        let tyAnn = TyAnn p pid' tyParamIds synTy constrs
        return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp pid') e
      ExpTopLevelAssign ep patExp@(PatExpId pp pid) e -> do
        (PatExpId _ pid') <- convertTop patExp
        let tyAnn = TyAnn p pid' tyParamIds synTy constrs
        exportVar pid pid'
        return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp pid') e
      ExpFunDef{} ->
        do e'@(ExpFunDef (FunDefFun fp fid argPatEs bodyE)) <- convertTop e
           let tyAnn = TyAnn p fid tyParamIds synTy constrs
           return $ ExpWithAnn tyAnn e'
      _ ->
        throwError $ ErrInterpFailure $ "in convert ExpWithAnn: " ++ show e

  convertTop e = return e


instance AlphaLocal (Int, UniqAst AdtAlternative) where
  convertLoc (index, AdtAlternative p id _ tys) = do
    tys' <- mapM convertLoc tys
    return (index, AdtAlternative p id index tys')


instance AlphaLocal (UniqAst Exp) where
  convertLoc (ExpCons p a b) = convertBin ExpCons p a b
  convertLoc (ExpInParens p e) = do
    e' <- convertLoc e
    return $ ExpInParens p e'

  convertLoc (ExpCustomInfix p lhe id rhe) = do
    lhe' <- convertLoc lhe
    rhe' <- convertLoc rhe
    id' <- lookupVar id `reportErrorAt` p
    return $ ExpCustomInfix p lhe' id' rhe'

  convertLoc (ExpMemberAccess p e@(ExpQualifiedRef qp qid) id) = do
    qid' <- lookupVar qid
    return $ ExpMemberAccess p (ExpRef qp qid') id

  convertLoc (ExpMemberAccess p e id) = do
    e' <- convertLoc e
    return $ ExpMemberAccess p e' id

  convertLoc (ExpApp p ratorE randEs) = do
    ratorE' <- convertLoc ratorE
    randEs' <- mapM convertLoc randEs
    return $ ExpApp p ratorE' randEs'

  convertLoc (ExpPrim p ratorId) = return $ ExpPrim p ratorId

  convertLoc (ExpImport p qid) = do
    traceM ("convertLoc ExpImport " ++ render qid)
    curNs <- getCurNs
    ns <- lookupNsGlobal qid `reportErrorAt` p
    let curVarIdEnv         = varIdEnv curNs
        curTypeIdEnv        = typeIdEnv curNs
        curCtorIdEnv        = ctorIdEnv curNs
        modVarIdEnv         = exportVarIdEnv ns
        modTypeIdEnv        = exportTypeIdEnv ns
        modCtorIdEnv        = exportCtorIdEnv ns
        overlappingVarIds   = Map.keys $ Map.intersection curVarIdEnv modVarIdEnv
        overlappingTypeIds  = Map.keys $ Map.intersection curTypeIdEnv modTypeIdEnv
        overlappingCtorIds  = Map.keys $ Map.intersection curCtorIdEnv modCtorIdEnv
    unless (null overlappingVarIds) $ throwError (ErrOverlappingVarImport qid overlappingVarIds) `reportErrorAt` p
    unless (null overlappingTypeIds) $ throwError (ErrOverlappingTyImport qid overlappingTypeIds) `reportErrorAt` p
    unless (null overlappingCtorIds) $ throwError (ErrOverlappingCtorImport qid overlappingCtorIds) `reportErrorAt` p
    modifyCurNs (\curNs -> curNs { varIdEnv  = Map.union curVarIdEnv modVarIdEnv
                                 , typeIdEnv = Map.union curTypeIdEnv modTypeIdEnv
                                 , ctorIdEnv = Map.union curCtorIdEnv modCtorIdEnv
                                 , nsEnv     = Map.insert qid ns (nsEnv curNs)
                                 })
    return $ ExpUnit p

  -- NNSE += { id -> GNSE[qid] }
  convertLoc (ExpImportAs p qid id) = do
    ns <- lookupNsGlobal qid `reportErrorAt` p
    -- traceM $ show $ exportVarIdEnv ns
    bindNsImport (Id p id) ns
    return $ ExpUnit p

  convertLoc (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
    ensureVarBoundInNsScope id
    pushNewLocalScope
    argPatEs' <- mapM convertLoc argPatEs
    bodyE' <- convertLoc bodyE
    popLocalScope
    return $ ExpFunDef $ FunDefFun p id argPatEs' bodyE'

  convertLoc (ExpTopLevelAssign p patExp e) = do
    e' <- convertLoc e
    return $ ExpAssign p patExp e'

  -- The pat exp must be converted after the right-hand side,
  -- so bindings occurring in the former do not show
  -- up in the latter
  convertLoc (ExpAssign p patExp e) = do
    e' <- convertLoc e
    patExp' <- convertLoc patExp
    return $ ExpAssign p patExp' e'

  convertLoc (ExpTyAnn (TyAnn _ id _ _ _)) =
    throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

  convertLoc (ExpWithAnn (TyAnn p aid tyParamIds synTy constrs) e) = do
    pushNewLocalScope
    tyParamIds' <- mapM bindLocalType tyParamIds
    synTy' <- convertLoc synTy
    let tyAnn = TyAnn p aid tyParamIds' synTy' constrs
    case e of
      ExpFunDef (FunDefFun fp fid argPatEs bodyE) ->
        do pushNewLocalScope
           argPatEs' <- mapM convertLoc argPatEs
           bodyE' <- convertLoc bodyE
           popLocalScope -- body frame
           popLocalScope -- enclosing frame for type param id's
           let e' = ExpFunDef (FunDefFun fp aid argPatEs' bodyE')
           return $ ExpWithAnn tyAnn e'
      ExpAssign ep pat@(PatExpId pp pid) e ->
        do popLocalScope -- enclosing frame for type param id's
           e' <- convertLoc e
           convertLoc pat
           return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp aid) e'
      ExpTopLevelAssign ep (PatExpId pp pid) e ->
        do e' <- convertLoc e
           popLocalScope -- enclosing frame for type param id's
           return $ ExpWithAnn tyAnn $ ExpTopLevelAssign ep (PatExpId pp aid) e'
      _ -> throwError $ ErrInterpFailure $ "in convertLoc ExpWithAnn: " ++ show e

  convertLoc (ExpStruct p qid fields) = do
    tid' <- lookupTy qid `reportErrorAt` nodeData qid
    fields' <- mapM (\(FieldInit fieldId fieldE) ->
                        do fieldE' <- convertLoc fieldE
                           return $ FieldInit fieldId fieldE')
                    fields
    return $ ExpStruct p (Id (nodeData qid) tid') fields'

  convertLoc (ExpIfElse p condE thenE elseE) = do
    condE' <- convertLoc condE
    thenE' <- inNewLocalScope $ convertLoc thenE
    elseE' <- inNewLocalScope $ convertLoc elseE
    return $ ExpIfElse p condE' thenE' elseE'

  convertLoc (ExpSwitch p e clauses) = do
    e' <- convertLoc e
    clauses' <- mapM convertLoc clauses
    return $ ExpSwitch p e' clauses'

  convertLoc e@ExpCond{} = convertLoc e'
    where e' = desugarCond e

  convertLoc (ExpTuple p es) = do
    es' <- mapM convertLoc es
    return $ ExpTuple p es'

  convertLoc (ExpList p es) = do
    es' <- mapM convertLoc es
    return $ ExpList p es'

  convertLoc (ExpFun p argPatEs bodyE) = do
    pushNewLocalScope
    argPatEs' <- mapM convertLoc argPatEs
    bodyE' <- convertLoc bodyE
    popLocalScope
    return $ ExpFun p argPatEs' bodyE'

  convertLoc (ExpPrecAssign p id level) = do
    id' <- lookupVar id `reportErrorAt` p
    return $ ExpPrecAssign p id' level

  convertLoc (ExpNum p s) = return $ ExpNum p s
  convertLoc (ExpBool p b) = return $ ExpBool p b
  convertLoc (ExpString p s) = return $ ExpString p s
  convertLoc (ExpChar p s) = return $ ExpChar p s
  convertLoc (ExpUnit p) = return $ ExpUnit p
  convertLoc (ExpFail p msg) = return $ ExpFail p msg

  convertLoc (ExpBegin p es) = do
    es' <- mapM convertLoc es
    return $ ExpBegin p es'

  convertLoc (ExpModule p qid bodyEs) = do
    traceM ("convertLoc " ++ render qid)
    ns <- openNamespaceForConvert qid
    -- traceM ("convertLoc " ++ render qid)
    -- traceM ("  varIdEnv: " ++ (intercalate ", " (map render (Map.keys (varIdEnv ns)))))
    bodyEs' <- mapM convertLoc bodyEs
    popNs ns `reportErrorAt` p
    return $ ExpBegin p bodyEs'

  convertLoc (ExpQualifiedRef p qid) = do
    id' <- lookupVar qid `reportErrorAt` p
    return $ ExpRef p id'

  convertLoc (ExpRef p id) = do
    id' <- lookupVar id `reportErrorAt` p
    return $ ExpRef p id'

  convertLoc (ExpTypeDec p (TypeDecTy tp tid tyParamIds synTy)) = do
    traceM ("At " ++ show p ++ ":")
    traceM ("  convertLoc " ++ showFullUniqId tid)
    tid' <- lookupTy tid
    pushNewLocalScope
    tyParamIds' <- mapM bindLocalType tyParamIds
    synTy' <- convertLoc synTy
    popLocalScope
    return $ ExpTypeDec p $ TypeDecTy tp tid' tyParamIds' synTy'

  convertLoc (ExpTypeDec p (TypeDecAdt tp tid tyParamIds alts)) = do
    tid' <- lookupTy tid
    pushNewLocalScope
    tyParamIds' <- mapM bindLocalType tyParamIds
    (_, alts') <- liftM unzip $ mapMi (\i alt -> convertLoc (i, alt)) alts
    popLocalScope
    return $ ExpTypeDec p $ TypeDecAdt tp tid' tyParamIds' alts'

  convertLoc (ExpTypeDec p (TypeDecEmpty tp tid tyParamIds)) = do
    tid'  <- lookupTy tid
    pushNewLocalScope
    tyParamIds' <- mapM bindLocalType tyParamIds
    popLocalScope
    return $ ExpTypeDec p $ TypeDecEmpty tp tid' tyParamIds'

  convertLoc e = throwError $ ErrInterpFailure $ printf "convertLoc failed for: %s" $ show e


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
      SynTyPrim p id -> SynTyPrim p $ UserId id
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
      ExpImportAs p qid id -> ExpImportAs p (inject qid) $ UserId id
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
      ExpModule p qid bodyEs ->
        ExpModule p (inject qid) (map inject bodyEs)
      ExpTypeModule p qid tyDec bodyEs ->
        ExpTypeModule p (inject qid) (inject tyDec) (map inject bodyEs)
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
  es' <- mapM convertTop withUserIds
  es'' <- mapM convertLoc es'
  return $ CompUnit pos es''
