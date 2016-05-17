{-# LANGUAGE NamedFieldPuns #-}
module Interp where

import AlphaConvert hiding (lookup)
import Common
import Control.Error.Util (hoistEither)
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


reportErrorAt a p =
  reportPosOnFail a "Interp" p


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
  { typeEnv :: TEnv
  , varEnv  :: VEnv
  , curModule :: Module
  , alphaEnv :: AlphaEnv
  }
  deriving (Eq)

type Eval a = ExceptT Err (State InterpEnv) a

mtClosureEnv :: ClosureEnv
mtClosureEnv = ClosureEnv { cloTypeEnv = Map.empty
                          , cloVarEnv = Map.empty
                          }

mtExports :: Exports
mtExports = Exports { exportTypes = Map.empty
                    , exportVars =  Map.empty
                    }

mtInterpEnv :: AlphaEnv -> InterpEnv
mtInterpEnv alphaEnv =
    InterpEnv
      { typeEnv = Map.empty
      , varEnv = Map.empty
      , curModule = mod
      , alphaEnv = alphaEnv
      }
  where
    mod = Module mtClosureEnv [] mtExports


lookupId :: UniqId -> Map.Map UniqId v -> Eval v
lookupId id map =
    hoistEither eithV
  where
    eithV = maybeToEither err $ Map.lookup id map
    err = ErrUnboundUniqIdentifier id


lookupQualIn  :: UniqAst QualifiedId
              -> InterpEnv
              -> (Exports -> Map.Map UniqId a)
              -> (InterpEnv -> Map.Map UniqId a)
              -> Eval a
lookupQualIn (Id p id) intEnv _ extractAEnv = lookupId id $ extractAEnv intEnv
lookupQualIn (Path p qid id) intEnv extractExportEnv _ = do
  (ValueModule (Module _ _ exports)) <- lookupQualIn qid intEnv exportVars varEnv
  lookupId id $ extractExportEnv exports


-- lookupTyQualIn :: UniqAst QualifiedId -> InterpEnv -> Eval (UniqAst SynTy)
-- lookupTyQualIn id intEnv = lookupQualIn id intEnv exportTypes typeEnv


lookupVarQualIn :: UniqAst QualifiedId -> InterpEnv -> Eval Value
lookupVarQualIn id intEnv = lookupQualIn id intEnv exportVars varEnv


lookupVarQual :: UniqAst QualifiedId -> Eval Value
lookupVarQual id = get >>= lookupVarQualIn id


-- lookupTyQual :: UniqAst QualifiedId -> Eval (UniqAst SynTy)
-- lookupTyQual id = get >>= lookupTyQualIn id


lookupVarId :: UniqId -> Eval Value
lookupVarId id = getVarEnv >>= lookupId id


getVarEnv :: Eval VEnv
getVarEnv = gets varEnv


getTyEnv :: Eval TEnv
getTyEnv = gets typeEnv


putVarBinding :: UniqId -> Value -> Eval ()
putVarBinding id v = do
  modify (\intEnv -> intEnv { varEnv = Map.insert id v (varEnv intEnv) })


-- putTyBinding :: UniqId -> UniqAst SynTy -> Eval ()
-- putTyBinding id ty = do
--   modify (\\intEnv -> intEnv { typeEnv = Map.insert id ty (typeEnv intEnv) })


putModuleVarExport :: UniqId -> Value -> Eval ()
putModuleVarExport id v = do
  modify (\intEnv ->
            let (Module cloEnv paramIds exports) = curModule intEnv
                exports' = exports { exportVars = Map.insert id v (exportVars exports) }
            in
              intEnv { curModule = Module cloEnv paramIds exports' })


-- putModuleTyExport :: UniqId -> UniqAst SynTy -> Eval ()
-- putModuleTyExport id ty = do
--   modify (\\intEnv ->
--             let (Module cloEnv paramIds exports) = curModule intEnv
--                 exports' = exports { exportTypes = Map.insert id ty (exportTypes exports) }
--             in
--               intEnv { curModule = Module cloEnv paramIds exports' })


pushNewModuleContext :: Eval InterpEnv
pushNewModuleContext = do
  curEnv <- get
  let modCloEnv = ClosureEnv { cloTypeEnv = typeEnv curEnv, cloVarEnv = varEnv curEnv }
  modify (\intEnv -> intEnv { curModule = Module modCloEnv [] mtExports })
  return curEnv


getClosureEnv :: Eval ClosureEnv
getClosureEnv = do
  curEnv <- get
  return $ ClosureEnv { cloTypeEnv = typeEnv curEnv, cloVarEnv = varEnv curEnv }


restoreEnv :: InterpEnv -> Eval ()
restoreEnv intEnv = put intEnv


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
  let (uniqId, alphaEnv') = fresh (printf "%s%i" "x" index) alphaEnv
  modify (\interpEnv -> interpEnv { alphaEnv = alphaEnv' })
  return uniqId


-- evalAdtAlt :: UniqAst SynTy -> UniqAst AdtAlternative -> Eval ()
-- evalAdtAlt ty (AdtAlternative id i tys) = do
--   argIds <- mapM (\\_ -> freshId) tys
--   let argRefs = map ExpRef argIds
--   cloTypeEnv <- gets typeEnv
--   let cloEnv = ClosureEnv { cloTypeEnv, cloVarEnv = Map.empty }
--       ctorTy = SynTyArrow tys ty
--       clo = Closure id ctorTy cloEnv argIds [ExpMakeAdt ty i argRefs]
-- 
--   putVarBinding id $ ValueFun clo
--   putModuleVarExport id $ ValueFun clo
--   return ()


evalPatExp :: TypedAst PatExp -> Value -> Eval ()
evalPatExp (PatExpWildcard _) _ = return ()
evalPatExp e@(PatExpNumLiteral _ n) v =
    if i == ni
    then return ()
    else throwError $ ErrPatMatchFail e v
  where
    (ValueInt i) = v
    ni = read n

evalPatExp e@(PatExpBoolLiteral _ b) v =
    if bv == b
    then return ()
    else throwError $ ErrPatMatchFail e v
  where
    (ValueBool bv) = v

evalPatExp e@(PatExpTuple _ patEs) v =
    if length patEs /= length vs
    then throwError $ ErrPatMatchFail e v
    else do
      let evPairs = zip patEs vs
      mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
      return ()
  where
    (ValueTuple vs) = v

evalPatExp patE@(PatExpAdt _ id patEs) v@(ValueAdt (Adt ctorId _ vs))
  | id == ctorId =
    let evPairs = zip patEs vs
    in do mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
          return ()
  | otherwise = throwError $ ErrPatMatchFail patE v

evalPatExp e@(PatExpList _ es) v =
    if length es /= length vs
    then throwError $ ErrPatMatchFail e v
    else do
      let evPairs = zip es vs
      mapM_ (\(patE, v) -> evalPatExp patE v) evPairs
      return ()
  where
    (ValueList vs) = v

evalPatExp e@(PatExpListCons _ _ _) v@(ValueList []) =
  throwError $ ErrPatMatchFail e v

evalPatExp (PatExpListCons _ eHd eTl) (ValueList (v:vs)) = do
  evalPatExp eHd v
  evalPatExp eTl $ ValueList vs
  return ()

evalPatExp (PatExpId _ id) v = do
  putVarBinding id v
  putModuleVarExport id v
  return ()


evalE :: TypedAst Exp -> Eval Value
evalE (ExpNum _ str) = return $ ValueInt $ read str
evalE (ExpBool _ b) = return $ ValueBool b
evalE (ExpString _ s) = return $ ValueStr s
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

evalE (ExpTypeDec _ (TypeDecTy _ id ty)) = do
  -- putTyBinding id ty
  -- putModuleTyExport id ty
  return ValueUnit

evalE (ExpTypeDec _ (TypeDecAdt _ id _ alts)) = do
  -- let alts' = mapi (\\i (AdtAlternative aid _ tys) -> AdtAlternative aid i tys) alts
  --     ty = SynTyAdt id alts'
  -- putTyBinding id ty
  -- putModuleTyExport id ty

  -- mapM_ (evalAdtAlt ty) alts'
  return ValueUnit

evalE (ExpModule _ paramIds moduleEs) = do
  oldEnv <- pushNewModuleContext
  mapM_ evalE moduleEs
  (Module cloEnv oldParamIds exports) <- gets curModule
  restoreEnv oldEnv
  return $ ValueModule $ Module cloEnv (oldParamIds ++ paramIds) exports

evalE (ExpStruct (OfTy _ ty) _ fieldInits) = do
  fieldInitVs <- mapM (\(id, e) -> do { v <- evalE e; return (id, v) }) fieldInits
  return $ ValueStruct $ Struct ty fieldInitVs

evalE (ExpAssign _ patE@(PatExpId _ funId) ef@(ExpFun _ _ _)) = do
  (ValueFun (Closure _ ty cloEnv paramIds bodyEs)) <- evalE ef
  let recF = ValueFun $ Closure funId ty cloEnv paramIds bodyEs
  evalPatExp patE recF
  return ValueUnit

evalE (ExpAssign _ patE e) = do
  v <- evalE e
  evalPatExp patE v
  return ValueUnit

evalE (ExpRef (OfTy p _) rawId) = do
  v <- lookupVarId rawId `reportErrorAt` p
  return v

evalE (ExpUnit _) = return ValueUnit

evalE (ExpBegin _ es) = evalEs es

evalE (ExpApp _ e argEs) = do
  fv@(ValueFun (Closure fid fTy fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs

  preApplyInterpEnv <- get
  put (preApplyInterpEnv { typeEnv = cloTypeEnv fenv, varEnv = cloVarEnv fenv })

  putVarBinding fid fv
  let argVTbl = zip paramIds argVs
  mapM_ (\(paramId, paramV) -> putVarBinding paramId paramV) argVTbl
  retV <- evalEs bodyEs

  restoreEnv preApplyInterpEnv
  return retV

evalE (ExpFun (OfTy _ ty) paramIds bodyEs) = do
  cloEnv <- getClosureEnv
  newId <- freshId
  return $ ValueFun $ Closure newId ty cloEnv paramIds bodyEs

evalE (ExpMemberAccess (OfTy p _) e id) = do
  v <- evalE e
  let handle = (flip reportErrorAt) p
  handle $ case v of
             (ValueModule (Module _ _ exports)) ->
               lookupId id $ exportVars exports
             (ValueStruct (Struct _ fields)) ->
               hoistEither $ maybeToEither err $ lookup id fields
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
  (hoistEither (maybeToEither (ErrNonExhaustivePattern switchE v) matchResult)) `reportErrorAt` p

evalE (ExpFail (OfTy pos _) msg) =
  throwError $ ErrUserFail pos msg

evalE e = throwError $ ErrCantEvaluate e


evalCaseClauses :: Value -> [TypedAst CaseClause] -> Eval (Maybe Value)
evalCaseClauses _ [] = return Nothing
evalCaseClauses v ((CaseClause _ patE bodyEs):clauses) = do
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
evalEs (e:[]) = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: TypedAst CompUnit -> Eval Value
eval (CompUnit _ es) = evalEs es

interp :: TypedAst CompUnit -> AlphaEnv -> Either Err Value
interp alphaConverted alphaEnv = do
  evalState (runExceptT $ eval alphaConverted) $ mtInterpEnv alphaEnv
