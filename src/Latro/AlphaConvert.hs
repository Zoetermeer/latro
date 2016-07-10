{-# LANGUAGE FlexibleContexts, NamedFieldPuns, TypeSynonymInstances #-}

{-|
Module      : AlphaConvert
Description : Rewrite the syntax tree such that all bound identifiers are unique

The rewriting guarantees that we cannot have shadowing or substitution problems
downstream.  As part of this transformation, we replace all qualified (raw) identifiers
with their unqualified, alpha-converted equivalents and factor out module definitions
altogether.
-}
module AlphaConvert where

import Collapse
import Common
import Control.Applicative
import Control.Monad.Except
import Control.Monad.State
import Data.List (all, find, nub)
import qualified Data.Map as Map (insert, lookup, union)
import Errors
import Prelude hiding (lookup)
import Semant
import Text.Printf (printf)


reportErrorAt a = reportPosOnFail a "AlphaConvert"


data Frame = Frame
  { index :: Int
  , varIdEnv  :: RawIdEnv AlphaEntry
  , typeIdEnv :: RawIdEnv AlphaEntry
  }
  deriving (Eq, Show)


mtFrame :: Int -> Frame
mtFrame ind = Frame { index = ind
                    , varIdEnv = mtRawIdEnv
                    , typeIdEnv = mtRawIdEnv
                    }


data AlphaEntry =
    UniqIdEntry UniqId
  | FrameEntry UniqId Frame
  | UnknownEntry UniqId
  deriving (Eq, Show)


data AlphaEnv = AlphaEnv
  { counter :: Int
  , stack   :: [Frame]
  , pass    :: Int
  }
  deriving (Eq, Show)


mtAlphaEnv :: AlphaEnv
mtAlphaEnv =
    AlphaEnv { counter = i
             , stack   = [mtFrame i]
             , pass    = 0
             }
  where i = 1


type AlphaConverted a = ExceptT Err (State AlphaEnv) a


isFirstPass :: AlphaConverted Bool
isFirstPass = gets pass >>= \p -> return $ p == 0


pushNewFrame :: AlphaConverted ()
pushNewFrame = do
  index <- nextIdIndexM
  pushFrame $ mtFrame index


pushFrame :: Frame -> AlphaConverted ()
pushFrame frame = do
  index <- nextIdIndexM
  modify (\aEnv -> aEnv { stack = frame : stack aEnv })


pushNewOrExistingFrame :: UniqId -> AlphaConverted UniqId
pushNewOrExistingFrame id = do
  entry <- lookupVarEntry id
  case entry of
    FrameEntry uid frame ->
      do modify (\aEnv -> aEnv { stack = frame : stack aEnv })
         return uid
    _ ->
      do pushNewFrame
         return id


popFrame :: AlphaConverted Frame
popFrame = do
  (frame : frames) <- gets stack
  modify (\aEnv -> aEnv { stack = frames })
  return frame


inNewFrame :: AlphaConverted a -> AlphaConverted a
inNewFrame thunk = do
  pushNewFrame
  v <- thunk
  popFrame
  return v


modifyFrame :: (Frame -> Frame) -> AlphaConverted ()
modifyFrame fModify = do
  (frame : frames) <- gets stack
  modify (\aEnv -> aEnv { stack = fModify frame : frames })


bindInCurrentFrame :: UniqId -> AlphaEntry -> AlphaConverted ()
bindInCurrentFrame (UserId rawId) entry = do
  (frame : frames) <- gets stack
  let updatedVars = Map.insert rawId entry $ varIdEnv frame
  modify (\aEnv -> aEnv { stack = (frame { varIdEnv = updatedVars }) : frames })

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
  alphaEnv <- get
  let (uniqId, alphaEnv') = fMake userId alphaEnv
  lift $ put alphaEnv'
  return uniqId

freshM id _ = return id


freshVarIdM :: UniqId -> AlphaConverted UniqId
freshVarIdM id = freshM id $ freshVarId True


freshVarIdIfNotBoundM :: UniqId -> AlphaConverted UniqId
freshVarIdIfNotBoundM uid@UniqId{} = return uid
freshVarIdIfNotBoundM userId = do
  curFrame <- gets $ head . stack
  if isBoundIn userId [curFrame] varIdEnv
    then throwError $ ErrIdAlreadyBound userId
    else freshVarIdM userId


freshTypeIdM :: UniqId -> AlphaConverted UniqId
freshTypeIdM id = freshM id freshTypeId


nextIdIndex :: AlphaEnv -> Int
nextIdIndex AlphaEnv{ counter } = counter


nextIdIndexM :: AlphaConverted Int
nextIdIndexM = do
  aEnv <- get
  let next = nextIdIndex aEnv
  put $ aEnv { counter = next }
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
lookupVarIn userId frames = do
  entry <- lookupEntryIn userId frames varIdEnv
  case entry of
    UniqIdEntry uid -> return uid
    FrameEntry uid _ -> return uid
    UnknownEntry id -> return id


lookupEntry :: UniqId -> (Frame -> RawIdEnv AlphaEntry) -> AlphaConverted AlphaEntry
lookupEntry id fGetEnv = do
  aEnv <- get
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
    UniqIdEntry _ ->
      throwError (ErrInvalidUniqModulePath qid) `reportErrorAt` p
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
baseFrame :: UniqAst QualifiedId -> AlphaConverted Frame
baseFrame Id{} = gets $ head . stack
baseFrame (Path _ qid _) = do
  (FrameEntry _ frame) <- lookupVarQualId qid
  return frame


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
convertTyAnn (TyAnn p id tyParamIds ty) = do
  id' <- freshVarIdM id
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  ty' <- convertTy ty
  return $ TyAnn p id' tyParamIds' ty'


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
convertFunDef (FunDefFun p id argPatEs bodyEs) = do
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- lookupVarId id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefFun p id' argPatEs' bodyEs'

convertFunDef (FunDefInstFun p instPatE id argPatEs bodyEs) = do
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- freshVarIdM id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefInstFun p instPatE' id' argPatEs' bodyEs'


convertCaseClause :: UniqAst CaseClause -> AlphaConverted (UniqAst CaseClause)
convertCaseClause (CaseClause p patE es) = do
  pushNewFrame
  patE' <- convertPatExp patE
  es' <- mapM convert es
  popFrame
  return $ CaseClause p patE' es'


funDefToCaseClause :: UniqAst FunDef -> AlphaConverted (UniqAst CaseClause)
funDefToCaseClause (FunDefFun p _ argPatEs bodyEs) = do
  let tupPat = PatExpTuple p argPatEs
  pushNewFrame
  tupPat' <- convertPatExp tupPat
  bodyEs' <- mapM convert bodyEs
  popFrame
  return $ CaseClause p tupPat' bodyEs'

funDefToCaseClause (FunDefInstFun p instPatE _ argPatEs bodyEs) = do
  let tupPat = PatExpTuple p $ instPatE : argPatEs
  pushNewFrame
  tupPat' <- convertPatExp tupPat
  bodyEs' <- mapM convert bodyEs
  popFrame
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
funDefArity :: UniqAst FunDef -> Int
funDefArity (FunDefFun _ _ patEs _) = length patEs
funDefArity (FunDefInstFun _ _ _ patEs _) = length patEs


desugarFunDefs :: UniqId -> [UniqAst FunDef] -> AlphaConverted (UniqAst FunDef, [UniqId])
desugarFunDefs fid funDefs =
  let arities = nub $ map funDefArity funDefs
      headFunDef = head funDefs
      startP = nodeData headFunDef
  in
    case arities of
      [len] -> do
        paramIds <- replicateM len ((\_ -> freshVarIdM $ UserId "arg") ())
        cases <- mapM funDefToCaseClause funDefs
        let paramRefs = map (ExpRef startP) paramIds
            paramPats = map (PatExpId startP) paramIds
        case headFunDef of
          FunDefFun _ _ argPatEs bodyEs ->
            let argsTup = ExpTuple startP paramRefs
            in
              return (FunDefFun startP fid paramPats [ExpSwitch startP argsTup cases], paramIds)
          FunDefInstFun _ instPatE _ argPatEs bodyEs ->
            do instId <- freshVarIdM $ UserId "this"
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
desugarCondClause :: UniqAst CondCaseClause -> (UniqAst Exp, [UniqAst Exp])
desugarCondClause (CondCaseClause _ testE bodyEs) = (testE, bodyEs)
desugarCondClause (CondCaseClauseWildcard p bodyEs) = (ExpBool p True, bodyEs)


desugarCondClauses :: SourcePos -> [UniqAst CondCaseClause] -> UniqAst Exp
desugarCondClauses p (clause:clauses) =
  let (testE, bodyEs) = desugarCondClause clause
      elseEs = case clauses of
                 [] -> [ExpFail p "Inexhaustive cond expression"]
                 _ -> [desugarCondClauses p clauses]
  in
    ExpIfElse (nodeData testE) testE bodyEs elseEs


desugarCond :: UniqAst Exp -> UniqAst Exp
desugarCond (ExpCond p clauses) = desugarCondClauses p clauses


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
convert (ExpAdd p a b) = convertBin ExpAdd p a b
convert (ExpSub p a b) = convertBin ExpSub p a b
convert (ExpDiv p a b) = convertBin ExpDiv p a b
convert (ExpMul p a b) = convertBin ExpMul p a b
convert (ExpCons p a b) = convertBin ExpCons p a b
convert (ExpCustomInfix p lhe id rhe) = do
  lhe' <- convert lhe
  rhe' <- convert rhe
  id' <- lookupVarId id
  return $ ExpCustomInfix p lhe' id' rhe'

convert (ExpMemberAccess p e id) = do
  e' <- convert e
  return $ ExpMemberAccess p e' id

convert (ExpApp p ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp p ratorE' randEs'

convert (ExpImport p qid) = do
  -- (FrameEntry _ frame) <- lookupVarQualId qid
  -- pushFrame frame
  (FrameEntry moduleId Frame{ varIdEnv = modVarIdEnv, typeIdEnv = modTypeIdEnv }) <- lookupVarQualId qid
  modifyFrame (\(curFrame@Frame{ varIdEnv, typeIdEnv }) ->
                  curFrame { varIdEnv = Map.union varIdEnv modVarIdEnv
                           , typeIdEnv = Map.union typeIdEnv modTypeIdEnv })
  return $ ExpUnit p

convert (ExpFunDef (FunDefFun p id argPatEs bodyEs)) = do
  id' <- freshVarIdM id
  pushNewFrame
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  popFrame
  return $ ExpFunDef $ FunDefFun p id' argPatEs' bodyEs'

convert (ExpFunDef (FunDefInstFun p instPatE id argPatEs bodyEs)) = do
  id' <- freshVarIdM id
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  return $ ExpFunDef $ FunDefInstFun p instPatE' id' argPatEs' bodyEs'

convert (ExpFunDefClauses p id funDefs) = do
  id' <- freshVarIdM id
  pushNewFrame
  funDef <- fst <$> desugarFunDefs id' funDefs
  popFrame
  return $ ExpFunDef funDef

convert (ExpAssign p (PatExpId pp rawId) (ExpModule mp paramIds bodyEs)) = do
  id' <- freshM rawId $ freshVarId False
  id'' <- pushNewOrExistingFrame rawId
  aEnv <- get
  bodyEs' <- mapM convert bodyEs
  moduleFrame <- popFrame
  bindInCurrentFrame id'' $ FrameEntry id'' moduleFrame
  firstPass <- isFirstPass
  if firstPass
    then return $ ExpAssign p (PatExpId pp rawId) (ExpModule mp paramIds bodyEs')
    else return $ ExpBegin p bodyEs'

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

convert (ExpTyAnn (TyAnn _ id _ _)) =
  throwError $ ErrInterpFailure $ "ExpTyAnn " ++ show id ++ " not removed before alpha-conversion!"

convert (ExpWithAnn (TyAnn p aid tyParamIds synTy) e) = do
  aid' <- freshVarIdM aid
  tyParamIds' <- mapM freshTypeIdM tyParamIds
  synTy' <- convertTy synTy
  let tyAnn = TyAnn p aid' tyParamIds' synTy'
  case e of
    ExpFunDef (FunDefFun fp fid argPatEs bodyEs) ->
      do pushNewFrame
         argPatEs' <- mapM convertPatExp argPatEs
         bodyEs' <- mapM convert bodyEs
         popFrame
         let e' = ExpFunDef (FunDefFun fp aid' argPatEs' bodyEs')
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

-- convert (ExpInterfaceDec p id tyParamIds memberTyAnns) = do
--   id' <- freshTypeIdM id
--   tyParamIds' <- mapM freshTypeIdM tyParamIds
--   memberTyAnns' <- mapM convertTyAnn memberTyAnns
--   return $ ExpInterfaceDec p id' tyParamIds' memberTyAnns'

-- convert (ExpModule p paramIds bodyEs) = do
--   paramIds' <- mapM freshVarIdM paramIds
--   bodyEs' <- mapM convert bodyEs
--   return $ ExpModule p paramIds' bodyEs'

convert (ExpStruct p qid fields) = do
  definitionFrame <- baseFrame qid
  qid' <- convertTypeQualId qid `reportErrorAt` nodeData qid
  fields' <- mapM (\(FieldInit fieldId fieldE) ->
                      do fieldE' <- convert fieldE
                         fieldId' <- lookupVarIn fieldId [definitionFrame]
                         return $ FieldInit fieldId' fieldE')
                  fields
  return $ ExpStruct p qid' fields'


convert (ExpIfElse p condE thenEs elseEs) = do
  condE' <- convert condE
  thenEs' <- inNewFrame $ mapM convert thenEs
  elseEs' <- inNewFrame $ mapM convert elseEs
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
  pushNewFrame
  argPatEs' <- mapM convertPatExp argPatEs
  bodyEs' <- mapM convert bodyEs
  popFrame
  return $ ExpFun p argPatEs' bodyEs'

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
    UniqIdEntry uid -> return $ ExpMemberAccess p (ExpRef pp uid) id
    FrameEntry _ frame -> do
      memberUid <- lookupVarIn id [frame] `reportErrorAt` pp
      return $ ExpRef p memberUid

convert (ExpRef p id) = do
  id' <- lookupVarId id `reportErrorAt` p
  return $ ExpRef p id'

convert e = throwError $ ErrInterpFailure $ printf "convert failed for: %s" $ show e


class InjectUserIds a where
  inject :: RawAst a -> UniqAst a


instance InjectUserIds QualifiedId where
  inject (Id p id) = Id p $ UserId id
  inject (Path p qid id) = Path p (inject qid) (UserId id)


instance InjectUserIds CaseClause where
  inject (CaseClause p patE bodyEs) =
    CaseClause p (inject patE) (map inject bodyEs)


instance InjectUserIds CondCaseClause where
  inject (CondCaseClause p testE bodyEs) =
    CondCaseClause p (inject testE) (map inject bodyEs)
  inject (CondCaseClauseWildcard p bodyEs) =
    CondCaseClauseWildcard p $ map inject bodyEs


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
  inject (FunDefFun p id argPatEs bodyEs) =
    FunDefFun p (UserId id) (map inject argPatEs) (map inject bodyEs)

  inject (FunDefInstFun p instPatE id argPatEs bodyEs) =
    FunDefInstFun p
                  (inject instPatE)
                  (UserId id)
                  (map inject argPatEs)
                  (map inject bodyEs)


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
  inject (TyAnn p id tyParamIds synTy) =
    TyAnn p (UserId id) (map UserId tyParamIds) (inject synTy)


instance InjectUserIds AdtAlternative where
  inject (AdtAlternative p id i synTy) =
    AdtAlternative p (UserId id) i (map inject synTy)


instance InjectUserIds TypeDec where
  inject (TypeDecTy p id tyParamIds synTy) =
    TypeDecTy p (UserId id) (map UserId tyParamIds) (inject synTy)
  inject (TypeDecAdt p id tyParamIds alts) =
    TypeDecAdt p (UserId id) (map UserId tyParamIds) (map inject alts)


instance InjectUserIds Exp where
  inject e =
    case e of
      ExpAdd p a b -> ExpAdd p (r a) (r b)
      ExpSub p a b -> ExpSub p (r a) (r b)
      ExpDiv p a b -> ExpDiv p (r a) (r b)
      ExpMul p a b -> ExpMul p (r a) (r b)
      ExpCons p a b -> ExpCons p (r a) (r b)
      ExpCustomInfix p a rator b ->
        ExpCustomInfix p (r a) (UserId rator) (r b)
      ExpMemberAccess p e id -> ExpMemberAccess p (r e) (UserId id)
      ExpApp p rator rands -> ExpApp p (r rator) (map r rands)
      ExpImport p qid -> ExpImport p $ inject qid
      ExpAssign p patE e -> ExpAssign p (inject patE) (r e)
      ExpTypeDec p typeDec -> ExpTypeDec p $ inject typeDec
      ExpTyAnn tyAnn -> ExpTyAnn $ inject tyAnn
      ExpWithAnn tyAnn e -> ExpWithAnn (inject tyAnn) $ inject e
      ExpFunDef funDef -> ExpFunDef $ inject funDef
      ExpFunDefClauses p id funDefs ->
        ExpFunDefClauses p (UserId id) (map inject funDefs)
      ExpInterfaceDec p id paramIds tyAnns ->
        ExpInterfaceDec p (UserId id) (map UserId paramIds) (map inject tyAnns)
      ExpModule p paramIds bodyEs ->
        ExpModule p (map UserId paramIds) (map inject bodyEs)
      ExpStruct p qid fieldInits ->
        ExpStruct p (inject qid) (map inject fieldInits)
      ExpIfElse p e thenEs elseEs ->
        ExpIfElse p (inject e) (map inject thenEs) (map inject elseEs)
      ExpMakeAdt p id i argEs ->
        ExpMakeAdt p (UserId id) i (map inject argEs)
      ExpGetAdtField p e i -> ExpGetAdtField p (inject e) i
      ExpTuple p es -> ExpTuple p $ map inject es
      ExpSwitch p e clauses -> ExpSwitch p (inject e) (map inject clauses)
      ExpCond p clauses -> ExpCond p $ map inject clauses
      ExpList p es -> ExpList p $ map inject es
      ExpFun p argPatEs bodyEs ->
        ExpFun p (map inject argPatEs) (map inject bodyEs)
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


alphaConvert :: RawAst CompUnit -> Either Err (UniqAst CompUnit, AlphaEnv)
alphaConvert (CompUnit pos exps) = do
  collapsedEs <- collapseEs exps
  let withUserIds = map inject collapsedEs
  let (eithExps, alphaEnv) = runState (runExceptT $ mapM convert withUserIds) mtAlphaEnv
  exps' <- eithExps
  let (eithExps', alphaEnv') = runState (runExceptT $ mapM convert exps') $ alphaEnv { pass = 1 }
  exps'' <- eithExps'
  return (CompUnit pos exps'', alphaEnv')
