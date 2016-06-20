module Reorder where

import Common
import Control.Monad.State
import Data.Map as Map hiding (map)
import Data.Maybe
import Errors
import Semant


type PrecLevel = Int


precLevel :: Env PrecLevel -> UniqId -> Maybe PrecLevel
precLevel env id = Map.lookup id env


runBuildPrecEnv :: UniqAst Exp -> State (Env PrecLevel) (UniqAst Exp)
runBuildPrecEnv (ExpPrecAssign p operatorId level) = do
  env <- get
  put $ Map.insert operatorId level env
  return $ ExpBegin p [ExpUnit p]

runBuildPrecEnv (ExpModule p paramIds bodyEs) = do
  bodyEs' <- mapM runBuildPrecEnv bodyEs
  return $ ExpModule p paramIds bodyEs'

runBuildPrecEnv e = return e


buildPrecEnv :: UniqAst CompUnit -> (UniqAst CompUnit, Env PrecLevel)
buildPrecEnv (CompUnit p bodyEs) =
    (CompUnit p bodyEs', env)
  where (bodyEs', env) = runState (mapM runBuildPrecEnv bodyEs) mtEnv


reorder :: Env PrecLevel -> UniqAst Exp -> UniqAst Exp
reorder env (ExpCustomInfix p outerLhe@(ExpCustomInfix _ _ _ _) outerOpId outerRhe)
    | needsReorder = ExpCustomInfix innerP innerLhe innerOpId $ ExpCustomInfix p innerRhe outerOpId outerRhe'
    | otherwise = ExpCustomInfix p outerLhe' outerOpId outerRhe'
  where
    outerLhe'@(ExpCustomInfix innerP innerLhe innerOpId innerRhe) = reorder env outerLhe
    outerRhe' = reorder env outerRhe
    maybeOuterLt = do outerLevel <- precLevel env outerOpId
                      innerLevel <- precLevel env innerOpId
                      return $ outerLevel < innerLevel
    needsReorder = fromMaybe False maybeOuterLt

reorder env (ExpCustomInfix p lhe opId rhe) =
    ExpCustomInfix p lhe' opId rhe'
  where lhe' = reorder env lhe
        rhe' = reorder env rhe

reorder env (ExpModule p paramIds bodyEs) =
    ExpModule p paramIds bodyEs'
  where bodyEs' = map (reorder env) bodyEs

reorder _ e = e


rewriteCaseClauseInfix :: UniqAst CaseClause -> UniqAst CaseClause
rewriteCaseClauseInfix (CaseClause p patE bodyEs) =
    CaseClause p patE $ map rewriteInfix bodyEs


rewriteInfix :: UniqAst Exp -> UniqAst Exp
rewriteInfix (ExpCustomInfix p lhe opId rhe) =
  ExpApp p (ExpRef p opId) [rewriteInfix lhe, rewriteInfix rhe]

rewriteInfix (ExpFunDef (FunDefFun p id argPatEs bodyEs)) =
  ExpFunDef $ FunDefFun p id argPatEs $ map rewriteInfix bodyEs

rewriteInfix (ExpSwitch p e clauses) =
  ExpSwitch p (rewriteInfix e) $ map rewriteCaseClauseInfix clauses

rewriteInfix e = e


reorderInfixes :: UniqAst CompUnit -> Either Err (UniqAst CompUnit)
reorderInfixes cu =
    return $ CompUnit p $ map rewriteInfix bodyEs'
  where (CompUnit p bodyEs, env) = buildPrecEnv cu
        bodyEs' = map (reorder env) bodyEs
