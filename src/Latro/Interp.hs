{-# LANGUAGE FlexibleContexts, NamedFieldPuns #-}
module Latro.Interp where

import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Char (ord)
import Data.Either.Utils (maybeToEither)
import Data.List
import qualified Data.Map as Map
import Latro.AlphaConvert hiding (lookup, lookupVarId, reportErrorAt)
import Latro.Common
import Latro.Compiler
import Latro.Errors
import Latro.Output
import Latro.Semant
import Latro.Semant.Display ()
import Prelude hiding (lookup)
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
markValEnv = gets (valEnv . interpEnv)


setValEnv :: VEnv -> Eval ()
setValEnv vEnv = do
  cEnv <- get
  put (cEnv { interpEnv = (interpEnv cEnv) { valEnv = vEnv } })


getVarEnv :: Eval VEnv
getVarEnv = getsInterp valEnv


bindVar :: UniqId -> Value -> Eval ()
bindVar id v =
  modifyInterp (\intEnv -> intEnv { valEnv = Map.insert id v (valEnv intEnv) })


bindThunk :: UniqId -> Typed IL -> Eval ()
bindThunk id il = bindVar id $ ValueThunk il


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


interpPat :: Typed ILPat -> Value -> Eval ()
interpPat (ILPatWildcard _) _ = return ()
interpPat e@(ILPatInt (OfTy p _) ni) v =
    unless (i == ni) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueInt i) = v

interpPat e@(ILPatBool (OfTy p _) b) v =
    unless (bv == b) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueBool bv) = v

interpPat e@(ILPatStr (OfTy p _) s) v =
    unless (vStr == s) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueList cvs) = v
    vStr = map (\(ValueChar c) -> c) cvs

interpPat e@(ILPatChar (OfTy p _) [c]) v =
    unless (cv == c) $ throwError (ErrPatMatchFail e v) `reportErrorAt` p
  where
    (ValueChar cv) = v

interpPat e@(ILPatTuple _ patEs) v =
    if length patEs /= length vs
    then throwError $ ErrPatMatchFail e v
    else do
      let evPairs = zip patEs vs
      mapM_ (uncurry interpPat) evPairs
      return ()
  where
    (ValueTuple vs) = v

interpPat patE@(ILPatAdt (OfTy p _) id patEs) v@(ValueAdt (Adt ctorId _ vs))
    | id == ctorId =
      let evPairs = zip patEs vs
      in do mapM_ (uncurry interpPat) evPairs
            return ()
    | otherwise = throwError (ErrPatMatchFail patE v) `reportErrorAt` p

interpPat e@(ILPatList (OfTy p _) es) v =
    if length es /= length vs
    then throwError (ErrPatMatchFail e v) `reportErrorAt` p
    else do
      let evPairs = zip es vs
      mapM_ (uncurry interpPat) evPairs
      return ()
  where
    (ValueList vs) = v

interpPat e@ILPatCons{} v@(ValueList []) =
  throwError $ ErrPatMatchFail e v

interpPat (ILPatCons _ eHd eTl) (ValueList (v:vs)) = do
  interpPat eHd v
  interpPat eTl $ ValueList vs
  return ()

interpPat (ILPatId _ id) v = do
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


interpPrimApp :: Prim -> [Typed IL] -> Eval Value
interpPrimApp prim argEs = do
  argVs <- mapM interpE argEs
  case prim of
    PrimCharEq -> return $ ValueBool $ c1 == c2
      where [ValueChar c1, ValueChar c2] = argVs
    PrimCharToInt -> return $ ValueInt i
      where [ValueChar c] = argVs
            i = ord c
    PrimIntAdd -> return $ primArith (+) argVs
    PrimIntSub -> return $ primArith (-) argVs
    PrimIntDiv -> return $ primArith quot argVs
    PrimIntMul -> return $ primArith (*) argVs
    PrimIntMod -> return $ primArith mod argVs
    PrimIntEq -> return $ primCmp (==) argVs
    PrimIntLt -> return $ primCmp (<) argVs
    PrimIntLeq -> return $ primCmp (<=) argVs
    PrimIntGt -> return $ primCmp (>) argVs
    PrimIntGeq -> return $ primCmp (>=) argVs
    PrimPrintln -> do liftIO $ (putStrLn . render) $ head argVs
                      return ValueUnit
    PrimReadln -> do line <- liftIO $ getLine
                     return $ ValueList $ map ValueChar line


interpE :: Typed IL -> Eval Value
interpE (ILInt _ i) = return $ ValueInt i
interpE (ILBool _ b) = return $ ValueBool b
interpE (ILStr _ s) = return $ ValueList $ map ValueChar s
interpE (ILChar _ [c]) = return $ ValueChar c

interpE (ILCons _ a b) = do
  vHd <- interpE a
  (ValueList vs) <- interpE b
  return $ ValueList (vHd:vs)

interpE (ILTuple _ es) = do
  vs <- mapM interpE es
  return $ ValueTuple vs

interpE (ILList _ es) = do
  vs <- mapM interpE es
  return $ ValueList vs

interpE (ILMakeAdt _ ty i ctorArgEs) = do
  argVs <- mapM interpE ctorArgEs
  return $ ValueAdt $ Adt ty i argVs

interpE (ILGetAdtField _ e index) = do
  (ValueAdt (Adt _ _ fieldVs)) <- interpE e
  return (fieldVs !! index)

interpE (ILStruct (OfTy _ ty) _ fieldInits) = do
  fieldInitVs <- mapM (\(ILFieldInit id e) -> do { v <- interpE e; return (id, v) }) fieldInits
  return $ ValueStruct $ Struct ty fieldInitVs

interpE (ILFunDef (OfTy p ty) funId paramIds bodyE) =
  let ef = ILFun (OfTy p ty) paramIds bodyE
  in do cloEnv <- getClosureEnv
        let f = ValueFun $ Closure funId ty cloEnv paramIds bodyE
        bindVar funId f
        exportVar funId f
        return ValueUnit

interpE (ILAssign _ patE e) = do
  v <- interpE e
  interpPat patE v
  return ValueUnit

interpE (ILRef (OfTy p _) id) = do
  v <- lookupVarId id `reportErrorAt` p
  case v of
    ValueThunk il -> interpE il
    _             -> return v

interpE (ILUnit _) = return ValueUnit

interpE (ILBegin _ es) = interpEs es

interpE (ILApp _ e argEs) = do
  fv <- interpE e
  case fv of
    ValuePrim prim -> interpPrimApp prim argEs
    ValueFun (Closure fid fTy fenv paramIds bodyE) -> do
      argVs <- mapM interpE argEs

      preApplyInterpEnv <- getInterp
      putInterp (preApplyInterpEnv { valEnv = fenv })

      bindVar fid fv
      let argVTbl = zip paramIds argVs
      mapM_ (uncurry bindVar) argVTbl
      retV <- interpE bodyE

      restoreEnv preApplyInterpEnv
      return retV

interpE (ILPrim _ prim) = return $ ValuePrim prim

interpE (ILFun (OfTy _ ty) paramIds bodyE) = do
  cloEnv <- getClosureEnv
  newId <- freshId
  return $ ValueFun $ Closure newId ty cloEnv paramIds bodyE

interpE switchE@(ILSwitch (OfTy p _) e clauses) = do
  v <- interpE e
  matchResult <- interpCases v clauses
  hoistEither (maybeToEither (ErrNonExhaustivePattern switchE v) matchResult) `reportErrorAt` p

interpE (ILFail (OfTy pos _) msg) =
  throwError $ ErrUserFail pos msg

interpE ilMain@(ILMain (OfTy pos _) _ _) = do
  maybeEntry <- getsInterp entrypoint
  case maybeEntry of
    Nothing -> do modifyInterp (\interpEnv -> interpEnv { entrypoint = Just ilMain })
                  return ValueUnit
    Just (ILMain (OfTy exPos _) _ _) ->
      throwError (ErrMainAlreadyDefined exPos) `reportErrorAt` pos

interpE e = throwError $ ErrCantEvaluate e


interpCases :: Value -> [Typed ILCase] -> Eval (Maybe Value)
interpCases _ [] = return Nothing
interpCases v (ILCase _ patE bodyE : clauses) = do
  oldEnv <- getInterp
  result <- do { r <- interpPat patE v; return $ Just () } `catchError` (\_ -> return Nothing)
  case result of
    Nothing -> do
      restoreEnv oldEnv
      interpCases v clauses
    Just _ -> do
      retV <- interpE bodyE
      return $ Just retV


interpEs :: [Typed IL] -> Eval Value
interpEs [] = return ValueUnit
interpEs [e] = interpE e
interpEs es = do
  vs <- mapM interpE es
  return $ last vs


buildEnvForPat :: Typed ILPat -> Typed IL -> Eval ()
buildEnvForPat patE e = return ()


buildEnv :: Typed IL -> Eval ()
buildEnv (ILAssign _ (ILPatId _ id) il) = bindThunk id il
buildEnv (ILAssign _ ilPat il) = return ()
buildEnv funDef@ILFunDef{} = interpE funDef >> return ()
buildEnv (ILBegin _ bodyEs) = mapM_ buildEnv bodyEs

buildEnv _ = return ()


interp :: Typed ILCompUnit -> Bool -> Eval Value
interp (ILCompUnit _ _ es) runMain = do
  mapM_ buildEnv es
  v <- interpEs es
  if runMain
  then do
    maybeEntry <- getsInterp entrypoint
    case maybeEntry of
      Nothing -> throwError ErrMainUndefined `reportErrorAt` mtSourcePos
      Just (ILMain _ [paramId] bodyE) -> do
        preInterpEnv <- getInterp
        bindVar paramId $ ValueList []
        retV <- interpE bodyE
        restoreEnv preInterpEnv

        return retV
  else return v


type Eval a = CompilerPassT CompilerEnv IO a


getInterp :: Eval InterpEnv
getInterp = gets interpEnv


getsInterp :: (InterpEnv -> a) -> Eval a
getsInterp f = gets (f . interpEnv)


putInterp :: InterpEnv -> Eval ()
putInterp intEnv = modifyInterp $ const intEnv


modifyInterp :: (InterpEnv -> InterpEnv) -> Eval ()
modifyInterp f = modify (\cEnv -> cEnv { interpEnv = f (interpEnv cEnv) })
