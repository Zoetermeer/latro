{-# LANGUAGE FlexibleContexts, NamedFieldPuns, TypeSynonymInstances #-}

{-|
Module      : AlphaConvert
Description : Rewrite the syntax tree such that all bound identifiers are unique

The rewriting guarantees that we cannot have shadowing or substitution problems
downstream.  As part of this transformation, we replace all qualified (raw) identifiers
with their unqualified, alpha-converted equivalents and factor out module definitions
altogether.
-}
module Latro.AlphaConvert where

import Control.Applicative
import Control.Monad.Except
import Control.Monad.State
import Data.List (nub)
import qualified Data.Map as Map (insert, lookup, union)
import Latro.Common
import Latro.Compiler
import Latro.Errors
import Latro.Semant
import Prelude hiding (lookup)
import Text.Printf (printf)


reportErrorAt a = reportPosOnFail a "AlphaConvert"


isFirstPass :: AlphaConverted Bool
isFirstPass = getsAC pass >>= \p -> return $ p == 0


pushNewFrame :: AlphaConverted ()
pushNewFrame = do
  index <- nextIdIndexM
  pushFrame $ mtFrame index


pushFrame :: Frame -> AlphaConverted ()
pushFrame frame = do
  index <- nextIdIndexM
  modifyAC (\aEnv -> aEnv { stack = frame : stack aEnv })


pushNewOrExistingFrame :: UniqId -> AlphaConverted UniqId
pushNewOrExistingFrame id = do
  curFrame <- getsAC $ head . stack
  entry <- lookupEntryIn id [curFrame] varIdEnv
  case entry of
    FrameEntry uid frame ->
      do modifyAC (\aEnv -> aEnv { stack = frame : stack aEnv })
         return uid
    UniqIdEntry _ ->
      throwError $ ErrIdAlreadyBound id
    _ ->
      do pushNewFrame
         return id


popFrame :: AlphaConverted Frame
popFrame = do
  (frame : frames) <- getsAC stack
  modifyAC (\aEnv -> aEnv { stack = frames })
  return frame


inNewFrame :: AlphaConverted a -> AlphaConverted a
inNewFrame thunk = do
  pushNewFrame
  v <- thunk
  popFrame
  return v


modifyFrame :: (Frame -> Frame) -> AlphaConverted ()
modifyFrame fModify = do
  (frame : frames) <- getsAC stack
  modifyAC (\aEnv -> aEnv { stack = fModify frame : frames })


bindInCurrentFrame :: UniqId -> AlphaEntry -> AlphaConverted ()
bindInCurrentFrame (UserId rawId) entry = do
  (frame : frames) <- getsAC stack
  let updatedVars = Map.insert rawId entry $ varIdEnv frame
  modifyAC (\aEnv -> aEnv { stack = (frame { varIdEnv = updatedVars }) : frames })

bindInCurrentFrame _ _ = return ()


freshVarId :: Bool -> UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshVarId bindInFrame (UserId id) aEnv@AlphaEnv { counter, stack } =
    (uniqId, aEnv { counter = counter', stack = frame' : frames })
  where
    counter' = counter + 1
    uniqId = UniqId counter id
    (frame : frames) = stack
    frame' = if bindInFrame
             then frame { varIdEnv = Map.insert id (UniqIdEntry uniqId) $ varIdEnv frame }
             else frame

freshVarId _ id aEnv = (id, aEnv)


freshTypeId :: UniqId -> AlphaEnv -> (UniqId, AlphaEnv)
freshTypeId (UserId id) aEnv@AlphaEnv { counter, stack } =
    (uniqId, aEnv { counter = counter', stack = frame' : frames })
  where
    counter' = counter + 1
    uniqId = UniqId counter id
    (frame : frames) = stack
    frame' = frame { typeIdEnv = Map.insert id (UniqIdEntry uniqId) $ typeIdEnv frame }

freshTypeId id aEnv = (id, aEnv)


freshM :: UniqId -> (UniqId -> AlphaEnv -> (UniqId, AlphaEnv)) -> AlphaConverted UniqId
freshM userId@(UserId id) fMake = do
  alphaEnv <- getAC
  let (uniqId, alphaEnv') = fMake userId alphaEnv
  putAC alphaEnv'
  return uniqId

freshM id _ = return id


freshVarIdM :: UniqId -> AlphaConverted UniqId
freshVarIdM id = freshM id $ freshVarId True


freshVarIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshVarIdIfNotBoundM uid@UniqId{} = return uid
freshVarIdIfNotBoundM userId = do
  curFrame <- getsAC $ head . stack
  if isBoundIn userId [curFrame] varIdEnv
    then throwError $ ErrIdAlreadyBound userId
    else freshVarIdM userId


freshTypeIdM :: UniqId -> AlphaConverted UniqId
freshTypeIdM id = freshM id freshTypeId


nextIdIndex :: AlphaEnv -> Int
nextIdIndex AlphaEnv{ counter } = counter


nextIdIndexM :: AlphaConverted Int
nextIdIndexM = do
  aEnv <- getAC
  let next = nextIdIndex aEnv
  putAC $ aEnv { counter = next }
  return next


isBoundIn :: UniqId -> [Frame] -> (Frame -> RawIdEnv AlphaEntry) -> Bool
isBoundIn uid@UniqId{} _ _ = False
isBoundIn id [] _ = False
isBoundIn userId@(UserId id) (frame : frames) getEnv =
  case Map.lookup id (getEnv frame) of
    Just anEntry -> True
    _ -> isBoundIn userId frames getEnv


lookupEntryIn :: UniqId -> [Frame] -> (Frame -> RawIdEnv AlphaEntry) -> AlphaConverted AlphaEntry
lookupEntryIn uid@UniqId{} _ _ = return $ UniqIdEntry uid
lookupEntryIn (UserId id) [] _ = do
  firstPass <- isFirstPass
  if firstPass
    then return $ UnknownEntry $ UserId id
    else throwError $ ErrUnboundRawIdentifier id

lookupEntryIn userId@(UserId id) (frame : frames) getEnv =
  case Map.lookup id (getEnv frame) of
    Just anEntry -> return anEntry
    _ -> lookupEntryIn userId frames getEnv


lookupVarIn :: UniqId -> [Frame] -> AlphaConverted UniqId
lookupVarIn uid@UniqId{} _ = return uid
lookupVarIn userId@(UserId rawId) frames = do
  entry <- lookupEntryIn userId frames varIdEnv
  case entry of
    UniqIdEntry uid -> return uid
    FrameEntry uid _ -> return uid
    UnknownEntry id -> throwError $ ErrUnboundRawIdentifier rawId


lookupEntry :: UniqId -> (Frame -> RawIdEnv AlphaEntry) -> AlphaConverted AlphaEntry
lookupEntry id fGetEnv = do
  aEnv <- getAC
  lookupEntryIn id (stack aEnv) fGetEnv


lookupVarEntry :: UniqId -> AlphaConverted AlphaEntry
lookupVarEntry id = lookupEntry id varIdEnv


lookupTypeEntry :: UniqId -> AlphaConverted AlphaEntry
lookupTypeEntry id = lookupEntry id typeIdEnv


lookupVarId :: UniqId -> AlphaConverted UniqId
lookupVarId uid@UniqId{} = return uid
lookupVarId userId = do
  entry <- lookupVarEntry userId
  return $ case entry of
    UniqIdEntry uid -> uid
    FrameEntry uid _ -> uid
    UnknownEntry id -> id


lookupTypeId :: UniqId -> AlphaConverted UniqId
lookupTypeId uid@UniqId{} = return uid
lookupTypeId userId = do
  (UniqIdEntry uid) <- lookupTypeEntry userId
  return uid


lookupVarQualId :: UniqAst QualifiedId -> AlphaConverted AlphaEntry
lookupVarQualId (Id p id) = lookupVarEntry id
lookupVarQualId (Path p qid id) = do
  firstPass <- isFirstPass
  entry <- lookupVarQualId qid
  case entry of
    entry@UnknownEntry{} ->
      if firstPass
        then return entry
        else throwError (ErrInvalidUniqModulePath qid) `reportErrorAt` p
    entry@UniqIdEntry{} ->
      if firstPass
        then return entry
        else throwError (ErrInvalidUniqModulePath qid) `reportErrorAt` p
    FrameEntry _ frame ->
      lookupEntryIn id [frame] varIdEnv


lookupTypeQualId :: UniqAst QualifiedId -> AlphaConverted AlphaEntry
lookupTypeQualId (Id p id) = lookupTypeEntry id
lookupTypeQualId (Path p qid id) = do
  firstPass <- isFirstPass
  table <- lookupVarQualId qid
  case table of
    entry@UnknownEntry{} ->
      if firstPass
        then return entry
        else throwError (ErrInvalidUniqModulePath qid) `reportErrorAt` p
    UniqIdEntry _ ->
      throwError (ErrInvalidUniqModulePath qid) `reportErrorAt` p
    FrameEntry _ frame ->
      lookupEntryIn id [frame] typeIdEnv


-- |Find the environment for the module at the base path of the given
-- qualified ID.  If it's not a path, just return the current
-- frame.
baseStackFrame :: UniqAst QualifiedId -> AlphaConverted [Frame]
baseStackFrame Id{} = getsAC stack
baseStackFrame (Path _ qid _) = do
  (FrameEntry _ frame) <- lookupVarQualId qid
  return [frame]


convertVarQualId :: UniqAst QualifiedId -> AlphaConverted (UniqAst QualifiedId)
convertVarQualId qid = do
    varEntry <- lookupVarQualId qid
    case varEntry of
      UnknownEntry _ -> return qid
      UniqIdEntry uid -> return $ Id p uid
  where p = nodeData qid


convertTypeQualId :: UniqAst QualifiedId -> AlphaConverted (UniqAst QualifiedId)
convertTypeQualId qid = do
    entry <- lookupTypeQualId qid
    case entry of
      UniqIdEntry uid -> return $ Id p uid
      UnknownEntry _ -> return qid
  where p = nodeData qid


convertTyAnn :: UniqAst TyAnn -> AlphaConverted (UniqAst TyAnn)
convertTyAnn (TyAnn p id tyParamIds ty constrs) = do
  id' <- freshVarIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  ty' <- convertTy ty
  constrs' <- mapM convertConstraint constrs
  return $ TyAnn p id' tyParamIds' ty' constrs'


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
  qid' <- convertTypeQualId qid `reportErrorAt` p
  return $ SynTyRef p qid' tyArgs'


convertConstraint :: UniqAst Constraint -> AlphaConverted (UniqAst Constraint)
convertConstraint (Constraint p tyId protoId) = do
  tyId' <- lookupTypeId tyId
  protoId' <- lookupTypeId protoId
  return $ Constraint p tyId' protoId'


convertAdtAlternative :: Int -> UniqAst AdtAlternative -> AlphaConverted (UniqAst AdtAlternative)
convertAdtAlternative index (AdtAlternative p id _ tys) = do
  id' <- freshVarIdM id
  tys' <- mapM convertTy tys
  return $ AdtAlternative p id' index tys'


convertPatExp :: UniqAst PatExp -> AlphaConverted (UniqAst PatExp)
convertPatExp (PatExpWildcard p) = return $ PatExpWildcard p
convertPatExp (PatExpNumLiteral p s) = return $ PatExpNumLiteral p s
convertPatExp (PatExpBoolLiteral p b) = return $ PatExpBoolLiteral p b
convertPatExp (PatExpStringLiteral p s) = return $ PatExpStringLiteral p s
convertPatExp (PatExpCharLiteral p s) = return $ PatExpCharLiteral p s
convertPatExp (PatExpTuple p es) = do
  es' <- mapM convertPatExp es
  return $ PatExpTuple p es'

convertPatExp (PatExpId p id) = do
  id' <- freshVarIdIfNotBoundM id `reportErrorAt` p
  return $ PatExpId p id'

convertPatExp (PatExpAdt p qid es) = do
  qid' <- convertVarQualId qid `reportErrorAt` nodeData qid
  es' <- mapM convertPatExp es
  return $ PatExpAdt p qid' es'

convertPatExp (PatExpList p es) = do
  es' <- mapM convertPatExp es
  return $ PatExpList p es'

convertPatExp (PatExpListCons p eHd eTl) = do
  eHd' <- convertPatExp eHd
  eTl' <- convertPatExp eTl
  return $ PatExpListCons p eHd' eTl'


convertFunDef :: UniqAst FunDef -> AlphaConverted (UniqAst FunDef)
convertFunDef (FunDefFun p id argPatEs bodyE) = do
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- lookupVarId id
  bodyE' <- convert bodyE
  return $ FunDefFun p id' argPatEs' bodyE'


convertCaseClause :: UniqAst CaseClause -> AlphaConverted (UniqAst CaseClause)
convertCaseClause (CaseClause p patE e) = do
  pushNewFrame
  patE' <- convertPatExp patE
  e' <- convert e
  popFrame
  return $ CaseClause p patE' e'


funDefToCaseClause :: UniqAst FunDef -> AlphaConverted (UniqAst CaseClause)
funDefToCaseClause (FunDefFun p _ argPatEs bodyE) = do
  let tupPat = PatExpTuple p argPatEs
  pushNewFrame
  tupPat' <- convertPatExp tupPat
  bodyE' <- convert bodyE
  popFrame
  return $ CaseClause p tupPat' bodyE'


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


desugarFunDefs :: UniqId -> [UniqAst FunDef] -> AlphaConverted (UniqAst FunDef, [UniqId])
desugarFunDefs fid funDefs =
  let arities = nub $ map funDefArity funDefs
      (FunDefFun startP _ argPatEs bodyE) = head funDefs
  in
    case arities of
      [len] -> do
        paramIds <- replicateM len ((\_ -> freshVarIdM $ UserId "arg") ())
        cases <- mapM funDefToCaseClause funDefs
        let paramRefs = map (ExpRef startP) paramIds
            paramPats = map (PatExpId startP) paramIds
            argsTup = ExpTuple startP paramRefs
        return (FunDefFun startP fid paramPats (ExpSwitch startP argsTup cases), paramIds)
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
stripImplicitTypeDecs ((ExpTypeDec _ tyDec@(TypeDecImplicit _ innerTyDec)) : es) =
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


convert :: UniqAst Exp -> AlphaConverted (UniqAst Exp)
convert (ExpCons p a b) = convertBin ExpCons p a b
convert (ExpInParens p e) = do
  e' <- convert e
  return $ ExpInParens p e'

convert (ExpCustomInfix p lhe id rhe) = do
  lhe' <- convert lhe
  rhe' <- convert rhe
  id' <- lookupVarId id `reportErrorAt` p
  return $ ExpCustomInfix p lhe' id' rhe'

convert (ExpMemberAccess p e@(ExpQualifiedRef _ qid) id) = do
  entry <- lookupVarQualId qid
  case entry of
    UniqIdEntry{} -> do
      e' <- convert e
      return $ ExpMemberAccess p e' id
    _ -> throwError (ErrUnboundQualIdentifier qid) `reportErrorAt` p

convert (ExpMemberAccess p e id) = do
  e' <- convert e
  return $ ExpMemberAccess p e' id

convert (ExpApp p ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp p ratorE' randEs'

convert (ExpPrim p ratorId) = return $ ExpPrim p ratorId

convert (ExpImport p qid) = do
  firstPass <- isFirstPass
  if firstPass
    then return $ ExpImport p qid
    else do
      (FrameEntry moduleId Frame{ varIdEnv = modVarIdEnv, typeIdEnv = modTypeIdEnv }) <- lookupVarQualId qid
      modifyFrame (\(curFrame@Frame{ varIdEnv, typeIdEnv }) ->
                      curFrame { varIdEnv = Map.union varIdEnv modVarIdEnv
                               , typeIdEnv = Map.union typeIdEnv modTypeIdEnv })
      return $ ExpUnit p

convert (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
  id' <- freshVarIdM id
  pushNewFrame
  argPatEs' <- mapM convertPatExp argPatEs
  bodyE' <- convert bodyE
  popFrame
  return $ ExpFunDef $ FunDefFun p id' argPatEs' bodyE'

convert (ExpFunDefClauses p id funDefs) = do
  id' <- freshVarIdM id
  pushNewFrame
  funDef <- fst <$> desugarFunDefs id' funDefs
  popFrame
  return $ ExpFunDef funDef

convert (ExpModule p id bodyEs) =
  case implicitTyDecs of
    [] -> do
      id' <- pushNewOrExistingFrame id `reportErrorAt` p
      aEnv <- getAC
      bodyEs' <- mapM convert nonImplicitTyDecEs
      moduleFrame <- popFrame
      bindInCurrentFrame id' $ FrameEntry id' moduleFrame
      firstPass <- isFirstPass
      if firstPass
        then return $ ExpModule p id bodyEs'
        else return $ ExpBegin p bodyEs'
    [tyDec] ->
      convert $ ExpTypeModule p id tyDec nonImplicitTyDecEs
    _ -> throwError (ErrMultipleDataDecs id) `reportErrorAt` p
  where
    (implicitTyDecs, nonImplicitTyDecEs) = stripImplicitTypeDecs bodyEs

convert (ExpTypeModule p id tyDec bodyEs) = do
    typeId <- freshTypeIdM (UserId "data")
    let tyDecExp = tyDec `renameTo` typeId
        tyParamIds = getTypeDecParams tyDec
        typeModule = ExpModule p id (tyDecExp : bodyEs)
        typeParamIdRefs = map (\id -> SynTyRef p (Id p id) []) tyParamIds
        aliasTyDec = ExpTypeDec p (TypeDecTy p id tyParamIds (SynTyRef p (Path p (Id p id) typeId) typeParamIdRefs))

    expModule <- convert typeModule
    aliasTyDec' <- convert aliasTyDec
    return $ ExpBegin p [aliasTyDec', expModule]

convert (ExpAssign p patExp e) = do
  e' <- convert e
  patExp' <- convertPatExp patExp
  return $ ExpAssign p patExp' e'

convert (ExpTypeDec p (TypeDecTy pInner id tyParamIds (SynTyStruct stp fields))) = do
  id' <- freshTypeIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  fields' <- mapM (\(id, ty) -> do id' <- freshVarIdM id
                                   ty' <- convertTy ty
                                   return (id', ty'))
                  fields
  return $ ExpTypeDec p $ TypeDecTy pInner id' tyParamIds' $ SynTyStruct p fields'

convert (ExpTypeDec p (TypeDecTy pInner id tyParamIds ty)) = do
  id' <- freshTypeIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  ty' <- convertTy ty
  return $ ExpTypeDec p $ TypeDecTy pInner id' tyParamIds' ty'

convert (ExpTypeDec p (TypeDecAdt pInner id tyParamIds alts)) = do
  id' <- freshTypeIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  alts' <- mapMi convertAdtAlternative alts
  return $ ExpTypeDec p $ TypeDecAdt pInner id' tyParamIds' alts'

convert (ExpProtoDec p protoId tyParamId constrs tyAnns) = do
  protoId' <- freshTypeIdM protoId
  -- TODO: This is a symptom of a more general bug in the AC, where
  -- type parameter id's leak out of their intended lexical scope.
  -- We want any new bindings introduced in annotations to bind globally,
  -- but not type parameter id's.  Parameterized types also suffer from this problem.
  -- The solution is to add a new function to pop only segments of the current frame
  -- (e.g. popFrameTyEnv).
  -- pushNewFrame
  tyParamId' <- freshTypeIdM tyParamId
  constrs' <- mapM convertConstraint constrs
  tyAnns' <- mapM convertTyAnn tyAnns
  -- popFrame
  return $ ExpProtoDec p protoId' tyParamId' constrs' tyAnns'

convert (ExpProtoImp p synTy protoId constrs bodyEs) = do
  protoId' <- lookupTypeId protoId
  pushNewFrame
  synTy' <- convertTy synTy
  constrs' <- mapM convertConstraint constrs
  bodyEs' <- mapM convert bodyEs
  popFrame
  return $ ExpProtoImp p synTy' protoId' constrs' bodyEs'

convert (ExpTyAnn (TyAnn _ id _ _ _)) =
  throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convert (ExpWithAnn (TyAnn p aid tyParamIds synTy constrs) e) = do
  aid' <- freshVarIdM aid
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  synTy' <- convertTy synTy
  constrs' <- mapM convertConstraint constrs
  let tyAnn = TyAnn p aid' tyParamIds' synTy' constrs'
  case e of
    ExpFunDef (FunDefFun fp fid argPatEs bodyE) ->
      do pushNewFrame
         argPatEs' <- mapM convertPatExp argPatEs
         bodyE' <- convert bodyE
         popFrame
         let e' = ExpFunDef (FunDefFun fp aid' argPatEs' bodyE')
         return $ ExpWithAnn tyAnn e'
    ExpFunDefClauses p id funDefs ->
      do pushNewFrame
         funDef <- fst <$> desugarFunDefs aid' funDefs
         popFrame
         return $ ExpWithAnn tyAnn $ ExpFunDef funDef
    ExpAssign ep (PatExpId pp pid) e ->
      do e' <- convert e
         return $ ExpWithAnn tyAnn $ ExpAssign ep (PatExpId pp aid') e'
    _ -> throwError $ ErrInterpFailure $ "in convert ExpWithAnn: " ++ show e

convert (ExpStruct p qid fields) = do
  definitionContext <- baseStackFrame qid
  qid' <- convertTypeQualId qid `reportErrorAt` nodeData qid
  fields' <- mapM (\(FieldInit fieldId fieldE) ->
                      do fieldE' <- convert fieldE
                         fieldId' <- lookupVarIn fieldId definitionContext `reportErrorAt` p
                         return $ FieldInit fieldId' fieldE')
                  fields
  return $ ExpStruct p qid' fields'


convert (ExpIfElse p condE thenE elseE) = do
  condE' <- convert condE
  thenE' <- inNewFrame $ convert thenE
  elseE' <- inNewFrame $ convert elseE
  return $ ExpIfElse p condE' thenE' elseE'

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

convert (ExpFun p argPatEs bodyE) = do
  pushNewFrame
  argPatEs' <- mapM convertPatExp argPatEs
  bodyE' <- convert bodyE
  popFrame
  return $ ExpFun p argPatEs' bodyE'

convert (ExpPrecAssign p id level) = do
  id' <- lookupVarId id
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

convert (ExpQualifiedRef p (Id _ id)) = convert (ExpRef p id)
convert (ExpQualifiedRef p path@(Path pp qid id)) = do
  entry <- lookupVarQualId qid `reportErrorAt` pp
  case entry of
    UnknownEntry _ -> return $ ExpQualifiedRef p path
    -- UniqIdEntry uid -> return $ ExpRef p uid
    UniqIdEntry uid -> throwError $ ErrInvalidUniqModulePath qid
    FrameEntry _ frame -> do
      memberUid <- lookupVarIn id [frame] `reportErrorAt` pp
      return $ ExpRef p memberUid

convert (ExpRef p id) = do
  entry <- lookupVarEntry id `reportErrorAt` p
  case entry of
    UnknownEntry _ -> return $ ExpRef p id
    UniqIdEntry uid -> return $ ExpRef p uid
    FrameEntry _ _ -> throwError (ErrUnboundUniqIdentifier id) `reportErrorAt` p

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
      ExpTypeDec p typeDec -> ExpTypeDec p $ inject typeDec
      ExpDataDec p typeDec -> ExpDataDec p $ inject typeDec
      ExpProtoDec p id tyId constrs tyAnns ->
        ExpProtoDec p (UserId id) (UserId tyId) (map inject constrs) (map inject tyAnns)
      ExpProtoImp p synTy protoId constrs bodyEs ->
        ExpProtoImp p (inject synTy) (UserId protoId) (map inject constrs) (map inject bodyEs)
      ExpTyAnn tyAnn -> ExpTyAnn $ inject tyAnn
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
runAlphaConvert (CompUnit pos exps) = do
  modifyAC (\acEnv -> acEnv { pass = 0 })
  let withUserIds = map inject exps
  exps' <- mapM convert withUserIds
  modifyAC (\acEnv -> acEnv { pass = 1 })
  exps'' <- mapM convert exps'
  return $ CompUnit pos exps''
