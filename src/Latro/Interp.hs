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


getClosureEnv :: Eval VEnv
getClosureEnv = gets varEnv


restoreEnv :: InterpEnv -> Eval ()
restoreEnv = put


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> Typed IL -> Typed IL -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


freshId :: Eval UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let index = nextIdIndex alphaEnv
  let (uniqId, alphaEnv') = freshVarId True (UserId (printf "%s%i" "x" index)) alphaEnv
  modify (\interpEnv -> interpEnv { alphaEnv = alphaEnv' })
  return uniqId


evalPat :: Typed ILPat -> Value -> Eval ()
evalPat (ILPatWildcard _) _ = return ()
evalPat e@(ILPatInt (OfTy p _) ni) v =
    unless (i == ni) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueInt i) = v

evalPat e@(ILPatBool (OfTy p _) b) v =
    unless (bv == b) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueBool bv) = v

evalPat e@(ILPatStr (OfTy p _) s) v =
    unless (vStr == s) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueList cvs) = v
    vStr = map (\(ValueChar c) -> c) cvs

evalPat e@(ILPatChar (OfTy p _) [c]) v =
    unless (cv == c) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueChar cv) = v

evalPat e@(ILPatTuple _ patEs) v =
    if length patEs /= length vs
    then throwError $ ErrPatMatchFail e v
    else do
      let evPairs = zip patEs vs
      mapM_ (uncurry evalPat) evPairs
      return ()
  where
    (ValueTuple vs) = v

evalPat patE@(ILPatAdt (OfTy p _) id patEs) v@(ValueAdt (Adt ctorId _ vs))
    | id == ctorId =
      let evPairs = zip patEs vs
      in do mapM_ (uncurry evalPat) evPairs
            return ()
    | otherwise = throwError (ErrPatMatchFail patE v) `reportErrorAt` p

evalPat e@(ILPatList (OfTy p _) es) v =
    if length es /= length vs
    then throwError (ErrPatMatchFail e v) `reportErrorAt` p
    else do
      let evPairs = zip es vs
      mapM_ (uncurry evalPat) evPairs
      return ()
  where
    (ValueList vs) = v

evalPat e@ILPatCons{} v@(ValueList []) =
  throwError $ ErrPatMatchFail e v

evalPat (ILPatCons _ eHd eTl) (ValueList (v:vs)) = do
  evalPat eHd v
  evalPat eTl $ ValueList vs
  return ()

evalPat (ILPatId _ id) v = do
  bindVar id v
  exportVar id v
  return ()


evalE :: Typed IL -> Eval Value
evalE (ILInt _ i) = return $ ValueInt i
evalE (ILBool _ b) = return $ ValueBool b
evalE (ILStr _ s) = return $ ValueList $ map ValueChar s
evalE (ILChar _ [c]) = return $ ValueChar c
evalE (ILAdd _ a b) = evalBinArith (+) a b
evalE (ILSub _ a b) = evalBinArith (-) a b
evalE (ILDiv _ a b) = evalBinArith quot a b
evalE (ILMul _ a b) = evalBinArith (*) a b

evalE (ILCons _ a b) = do
  vHd <- evalE a
  (ValueList vs) <- evalE b
  return $ ValueList (vHd:vs)

evalE (ILTuple _ es) = do
  vs <- mapM evalE es
  return $ ValueTuple vs

evalE (ILList _ es) = do
  vs <- mapM evalE es
  return $ ValueList vs

evalE (ILMakeAdt _ ty i ctorArgEs) = do
  argVs <- mapM evalE ctorArgEs
  return $ ValueAdt $ Adt ty i argVs

evalE (ILGetAdtField _ e index) = do
  (ValueAdt (Adt _ _ fieldVs)) <- evalE e
  return (fieldVs !! index)

evalE (ILStruct (OfTy _ ty) _ fieldInits) = do
  fieldInitVs <- mapM (\(ILFieldInit id e) -> do { v <- evalE e; return (id, v) }) fieldInits
  return $ ValueStruct $ Struct ty fieldInitVs

evalE (ILFunDef (OfTy p ty) funId paramIds bodyEs) =
  let ef = ILFun (OfTy p ty) paramIds bodyEs
  in do cloEnv <- getClosureEnv
        let f = ValueFun $ Closure funId ty cloEnv paramIds bodyEs
        bindVar funId f
        exportVar funId f
        return ValueUnit

evalE (ILAssign _ patE e) = do
  v <- evalE e
  evalPat patE v
  return ValueUnit

evalE (ILRef (OfTy p _) id) =
  lookupVarId id `reportErrorAt` p

evalE (ILUnit _) = return ValueUnit

evalE (ILBegin _ es) = evalEs es

evalE (ILApp _ e argEs) = do
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

evalE (ILFun (OfTy _ ty) paramIds bodyEs) = do
  cloEnv <- getClosureEnv
  newId <- freshId
  return $ ValueFun $ Closure newId ty cloEnv paramIds bodyEs

evalE switchE@(ILSwitch (OfTy p _) e clauses) = do
  v <- evalE e
  matchResult <- evalCases v clauses
  hoistEither (maybeToEither (ErrNonExhaustivePattern switchE v) matchResult) `reportErrorAt` p

evalE (ILFail (OfTy pos _) msg) =
  throwError $ ErrUserFail pos msg

evalE e = throwError $ ErrCantEvaluate e


evalCases :: Value -> [Typed ILCase] -> Eval (Maybe Value)
evalCases _ [] = return Nothing
evalCases v (ILCase _ patE bodyEs : clauses) = do
  oldEnv <- get
  result <- do { r <- evalPat patE v; return $ Just () } `catchError` (\_ -> return Nothing)
  case result of
    Nothing -> do
      restoreEnv oldEnv
      evalCases v clauses
    Just _ -> do
      retV <- evalEs bodyEs
      return $ Just retV


evalEs :: [Typed IL] -> Eval Value
evalEs [] = return ValueUnit
evalEs [e] = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: Typed ILCompUnit -> Eval Value
eval (ILCompUnit _ es) = evalEs es


interp :: Typed ILCompUnit -> AlphaEnv -> Either Err Value
interp alphaConverted alphaEnv =
  evalState (runExceptT $ eval alphaConverted) $ mtInterpEnv alphaEnv
