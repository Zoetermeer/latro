module ILGen where

import Compiler
import Data.Char (toLower)
import Semant


ilGenClause :: Show a => CaseClause a UniqId -> ILCase a
ilGenClause (CaseClause p patE bodyEs) =
  ILCase p (ilGenPat patE) (map ilGen bodyEs)


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


ilGenFieldInit :: Show a => FieldInit a UniqId -> ILFieldInit a
ilGenFieldInit (FieldInit p e) = ILFieldInit p $ ilGen e

ilGenPrim :: UniqId -> Prim
ilGenPrim (UserId id) =
  case map toLower id of
    "println" -> PrimPrintln
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

ilGen :: Show a => Exp a UniqId -> IL a
ilGen e =
  case e of
    ExpCons p l r -> ILCons p (ilGen l) (ilGen r)
    ExpInParens p e -> ilGen e
    ExpMemberAccess p e id ->
      ILApp p (ILRef p id) [ilGen e]
    ExpApp p rator rands ->
      ILApp p (ilGen rator) (map ilGen rands)
    ExpPrim p ratorId ->
      ILPrim p $ ilGenPrim ratorId
    ExpAssign p patE e ->
      ILAssign p (ilGenPat patE) (ilGen e)
    ExpTypeDec p typeDec ->
      ILTypeDec p typeDec
    ExpWithAnn tyAnn e ->
      ILWithAnn (nodeData tyAnn) tyAnn $ ilGen e
    ExpFunDef (FunDefFun p fid@(UniqId _ fName) argPatEs bodyEs) ->
      let argIds = map (\(PatExpId _ id) -> id) argPatEs
          bodyIL = map ilGen bodyEs
      in if fName == "main"
         then ILMain p argIds bodyIL
         else ILFunDef p fid argIds bodyIL
    ExpFunDef (FunDefInstFun p instPatE fid argPatEs bodyEs) ->
      let (PatExpId _ instId) = instPatE
          argIds = map (\(PatExpId _ id) -> id) argPatEs
      in ILInstFunDef p instId fid argIds $ map ilGen bodyEs
    ExpStruct p (Id _ uid) fieldInits ->
      ILStruct p uid $ map ilGenFieldInit fieldInits
    ExpIfElse p e thenEs elseEs ->
      ILSwitch p
               (ilGen e)
               [ ILCase p (ILPatBool p True) (map ilGen thenEs)
               , ILCase p (ILPatBool p False) (map ilGen elseEs)
               ]
    ExpMakeAdt p id i argEs ->
      ILMakeAdt p id i $ map ilGen argEs
    ExpGetAdtField p e i ->
      ILGetAdtField p (ilGen e) i
    ExpTuple p argEs ->
      ILTuple p $ map ilGen argEs
    ExpSwitch p e clauses ->
      ILSwitch p (ilGen e) (map ilGenClause clauses)
    ExpList p argEs ->
      ILList p $ map ilGen argEs
    ExpFun p argPatEs bodyEs ->
      let argIds = map (\(PatExpId _ id) -> id) argPatEs
      in ILFun p argIds $ map ilGen bodyEs
    ExpNum p s -> ILInt p $ read s
    ExpBool p b -> ILBool p b
    ExpString p s -> ILStr p s
    ExpChar p s -> ILChar p s
    ExpRef p id -> ILRef p id
    ExpUnit p -> ILUnit p
    ExpBegin p es -> ILBegin p $ map ilGen es
    ExpFail p msg -> ILFail p msg
    e -> error $ show e


type ILGenM a = CompilerPass CompilerEnv a


runILGen :: UniqAst CompUnit -> ILGenM (Untyped ILCompUnit)
runILGen (CompUnit p es) = return $ ILCompUnit p $ map ilGen es
