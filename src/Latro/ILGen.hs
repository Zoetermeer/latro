module Latro.ILGen where

import Control.Monad.Writer
import Data.Char (toLower)
import Latro.Compiler
import Latro.Semant


ilGenClause :: Show a => CaseClause a UniqId -> ILWriter ILCase a
ilGenClause (CaseClause p patE bodyE) = do
  bodyE' <- ilGen bodyE
  return $ ILCase p (ilGenPat patE) bodyE'


ilGenPat :: PatExp a UniqId -> ILPat a
ilGenPat patE =
  case patE of
    PatExpNumLiteral p s ->
      ILPatInt p $ read s
    PatExpBoolLiteral p b ->
      ILPatBool p b
    PatExpStringLiteral p s ->
      ILPatStr p s
    PatExpCharLiteral p s ->
      ILPatChar p s
    PatExpTuple p patEs ->
      ILPatTuple p $ map ilGenPat patEs
    PatExpAdt p (Id _ uid) patEs ->
      ILPatAdt p uid $ map ilGenPat patEs
    PatExpList p patEs ->
      ILPatList p $ map ilGenPat patEs
    PatExpListCons p patHd patTl ->
      ILPatCons p (ilGenPat patHd) (ilGenPat patTl)
    PatExpId p id -> ILPatId p id
    PatExpWildcard p -> ILPatWildcard p


ilGenFieldInit :: Show a => FieldInit a UniqId -> ILWriter ILFieldInit a
ilGenFieldInit (FieldInit p e) = do
  e' <- ilGen e
  return $ ILFieldInit p e'


ilGenPrim :: UniqId -> Prim
ilGenPrim (UserId id) =
  case map toLower id of
    "println" -> PrimPrintln
    "readln" -> PrimReadln
    "chareq" -> PrimCharEq
    "chartoint" -> PrimCharToInt
    "intadd" -> PrimIntAdd
    "intsub" -> PrimIntSub
    "intdiv" -> PrimIntDiv
    "intmul" -> PrimIntMul
    "intmod" -> PrimIntMod
    "inteq" -> PrimIntEq
    "intlt" -> PrimIntLt
    "intleq" -> PrimIntLeq
    "intgt" -> PrimIntGt
    "intgeq" -> PrimIntGeq
    _ -> PrimUnknown id

ilGen :: Show a => Exp a UniqId -> ILWriter IL a
ilGen (ExpTypeDec p tyDec) = do
  tell [tyDec]
  return $ ILBegin p []

ilGen (ExpCons p l r) = do
  hd <- ilGen l
  tl <- ilGen r
  return $ ILCons p hd tl

ilGen (ExpInParens _ e) = ilGen e
ilGen (ExpMemberAccess p e id) = do
  e' <- ilGen e
  return $ ILApp p (ILRef p id) [e']

ilGen (ExpApp p rator rands) = do
  rator' <- ilGen rator
  rands' <- mapM ilGen rands
  return $ ILApp p rator' rands'

ilGen (ExpPrim p ratorId) = return $ ILPrim p $ ilGenPrim ratorId

ilGen (ExpAssign p patE e) = do
  e' <- ilGen e
  return $ ILAssign p (ilGenPat patE) e'

ilGen (ExpTopLevelAssign p patE e) = do
  e' <- ilGen e
  return $ ILAssign p (ilGenPat patE) e'

ilGen (ExpWithAnn tyAnn e) = do
  e' <- ilGen e
  return $ ILWithAnn (nodeData tyAnn) tyAnn $ e'

ilGen (ExpFunDef (FunDefFun p fid@(UniqId _ fName) argPatEs bodyE)) = do
    bodyE' <- ilGen bodyE
    return $ if fName == "main"
             then ILMain p argIds bodyE'
             else ILFunDef p fid argIds bodyE'
  where
    argIds = map assumeIdPat argPatEs

ilGen (ExpStruct p (Id _ uid) fieldInits) = do
  fieldInits' <- mapM ilGenFieldInit fieldInits
  return $ ILStruct p uid fieldInits'

ilGen (ExpIfElse p e thenE elseE) = do
  e' <- ilGen e
  thenE' <- ilGen thenE
  elseE' <- ilGen elseE
  return $ ILSwitch p
                    e'
                    [ ILCase p (ILPatBool p True) thenE'
                    , ILCase p (ILPatBool p False) elseE'
                    ]

ilGen (ExpMakeAdt p id i argEs) = do
  argEs' <- mapM ilGen argEs
  return $ ILMakeAdt p id i argEs'

ilGen (ExpGetAdtField p e i) = do
  e' <- ilGen e
  return $ ILGetAdtField p e' i

ilGen (ExpTuple p argEs) = do
  argEs' <- mapM ilGen argEs
  return $ ILTuple p argEs'

ilGen (ExpSwitch p e clauses) = do
  e' <- ilGen e
  clauses' <- mapM ilGenClause clauses
  return $ ILSwitch p e' clauses'

ilGen (ExpList p argEs) = do
  argEs' <- mapM ilGen argEs
  return $ ILList p argEs'

ilGen (ExpFun p argPatEs bodyE) = do
    bodyE' <- ilGen bodyE
    return $ ILFun p argIds bodyE'
  where
    argIds = map assumeIdPat argPatEs

ilGen (ExpNum p s) = return $ ILInt p $ read s
ilGen (ExpBool p b) = return $ ILBool p b
ilGen (ExpString p s) = return $ ILStr p s
ilGen (ExpChar p s) = return $ ILChar p s
ilGen (ExpRef p id) = return $ ILRef p id
ilGen (ExpUnit p) = return $ ILUnit p
ilGen (ExpBegin p es) = do
  es' <- mapM ilGen es
  return $ ILBegin p es'

ilGen (ExpFail p msg) = return $ ILFail p msg
ilGen e = error ("Could not generate IL for expression: " ++ show e)


ilGenEs :: Show a => [Exp a UniqId] -> Writer [TypeDec a UniqId] [IL a]
ilGenEs es = mapM ilGen es


type ILWriter t a = Writer [TypeDec a UniqId] (t a)
type ILGenM a = CompilerPass CompilerEnv a


runILGen :: UniqAst CompUnit -> ILGenM (Untyped ILCompUnit)
runILGen (CompUnit p es) =
  let (il, tyDecs) = runWriter $ ilGenEs es in
  return $ ILCompUnit p tyDecs il
