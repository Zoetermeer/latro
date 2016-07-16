{-# LANGUAGE FlexibleContexts, NamedFieldPuns #-}
module Interp where

import AlphaConvert hiding (lookup, lookupVarId, reportErrorAt)
import Common
import Compiler
import Control.Error.Util (hoistEither)
import Control.Monad (unless)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.List
import qualified Data.Map as Map
import Data.Maybe (fromJust, isJust)
import Data.Monoid ((<>), mempty)
import Errors
import Parse
import Prelude hiding (lookup)
import Semant
import Semant.Display
import Text.Printf (printf)


reportErrorAt a = reportPosOnFail a "Interp"


lookupId :: UniqId -> Map.Map UniqId v -> Eval v
lookupId id map =
    hoistEither eithV
  where
    eithV = maybeToEither err $ Map.lookup id map
    err = ErrUnboundUniqIdentifier id


lookupVarId :: UniqId -> Eval Value
lookupVarId id = getVarEnv >>= lookupId id


markValEnv :: Eval VEnv
markValEnv = gets (\cEnv -> valEnv $ interpEnv cEnv)


setValEnv :: VEnv -> Eval ()
setValEnv vEnv = do
  cEnv <- get
  put (cEnv { interpEnv = (interpEnv cEnv) { valEnv = vEnv } })


getVarEnv :: Eval VEnv
getVarEnv = getsInterp valEnv


bindVar :: UniqId -> Value -> Eval ()
bindVar id v =
  modifyInterp (\intEnv -> intEnv { valEnv = Map.insert id v (valEnv intEnv) })


exportVar :: UniqId -> Value -> Eval ()
exportVar id v =
  modifyInterp
    (\intEnv ->
        let (Module cloEnv paramIds exports) = curMod intEnv
            exports' = exports { exportVars = Map.insert id v (exportVars exports) }
        in
          intEnv { curMod = Module cloEnv paramIds exports' })


getClosureEnv :: Eval VEnv
getClosureEnv = getsInterp valEnv


restoreEnv :: InterpEnv -> Eval ()
restoreEnv = putInterp


freshId :: Eval UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let index = nextIdIndex alphaEnv
  let (uniqId, alphaEnv') = freshVarId True (UserId (printf "%s%i" "x" index)) alphaEnv
  modify (\cEnv -> cEnv { alphaEnv = alphaEnv' })
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


primArith :: (Int -> Int -> Int) -> [Value] -> Value
primArith op [ValueInt x, ValueInt y] = ValueInt $ x `op` y


primCmp :: (Int -> Int -> Bool) -> [Value] -> Value
primCmp op [ValueInt x, ValueInt y] = ValueBool $ x `op` y


printV :: IO () -> Eval Value
printV act = do
  _ <- liftIO act
  return ValueUnit


evalPrimApp :: Prim -> [Typed IL] -> Eval Value
evalPrimApp prim argEs = do
  argVs <- mapM evalE argEs
  case prim of
    PrimIntAdd -> return $ primArith (+) argVs
    PrimIntSub -> return $ primArith (-) argVs
    PrimIntDiv -> return $ primArith (quot) argVs
    PrimIntMul -> return $ primArith (*) argVs
    PrimIntEq -> return $ primCmp (==) argVs
    PrimIntLt -> return $ primCmp (<) argVs
    PrimIntLeq -> return $ primCmp (<=) argVs
    PrimIntGt -> return $ primCmp (>) argVs
    PrimIntGeq -> return $ primCmp (>=) argVs
    PrimPrintln -> do liftIO $ putStrLn $ show $ head argVs
                      return ValueUnit


evalE :: Typed IL -> Eval Value
evalE (ILInt _ i) = return $ ValueInt i
evalE (ILBool _ b) = return $ ValueBool b
evalE (ILStr _ s) = return $ ValueList $ map ValueChar s
evalE (ILChar _ [c]) = return $ ValueChar c

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
  fv <- evalE e
  case fv of
    ValuePrim prim -> evalPrimApp prim argEs
    ValueFun (Closure fid fTy fenv paramIds bodyEs) -> do
      argVs <- mapM evalE argEs

      -- preApplyInterpEnv <- get
      -- put (preApplyInterpEnv { valEnv = fenv })
      preApplyInterpEnv <- getInterp
      putInterp (preApplyInterpEnv { valEnv = fenv })

      bindVar fid fv
      let argVTbl = zip paramIds argVs
      mapM_ (uncurry bindVar) argVTbl
      retV <- evalEs bodyEs

      restoreEnv preApplyInterpEnv
      return retV

evalE (ILPrim _ prim) = return $ ValuePrim prim

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
  oldEnv <- getInterp
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


type Eval a = CompilerPassT CompilerEnv IO a


getInterp :: Eval InterpEnv
getInterp = gets interpEnv


getsInterp :: (InterpEnv -> a) -> Eval a
getsInterp f = gets (\cEnv -> f $ interpEnv cEnv)


putInterp :: InterpEnv -> Eval ()
putInterp intEnv = modifyInterp $ const intEnv


modifyInterp :: (InterpEnv -> InterpEnv) -> Eval ()
modifyInterp f = modify (\cEnv -> cEnv { interpEnv = f (interpEnv cEnv) })


runInterp :: Typed ILCompUnit -> Eval Value
runInterp cu = eval cu
