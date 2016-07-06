{-|
Module      : Collapse
Description : Collapses all multi-clause functions into single-body ones
-}
module Collapse where

import Common
import Control.Monad.Except
import Errors
import Semant

collectFunDefs :: RawId -> [RawAst Exp] -> ([RawAst FunDef], [RawAst Exp])
collectFunDefs _ [] = ([], [])
collectFunDefs id (eFunDef@(ExpFunDef funDef@(FunDefFun _ fid _ _)) : es)
  | id == fid =
    let (funDefs, es') = collectFunDefs id es
    in (funDef : funDefs, es')
  | otherwise = ([], eFunDef : es)

collectFunDefs _ es = ([], es)


collectInstFunDefs :: RawId -> [RawAst Exp] -> ([RawAst FunDef], [RawAst Exp])
collectInstFunDefs _ [] = ([], [])
collectInstFunDefs id (eFunDef@(ExpFunDef funDef@(FunDefInstFun _ _ fid _ _)) : es)
  | id == fid =
    let (funDefs, es') = collectInstFunDefs id es
    in (funDef : funDefs, es')
  | otherwise = ([], eFunDef : es)

collectInstFunDefs _ es = ([], es)


collapseBindingExp :: RawId -> [RawAst Exp] -> Either Err (RawAst Exp, [RawAst Exp])
collapseBindingExp id (e@(ExpAssign _ (PatExpId _ pid) _) : es)
  | id == pid = return (e, es)
  | otherwise = throwError $ ErrNoBindingAfterTyAnn id

collapseBindingExp id _ = throwError $ ErrNoBindingAfterTyAnn id


collapse :: RawAst Exp -> Either Err (RawAst Exp)
collapse (ExpAssign p patE e) = do
  e' <- collapse e
  return $ ExpAssign p patE e'

collapse (ExpFunDef (FunDefFun p id argPatEs bodyEs)) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpFunDef $ FunDefFun p id argPatEs bodyEs'

collapse (ExpModule p paramIds bodyEs) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpModule p paramIds bodyEs'

collapse e = return e


collapseEs :: [RawAst Exp] -> Either Err [RawAst Exp]
collapseEs [] = return []
collapseEs (ExpTyAnn tyAnn@(TyAnn ap aid _ synTy) : es) =
  case synTy of
    SynTyArrow {} ->
      let (funDefs, es') = collectFunDefs aid es
          eFunDef = ExpFunDefClauses ap aid funDefs
      in if null funDefs
           then throwError $ ErrNoBindingAfterTyAnn aid
           else do es'' <- collapseEs es'
                   return (ExpWithAnn tyAnn eFunDef : es'')
    _ ->
      do (e, es') <- collapseBindingExp aid es
         es'' <- collapseEs es'
         return (ExpWithAnn tyAnn e : es'')

collapseEs (ExpFunDef (FunDefFun p fid argPatEs bodyEs) : es) = do
  bodyEs' <- collapseEs bodyEs
  let (funDefs, es') = collectFunDefs fid es
      funDef = FunDefFun p fid argPatEs bodyEs'
      eFunDef = ExpFunDefClauses p fid (funDef : funDefs)
  es'' <- collapseEs es'
  return (eFunDef : es'')

collapseEs (ExpFunDef (FunDefInstFun p instPatE fid argPatEs bodyEs) : es) = do
  bodyEs' <- collapseEs bodyEs
  let (funDefs, es') = collectInstFunDefs fid es
      funDef = FunDefInstFun p instPatE fid argPatEs bodyEs'
      eFunDef = ExpFunDefClauses p fid (funDef : funDefs)
  es'' <- collapseEs es'
  return (eFunDef : es'')

collapseEs (e : es) = do
  e' <- collapse e
  es' <- collapseEs es
  return (e' : es')
