module Latro.Reorder where

import Control.Monad.State
import Data.Map as Map hiding (map)
import Data.Maybe
import Latro.Compiler
import Latro.Semant


precLevel :: Env PrecLevel -> UniqId -> Maybe PrecLevel
precLevel env id = Map.lookup id env


runBuildPrecEnv :: UniqAst Exp -> State (Env PrecLevel) (UniqAst Exp)
runBuildPrecEnv (ExpPrecAssign p operatorId level) = do
  env <- get
  put $ Map.insert operatorId level env
  return $ ExpBegin p [ExpUnit p]

runBuildPrecEnv (ExpAssign p id e) = do
  e' <- runBuildPrecEnv e
  return $ ExpAssign p id e'

runBuildPrecEnv (ExpBegin p bodyEs) = do
  bodyEs' <- mapM runBuildPrecEnv bodyEs
  return $ ExpBegin p bodyEs'

runBuildPrecEnv e = return e


buildPrecEnv :: UniqAst CompUnit -> Env PrecLevel -> (UniqAst CompUnit, Env PrecLevel)
buildPrecEnv (CompUnit p bodyEs) precEnv =
    (CompUnit p bodyEs', env)
  where (bodyEs', env) = runState (mapM runBuildPrecEnv bodyEs) precEnv


reorderCaseClause :: Env PrecLevel -> UniqAst CaseClause -> UniqAst CaseClause
reorderCaseClause env (CaseClause p patE bodyE) =
  CaseClause p patE $ reorder env bodyE


reorder :: Env PrecLevel -> UniqAst Exp -> UniqAst Exp
reorder env (ExpCustomInfix p outerLhe@ExpCustomInfix{} outerOpId outerRhe)
    | needsReorder = ExpCustomInfix innerP innerLhe innerOpId $ ExpCustomInfix p innerRhe outerOpId outerRhe'
    | otherwise = ExpCustomInfix p outerLhe' outerOpId outerRhe'
  where
    outerLhe'@(ExpCustomInfix innerP innerLhe innerOpId innerRhe) = reorder env outerLhe
    outerRhe' = reorder env outerRhe
    maybeOuterLt = do outerLevel <- precLevel env outerOpId
                      innerLevel <- precLevel env innerOpId
                      return $ outerLevel < innerLevel
    needsReorder = fromMaybe False maybeOuterLt

reorder env e =
  case e of
    ExpCons p lhe rhe -> ExpCons p (r lhe) (r rhe)
    ExpInParens p e -> ExpInParens p (r e)
    ExpCustomInfix p lhe opId rhe ->
      ExpCustomInfix p (r lhe) opId (r rhe)
    ExpMemberAccess p e id -> ExpMemberAccess p (r e) id
    ExpApp p ratorE randEs -> ExpApp p (r ratorE) $ map r randEs
    eImp@ExpImport{} -> eImp
    ExpAssign p patE e -> ExpAssign p patE $ r e
    eTy@ExpTypeDec{} -> eTy
    eAnn@ExpTyAnn{} -> eAnn
    ExpWithAnn tyAnn e -> ExpWithAnn tyAnn $ r e
    ExpFunDef (FunDefFun p id argPatEs bodyE) ->
      ExpFunDef $ FunDefFun p id argPatEs $ r bodyE
    ExpModule p id bodyEs -> ExpModule p id $ map r bodyEs
    ExpStruct p synTy fieldInits ->
      ExpStruct p synTy $ map (\(FieldInit id e) -> FieldInit id $ r e) fieldInits
    ExpIfElse p e thenE elseE ->
      ExpIfElse p (r e) (r thenE) (r elseE)
    ExpMakeAdt p id n argEs ->
      ExpMakeAdt p id n $ map r argEs
    ExpGetAdtField p e n ->
      ExpGetAdtField p (r e) n
    ExpTuple p argEs ->
      ExpTuple p $ map r argEs
    ExpSwitch p e clauses ->
      ExpSwitch p (r e) $ map (reorderCaseClause env) clauses
    ExpList p es ->
      ExpList p $ map r es
    ExpFun p argPatEs bodyE ->
      ExpFun p argPatEs $ r bodyE
    ExpBegin p bodyEs ->
      ExpBegin p $ map r bodyEs
    _ -> e

  where
    r = reorder env


rewriteCaseClauseInfix :: UniqAst CaseClause -> UniqAst CaseClause
rewriteCaseClauseInfix (CaseClause p patE bodyE) =
    CaseClause p patE $ rewriteInfix bodyE


rewriteCondCaseClauseInfix :: UniqAst CondCaseClause -> UniqAst CondCaseClause
rewriteCondCaseClauseInfix clause =
  case clause of
    CondCaseClause p e bodyE ->
      CondCaseClause p (rewriteInfix e) $ rewriteInfix bodyE
    CondCaseClauseWildcard p bodyE ->
      CondCaseClauseWildcard p $ rewriteInfix bodyE


rewriteInfix :: UniqAst Exp -> UniqAst Exp
rewriteInfix (ExpCons p lhe rhe) = ExpCons p (rewriteInfix lhe) (rewriteInfix rhe)
rewriteInfix (ExpInParens p e) = ExpInParens p $ rewriteInfix e

rewriteInfix (ExpCustomInfix p lhe opId rhe) =
  ExpApp p (ExpRef p opId) [rewriteInfix lhe, rewriteInfix rhe]

rewriteInfix (ExpMemberAccess p e id) =
  ExpMemberAccess p (rewriteInfix e) id

rewriteInfix (ExpApp p ratorE randEs) =
  ExpApp p (rewriteInfix ratorE) $ map rewriteInfix randEs

rewriteInfix eImp@(ExpImport _ _) = eImp

rewriteInfix (ExpAssign p patE e) =
  ExpAssign p patE $ rewriteInfix e

rewriteInfix eTy@(ExpTypeDec _ _) = eTy
rewriteInfix eAnn@(ExpTyAnn _) = eAnn

rewriteInfix (ExpWithAnn tyAnn e) = ExpWithAnn tyAnn $ rewriteInfix e

rewriteInfix (ExpFunDef (FunDefFun p id argPatEs bodyE)) =
  ExpFunDef $ FunDefFun p id argPatEs $ rewriteInfix bodyE

rewriteInfix (ExpModule p id bodyEs) =
  ExpModule p id $ map rewriteInfix bodyEs

rewriteInfix (ExpStruct p synTy fieldInits) =
  ExpStruct p synTy $ map (\(FieldInit id e) -> FieldInit id $ rewriteInfix e) fieldInits

rewriteInfix (ExpIfElse p e thenE elseE) =
    ExpIfElse p (rewriteInfix e) thenE' elseE'
  where
    thenE' = rewriteInfix thenE
    elseE' = rewriteInfix elseE

rewriteInfix (ExpMakeAdt p id n argEs) =
  ExpMakeAdt p id n $ map rewriteInfix argEs

rewriteInfix (ExpGetAdtField p e n) =
  ExpGetAdtField p (rewriteInfix e) n

rewriteInfix (ExpTuple p argEs) =
  ExpTuple p $ map rewriteInfix argEs

rewriteInfix (ExpSwitch p e clauses) =
  ExpSwitch p (rewriteInfix e) $ map rewriteCaseClauseInfix clauses

rewriteInfix (ExpCond p clauses) =
  ExpCond p $ map rewriteCondCaseClauseInfix clauses

rewriteInfix (ExpList p es) = ExpList p $ map rewriteInfix es

rewriteInfix (ExpFun p patEs bodyE) =
  ExpFun p patEs $ rewriteInfix bodyE

rewriteInfix (ExpBegin p bodyEs) =
  ExpBegin p $ map rewriteInfix bodyEs

rewriteInfix e = e


type Reordered a = CompilerPass CompilerEnv a


runReorderInfixes :: UniqAst CompUnit -> Reordered (UniqAst CompUnit)
runReorderInfixes cu = do
    precEnv <- gets opPrecEnv
    let (CompUnit p bodyEs, precEnv') = buildPrecEnv cu precEnv
    modify (\cEnv -> cEnv { opPrecEnv = precEnv' })
    return $ CompUnit p $ map (rewriteInfix . reorder precEnv') bodyEs
