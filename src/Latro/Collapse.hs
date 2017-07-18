{-|
Module      : Collapse
Description : Collapses all multi-clause functions into single-body ones
-}
module Latro.Collapse where

import Control.Monad.Except
import Latro.Ast
import Latro.Compiler
import Latro.Errors


collectFunDefs :: RawId -> [RawAst Exp] -> ([RawAst FunDef], [RawAst Exp])
collectFunDefs _ [] = ([], [])
collectFunDefs id (eFunDef@(ExpFunDef funDef@(FunDefFun _ fid _ _)) : es)
  | id == fid =
    let (funDefs, es') = collectFunDefs id es
    in (funDef : funDefs, es')
  | otherwise = ([], eFunDef : es)

collectFunDefs _ es = ([], es)


collapseBindingExp :: RawId -> [RawAst Exp] -> Collapsed (RawAst Exp, [RawAst Exp])
collapseBindingExp id (e@(ExpTopLevelAssign _ (PatExpId _ pid) _) : es)
  | id == pid = return (e, es)
  | otherwise = throwError $ ErrNoBindingAfterTyAnn id

collapseBindingExp id (e@(ExpAssign _ (PatExpId _ pid) _) : es)
  | id == pid = return (e, es)
  | otherwise = throwError $ ErrNoBindingAfterTyAnn id

collapseBindingExp id (e@(ExpFunDef (FunDefFun p fid _ _)) : es)
  | id == fid = do
      let (funDefs, es') = collectFunDefs fid (e : es)
      eFunDef <- collapse $ ExpFunDefClauses p fid funDefs
      case funDefs of
        [] -> throwError $ ErrNoBindingAfterTyAnn fid
        _  -> return (eFunDef, es')
  | otherwise = throwError $ ErrNoBindingAfterTyAnn id

collapseBindingExp id _ = throwError $ ErrNoBindingAfterTyAnn id


collapse :: RawAst Exp -> Collapsed (RawAst Exp)
collapse (ExpAssign p patE e) = do
  e' <- collapse e
  return $ ExpAssign p patE e'

collapse (ExpFunDef (FunDefFun p id argPatEs bodyE)) = do
  bodyE' <- collapse bodyE
  return $ ExpFunDef $ FunDefFun p id argPatEs bodyE'

collapse (ExpModule p id bodyEs) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpModule p id bodyEs'

collapse (ExpBegin p bodyEs) = do
  bodyEs' <- collapseEs bodyEs
  return $ ExpBegin p bodyEs'

collapse (ExpFunDefClauses ap aid funDefs) = do
  funDefs' <- mapM collapseFunDef funDefs
  return $ ExpFunDefClauses ap aid funDefs'

collapse e = return e


collapseFunDef :: RawAst FunDef -> Collapsed (RawAst FunDef)
collapseFunDef (FunDefFun p id patE bodyE) = do
  bodyE' <- collapse bodyE
  return $ FunDefFun p id patE bodyE'


collapseEs :: [RawAst Exp] -> Collapsed [RawAst Exp]
collapseEs [] = return []
collapseEs (ExpTopLevelTyAnn tyAnn@(TyAnn _ aid _ _ _) : es) = do
  (e, es') <- collapseBindingExp aid es
  es'' <- collapseEs es'
  return (ExpWithAnn tyAnn e : es'')

collapseEs (ExpTyAnn tyAnn@(TyAnn _ aid _ _ _) : es) = do
  (e, es') <- collapseBindingExp aid es
  es'' <- collapseEs es'
  return (ExpWithAnn tyAnn e : es'')

collapseEs (ExpFunDef (FunDefFun p fid argPatEs bodyE) : es) = do
  bodyE' <- collapse bodyE
  let (funDefs, es') = collectFunDefs fid es
      funDef = FunDefFun p fid argPatEs bodyE'
      eFunDef = ExpFunDefClauses p fid (funDef : funDefs)
  es'' <- collapseEs es'
  return (eFunDef : es'')

collapseEs (ExpBegin p bodyEs : es) = do
  bodyEs' <- collapseEs bodyEs
  es' <- collapseEs es
  return (ExpBegin p bodyEs' : es')

collapseEs (ExpProtoImp p synTy protoId straints bodyEs : es) = do
  bodyEs' <- collapseEs bodyEs
  es' <- collapseEs es
  return (ExpProtoImp p synTy protoId straints bodyEs' : es')

collapseEs (e : es) = do
  e' <- collapse e
  es' <- collapseEs es
  return (e' : es')


type Collapsed a = CompilerPass CompilerEnv a


runCollapseFunClauses :: RawAst CompUnit -> Collapsed (RawAst CompUnit)
runCollapseFunClauses (CompUnit pos exps) = do
  exps' <- collapseEs exps
  return $ CompUnit pos exps'
