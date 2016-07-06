{-# LANGUAGE FlexibleContexts, NamedFieldPuns #-}
module Interp where

import AlphaConvert hiding (lookup, lookupVarId, reportErrorAt)
import Common
import Control.Error.Util (hoistEither)
import Control.Monad (unless)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.Functor.Identity (runIdentity)
import Data.List
import qualified Data.Map as Map
import Data.Maybe (fromJust, isJust)
import Data.Monoid ((<>), mempty)
import Errors
import Parse
import Prelude hiding (lookup)
import Semant
import Text.Printf (printf)


reportErrorAt a = reportPosOnFail a "Interp"


-- An evaluator monad is a possibly-failing computation
-- with a state: (type environment, variable environment, current module)
-- The variable environment maps ID --o--> Value
-- The "current module" is the module currently being evaluated,
-- at the top level it's an invented anonymous one.
-- The top-level anonymous module gives the nice property
-- that bindings at the top (not in any explicitly defined
-- module) are closed over in submodules, but will
-- not be accessible from other compilation units.
-- Each new binding occurrence adds the id to the current
-- module's list of exports
data InterpEnv = InterpEnv
  { varEnv  :: VEnv
  , curModule :: Module
  , alphaEnv :: AlphaEnv
  }
  deriving (Eq)

type Eval a = ExceptT Err (State InterpEnv) a


mtExports :: Exports
mtExports = Exports { exportTypes = Map.empty
                    , exportVars =  Map.empty
                    }

mtInterpEnv :: AlphaEnv -> InterpEnv
mtInterpEnv alphaEnv =
    InterpEnv
      { varEnv = Map.empty
      , curModule = mod
      , alphaEnv = alphaEnv
      }
  where
    mod = Module mtEnv [] mtExports


lookupId :: UniqId -> Map.Map UniqId v -> Eval v
lookupId id map =
    hoistEither eithV
  where
    eithV = maybeToEither err $ Map.lookup id map
    err = ErrUnboundUniqIdentifier id


lookupQualIn  :: TypedAst QualifiedId
              -> InterpEnv
              -> (Exports -> Map.Map UniqId a)
              -> (InterpEnv -> Map.Map UniqId a)
              -> Eval a
lookupQualIn (Id p id) intEnv _ extractAEnv = lookupId id $ extractAEnv intEnv
lookupQualIn (Path p qid id) intEnv extractExportEnv _ = do
  v <- lookupQualIn qid intEnv exportVars varEnv
  case v of
    ValueModule (Module _ _ exports) ->
      lookupId id $ extractExportEnv exports
    _ -> throwError $ ErrInterpFailure $ printf "Can't lookup qualified ID in: %s" $ show v


lookupVarQualIn :: TypedAst QualifiedId -> InterpEnv -> Eval Value
lookupVarQualIn id intEnv = lookupQualIn id intEnv exportVars varEnv


lookupVarQual :: TypedAst QualifiedId -> Eval Value
lookupVarQual id = get >>= lookupVarQualIn id


lookupVarId :: UniqId -> Eval Value
lookupVarId id = getVarEnv >>= lookupId id


getVarEnv :: Eval VEnv
getVarEnv = gets varEnv


bindVar :: UniqId -> Value -> Eval ()
bindVar id v =
  modify (\intEnv -> intEnv { varEnv = Map.insert id v (varEnv intEnv) })


exportVar :: UniqId -> Value -> Eval ()
exportVar id v =
  modify (\intEnv ->
            let (Module cloEnv paramIds exports) = curModule intEnv
                exports' = exports { exportVars = Map.insert id v (exportVars exports) }
            in
              intEnv { curModule = Module cloEnv paramIds exports' })


pushNewModuleContext :: Eval InterpEnv
pushNewModuleContext = do
  curEnv <- get
  modify (\intEnv -> intEnv { curModule = Module (varEnv curEnv) [] mtExports })
  return curEnv


getClosureEnv :: Eval VEnv
getClosureEnv = gets varEnv


restoreEnv :: InterpEnv -> Eval ()
restoreEnv = put


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> TypedAst Exp -> TypedAst Exp -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


freshId :: Eval UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let index = nextIdIndex alphaEnv
  let (uniqId, alphaEnv') = freshVarId (printf "%s%i" "x" index) alphaEnv
  modify (\interpEnv -> interpEnv { alphaEnv = alphaEnv' })
  return uniqId


evalPatExp :: TypedAst PatExp -> Value -> Eval ()
evalPatExp (PatExpWildcard _) _ = return ()
evalPatExp e@(PatExpNumLiteral (OfTy p _) n) v =
    unless (i == ni) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueInt i) = v
    ni = read n

evalPatExp e@(PatExpBoolLiteral (OfTy p _) b) v =
    unless (bv == b) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueBool bv) = v

evalPatExp e@(PatExpStringLiteral (OfTy p _) s) v =
    unless (vStr == s) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueList cvs) = v
    vStr = map (\(ValueChar c) -> c) cvs

evalPatExp e@(PatExpCharLiteral (OfTy p _) [c]) v =
    unless (cv == c) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueChar cv) = v

evalPatExp e@(PatExpTuple _ patEs) v =
    if length patEs /= length vs
    then throwError $ ErrPatMatchFail e v
    else do
      let evPairs = zip patEs vs
      mapM_ (uncurry evalPatExp) evPairs
      return ()
  where
    (ValueTuple vs) = v

evalPatExp patE@(PatExpAdt (OfTy p _) qid patEs) v@(ValueAdt (Adt ctorId _ vs))
    | id == ctorId =
      let evPairs = zip patEs vs
      in do mapM_ (uncurry evalPatExp) evPairs
            return ()
    | otherwise = throwError (ErrPatMatchFail patE v) `reportErrorAt` p
  where
    id = case qid of
          Path _ qid' id -> id
          Id _ id -> id

evalPatExp e@(PatExpList (OfTy p _) es) v =
    if length es /= length vs
    then throwError (ErrPatMatchFail e v) `reportErrorAt` p
    else do
      let evPairs = zip es vs
      mapM_ (uncurry evalPatExp) evPairs
      return ()
  where
    (ValueList vs) = v

evalPatExp e@PatExpListCons{} v@(ValueList []) =
  throwError $ ErrPatMatchFail e v

evalPatExp (PatExpListCons _ eHd eTl) (ValueList (v:vs)) = do
  evalPatExp eHd v
  evalPatExp eTl $ ValueList vs
  return ()

evalPatExp (PatExpId _ id) v = do
  bindVar id v
  exportVar id v
  return ()


evalE :: TypedAst Exp -> Eval Value
evalE (ExpNum _ str) = return $ ValueInt $ read str
evalE (ExpBool _ b) = return $ ValueBool b
evalE (ExpString _ s) = return $ ValueList $ map ValueChar s
evalE (ExpChar _ [c]) = return $ ValueChar c
evalE (ExpAdd _ a b) = evalBinArith (+) a b
evalE (ExpSub _ a b) = evalBinArith (-) a b
evalE (ExpDiv _ a b) = evalBinArith quot a b
evalE (ExpMul _ a b) = evalBinArith (*) a b

evalE (ExpCons _ a b) = do
  vHd <- evalE a
  (ValueList vs) <- evalE b
  return $ ValueList (vHd:vs)

evalE (ExpTuple _ es) = do
  vs <- mapM evalE es
  return $ ValueTuple vs

evalE (ExpList _ es) = do
  vs <- mapM evalE es
  return $ ValueList vs

evalE (ExpMakeAdt _ ty i ctorArgEs) = do
  argVs <- mapM evalE ctorArgEs
  return $ ValueAdt $ Adt ty i argVs

evalE (ExpGetAdtField _ e index) = do
  (ValueAdt (Adt _ _ fieldVs)) <- evalE e
  return (fieldVs !! index)

evalE (ExpTypeDec _ _) = return ValueUnit

evalE (ExpModule _ paramIds moduleEs) = do
  oldEnv <- pushNewModuleContext
  mapM_ evalE moduleEs
  (Module cloEnv oldParamIds exports) <- gets curModule
  restoreEnv oldEnv
  return $ ValueModule $ Module cloEnv (oldParamIds ++ paramIds) exports

evalE (ExpStruct (OfTy _ ty) _ fieldInits) = do
  fieldInitVs <- mapM (\(FieldInit id e) -> do { v <- evalE e; return (id, v) }) fieldInits
  return $ ValueStruct $ Struct ty fieldInitVs

evalE (ExpFunDef (FunDefFun (OfTy p ty) funId argPatEs bodyEs)) =
  let paramIds = map (\(PatExpId _ paramId) -> paramId) argPatEs
      ef = ExpFun (OfTy p ty) argPatEs bodyEs
  in do cloEnv <- getClosureEnv
        let f = ValueFun $ Closure funId ty cloEnv paramIds bodyEs
        bindVar funId f
        exportVar funId f
        return ValueUnit

evalE (ExpAssign _ patE@(PatExpId _ funId) ef@ExpFun{}) = do
  (ValueFun (Closure _ ty cloEnv paramIds bodyEs)) <- evalE ef
  let recF = ValueFun $ Closure funId ty cloEnv paramIds bodyEs
  evalPatExp patE recF
  return ValueUnit

evalE (ExpAssign _ patE e) = do
  v <- evalE e
  let (OfTy patEPos _) = nodeData patE
  evalPatExp patE v
  return ValueUnit

evalE (ExpRef (OfTy p _) id) =
  lookupVarId id `reportErrorAt` p

evalE (ExpUnit _) = return ValueUnit

evalE (ExpBegin _ es) = evalEs es

evalE (ExpImport _ qid) = do
  (ValueModule (Module _ _ exports)) <- lookupVarQual qid
  let moduleVars = exportVars exports
  modify (\env -> env { varEnv = Map.union moduleVars (varEnv env) })
  return ValueUnit

evalE (ExpApp _ e argEs) = do
  fv@(ValueFun (Closure fid fTy fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs

  preApplyInterpEnv <- get
  put (preApplyInterpEnv { varEnv = fenv })

  bindVar fid fv
  let argVTbl = zip paramIds argVs
  mapM_ (uncurry bindVar) argVTbl
  retV <- evalEs bodyEs

  restoreEnv preApplyInterpEnv
  return retV

evalE (ExpFun (OfTy _ ty) argPatEs bodyEs) = do
    cloEnv <- getClosureEnv
    newId <- freshId
    return $ ValueFun $ Closure newId ty cloEnv paramIds bodyEs
  where paramIds = map (\(PatExpId _ paramId) -> paramId) argPatEs

evalE (ExpMemberAccess (OfTy p _) e id) = do
    (ValueModule (Module _ _ exports)) <- evalE e
    let handle = flip reportErrorAt p
    handle (lookupId id (exportVars exports) `reportErrorAt` p)
  where
    err = ErrUnboundUniqIdentifier id

-- We throw away the updated environment
-- after each evaluation to avoid local binding
-- escape
evalE (ExpIfElse _ condE thenEs elseEs) = do
  curEnv <- get
  (ValueBool condV) <- evalE condE
  restoreEnv curEnv
  let es = if condV then thenEs else elseEs
  v <- evalEs es
  restoreEnv curEnv
  return v

evalE switchE@(ExpSwitch (OfTy p _) e clauses) = do
  v <- evalE e
  matchResult <- evalCaseClauses v clauses
  hoistEither (maybeToEither (ErrNonExhaustivePattern switchE v) matchResult) `reportErrorAt` p

evalE (ExpFail (OfTy pos _) msg) =
  throwError $ ErrUserFail pos msg

evalE e = throwError $ ErrCantEvaluate e


evalCaseClauses :: Value -> [TypedAst CaseClause] -> Eval (Maybe Value)
evalCaseClauses _ [] = return Nothing
evalCaseClauses v (CaseClause _ patE bodyEs : clauses) = do
  oldEnv <- get
  result <- do { r <- evalPatExp patE v; return $ Just () } `catchError` (\_ -> return Nothing)
  case result of
    Nothing -> do
      restoreEnv oldEnv
      evalCaseClauses v clauses
    Just _ -> do
      retV <- evalEs bodyEs
      return $ Just retV


evalEs :: [TypedAst Exp] -> Eval Value
evalEs [] = return ValueUnit
evalEs [e] = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: TypedAst CompUnit -> Eval Value
eval (CompUnit _ es) = evalEs es

interp :: TypedAst CompUnit -> AlphaEnv -> Either Err Value
interp alphaConverted alphaEnv =
  evalState (runExceptT $ eval alphaConverted) $ mtInterpEnv alphaEnv
