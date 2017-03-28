module Latro.ILGen where

import Data.Char (toLower)
import Latro.Compiler
import Latro.Semant


ilGenClause :: Show a => CaseClause a UniqId -> ILCase a
ilGenClause (CaseClause p patE bodyE) =
  ILCase p (ilGenPat patE) (ilGen bodyE)


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
    ExpProtoDec p protoId tyParamId constrs tyAnns ->
      ILProtoDec p protoId tyParamId constrs tyAnns
    ExpProtoImp p typeTy protoId constrs bodyEs ->
      ILProtoImp p typeTy protoId constrs $ map ilGen bodyEs
    ExpWithAnn tyAnn e ->
      ILWithAnn (nodeData tyAnn) tyAnn $ ilGen e
    ExpFunDef (FunDefFun p fid@(UniqId _ fName) argPatEs bodyE) ->
      let argIds = map (\(PatExpId _ id) -> id) argPatEs
          bodyIL = ilGen bodyE
      in if fName == "main"
         then ILMain p argIds bodyIL
         else ILFunDef p fid argIds bodyIL
    ExpFunDef (FunDefInstFun p instPatE fid argPatEs bodyE) ->
      let (PatExpId _ instId) = instPatE
          argIds = map (\(PatExpId _ id) -> id) argPatEs
      in ILInstFunDef p instId fid argIds $ ilGen bodyE
    ExpStruct p (Id _ uid) fieldInits ->
      ILStruct p uid $ map ilGenFieldInit fieldInits
    ExpIfElse p e thenE elseE ->
      ILSwitch p
               (ilGen e)
               [ ILCase p (ILPatBool p True) (ilGen thenE)
               , ILCase p (ILPatBool p False) (ilGen elseE)
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
    ExpFun p argPatEs bodyE ->
      let argIds = map (\(PatExpId _ id) -> id) argPatEs
      in ILFun p argIds $ ilGen bodyE
    ExpNum p s -> ILInt p $ read s
    ExpBool p b -> ILBool p b
    ExpString p s -> ILStr p s
    ExpChar p s -> ILChar p s
    ExpRef p id -> ILRef p id
    ExpUnit p -> ILUnit p
    ExpBegin p es -> ILBegin p $ map ilGen es
    ExpFail p msg -> ILFail p msg
    e -> error ("Could not generate IL for expression: " ++ show e)


type ILGenM a = CompilerPass CompilerEnv a


runILGen :: UniqAst CompUnit -> ILGenM (Untyped ILCompUnit)
runILGen (CompUnit p es) = return $ ILCompUnit p $ map ilGen es
