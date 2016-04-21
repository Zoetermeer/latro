{

module Parse where

import Control.Monad.Except
import Data.Bifunctor (first)
import Errors
import Lex
import Semant

}

%tokentype { Token }
%monad { Alex }
%lexer { lexwrap } { Token _ TokenEOF }
%error { happyError }

%token
  module { Token _ TokenModule }
  import { Token _ TokenImport }
  type { Token _ TokenType }
  interface { Token _ TokenInterface }
  default { Token _ TokenDefault }
  fun { Token _ TokenFun }
  imp { Token _ TokenImp }
  test { Token _ TokenTest }
  struct { Token _ TokenStruct }
  def { Token _ TokenDef }
  True { Token _ TokenTrue }
  False { Token _ TokenFalse }
  Int { Token _ TokenInt }
  Bool { Token _ TokenBool }
  String { Token _ TokenStringTy }
  Unit { Token _ TokenUnit }
  if { Token _ TokenIf }
  else { Token _ TokenElse }
  switch { Token _ TokenSwitch }
  case { Token _ TokenCase }
  ':=' { Token _ TokenAssign }
  '->' { Token _ TokenArrow }
  '=>' { Token _ TokenRocket }
  '::' { Token _ TokenCons }
  '[' { Token _ TokenLBracket }
  ']' { Token _ TokenRBracket }
  '{' { Token _ TokenLBrace }
  '}' { Token _ TokenRBrace }
  '(' { Token _ TokenLParen }
  ')' { Token _ TokenRParen }
  '<' { Token _ TokenLt }
  '>' { Token _ TokenGt }
  '|' { Token _ TokenPipe }
  '+' { Token _ TokenPlus }
  '-' { Token _ TokenMinus }
  '*' { Token _ TokenStar }
  '/' { Token _ TokenFSlash }
  '!' { Token _ TokenExclamation }
  ';' { Token _ TokenSemi }
  '.' { Token _ TokenDot }
  '=' { Token _ TokenEq }
  ':' { Token _ TokenColon }
  ',' { Token _ TokenComma }
  '_' { Token _ TokenUnderscore }
  num { Token _ (TokenNumLit $$) }
  id  { Token _ (TokenId $$) }
  string { Token _ (TokenString $$) }

%name parse

%%

CompUnit : OneOrMoreModuleLevelExps { CompUnit $1 }

OneOrMoreExps : ExpT { [$1] }
              | OneOrMoreExps ExpT { $1 ++ [$2] }

ZeroOrMoreExps : ExpT { [$1] }
               | OneOrMoreExps ExpT { $1 ++ [$2] }
               | {- empty -} { [] }

ZeroOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                          | ZeroOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }
                          | {- empty -} { [] }

OneOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                         | OneOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }

ExpT : Exp ';'  { $1 }

TupleRestExps : ',' Exp { [$2] }
              | TupleRestExps ',' Exp { $1 ++ [$3] }

LiteralPatExp : num { PatExpNumLiteral $1 }
              | True { PatExpBoolLiteral True }
              | False { PatExpBoolLiteral False }

TuplePatExpsRest : ',' PatExp { [$2] }
                 | TuplePatExpsRest ',' PatExp { $1 ++ [$3] }

TuplePatExp : '(' PatExp TuplePatExpsRest ')' { PatExpTuple ([$2] ++ $3) }

AdtPatExp : id '(' ZeroOrMorePatExps ')' { PatExpAdt $1 $3 }

ZeroOrMorePatExps : PatExp { [$1] }
                  | ZeroOrMorePatExps ',' PatExp { $1 ++ [$3] }
                  | {- empty -} { [] }

OneOrMorePatExps : PatExp { [$1] }
                 | OneOrMorePatExps ',' PatExp { $1 ++ [$3] }
                 | {- empty -} { [] }

AtomPatExp : '(' PatExp ')' { $2 }
           | LiteralPatExp { $1 }
           | TuplePatExp { $1 }
           | AdtPatExp { $1 }
           | id { PatExpId $1 }
           | '_' { PatExpWildcard }

ListPatExp : AtomPatExp '::' ListPatExp { PatExpListCons $1 $3 }
           | '[' ZeroOrMorePatExps ']' { PatExpList $2 }
           | AtomPatExp { $1 }

PatExp : ListPatExp { $1 }

CommaSeparatedExps : Exp { [$1] }
                   | CommaSeparatedExps ',' Exp { $1 ++ [$3] }
                   | {- empty -} { [] }

ListExp : '[' CommaSeparatedExps ']' { ExpList $2 }

CommaSeparatedIds : id { [$1] }
                  | CommaSeparatedIds ',' id { $1 ++ [$3] }
                  | {- empty -} { [] }

ModuleParamList : '(' ')' { [] }
                | '(' CommaSeparatedIds ')' { $2 }
                | {- empty -} { [] }

ModuleExp : module ModuleParamList '{' ZeroOrMoreModuleLevelExps'}'  { ExpModule $2 $4 }

AtomExp : '(' Exp ')' { $2 }
        | ModuleExp { $1 }
        | '(' ')' { ExpUnit }
        | '(' Exp TupleRestExps ')' { ExpTuple ($2:$3) }
        | ListExp { $1 }
        | fun '(' CommaSeparatedIds ')' '{' ZeroOrMoreExps '}' { ExpFun $3 $6 }
        | num { ExpNum $1 }
        | True { ExpBool True }
        | False { ExpBool False }
        | string { ExpString $1 }
        | id  { ExpRef $1 }

MemberAccessExp : AppExp '.' id { ExpMemberAccess $1 $3 }
                | AtomExp { $1 }

AppExp : AppExp '(' ArgExps ')' { ExpApp $1 $3 }
       | MemberAccessExp { $1 }

MulExp : MulExp '*' AppExp { ExpMul $1 $3 }
       | AppExp { $1 }

DivExp : DivExp '/' MulExp { ExpDiv $1 $3 }
       | MulExp { $1 }

AddExp : AddExp '+' DivExp { ExpAdd $1 $3 }
       | DivExp { $1 }

SubExp : SubExp '-' AddExp { ExpSub $1 $3 }
       | AddExp { $1 }

ConsExp : SubExp '::' ConsExp { ExpCons $1 $3 }
        | SubExp { $1 }

Exp : '!' ConsExp { ExpNot $2 }
    | ConsExp { $1 }
    | import QualifiedId { ExpImport $2 }
    | def PatExp '=' Exp { ExpAssign $2 $4 }
    | MemberAccessExp '{' StructFieldInitializers '}' { ExpStruct $1 $3 }
    | TypeDec { ExpTypeDec $1 }
    | if '(' Exp ')' '{' ZeroOrMoreExps '}' else '{' ZeroOrMoreExps '}' { ExpIfElse $3 $6 $10 }
    | switch '(' Exp ')' '{' CaseClauses '}' { ExpSwitch $3 $6 }

AnnDefExp : id '=' ModuleExp { AnnDefModule $1 $3 }
          | FunDef { AnnDefFun $1 }

AnnDefs : AnnDefExp { [$1] }
        | AnnDefs AnnDefExp { $1 ++ [$2] }

TyParams : '<' CommaSeparatedIds '>' { $2 }
         | {- empty -} { [] }

AnnDecExp : id TyParams '=>' Ty ';' AnnDefs ';' { ExpAnnDec $1 $2 $4 $6 }

TyAnn : id TyParams '=>' Ty ';' { TyAnn $1 $2 $4 }


TyAnns : TyAnn { [$1] }
       | TyAnns TyAnn { $1 ++ [$2] }

InterfaceDecExp: interface id TyParams '{' TyAnns '}' { ExpInterfaceDec $2 $3 $5 }

ModuleLevelExp : AnnDecExp { $1 }
               | InterfaceDecExp ';' { $1 }
               | ExpT { $1 }

CaseClauses : CaseClause { [$1] }
            | CaseClauses CaseClause { $1 ++ [$2] }

CaseClause : case PatExp '->' OneOrMoreExps { CaseClause $2 $4 }

ArgExps : Exp { [$1] }
        | ArgExps ',' Exp { $1 ++ [$3] }
        | {- empty -} { [] }

FunParams : id { [$1] }
          | FunParams ',' id { $1 ++ [$3] }
          | {- empty -} { [] }

TypeDec : type id '=' Ty { TypeDecTy $2 $4 }
        | type id '=' AdtAlternatives { TypeDecAdt $2 $4 }

AdtAlternatives : AdtAlternative  { [$1] }
                | AdtAlternatives AdtAlternative  { $1 ++ [$2] }

AdtAlternative : '|' id Tys { AdtAlternative $2 0 $3 }

Tys : Ty { [$1] }
    | Tys Ty { $1 ++ [$2] }
    | {- empty -} { [] }

FunDec : fun '(' Ty ')' id '(' CommaSeparatedTys ')' ':' Ty ';' FunDefs { FunDecInstFun $5 $3 (SynTyArrow $7 $10) $12 }
       | fun id '(' CommaSeparatedTys ')' ':' Ty ';' FunDefs { FunDecFun $2 (SynTyArrow $4 $7) $9 }

FunDefs : FunDef  { [$1] }
        | FunDefs FunDef { $1 ++ [$2] }

FunDef : InstancePat id '(' PatExpList ')' '{' OneOrMoreExps '}' { FunDefInstFun $1 $2 $4 $7 }
       | id '(' PatExpList ')' '{' OneOrMoreExps '}' { FunDefFun $1 $3 $6 }

InstancePat : '(' PatExp ')' '.'  { $2 }

PatExpList : PatExp { [$1] }
           | PatExpList ',' PatExp { $1 ++ [$3] }
           | {- empty -} { [] }

CommaSeparatedTys : Ty { [$1] }
                  | CommaSeparatedTys ',' Ty { $1 ++ [$3] }
                  | {- empty -} { [] }

TyTupleRest : ',' Ty { [$2] }
            | TyTupleRest ',' Ty { $1 ++ [$3] }

TyTuple : '(' Ty TyTupleRest ')' { SynTyTuple ($2:$3) }

OptionalImpClause : ':' Ty { Just $2 }
                  | {- empty -} { Nothing }

TyArgs : '<' CommaSeparatedTys '>' { $2 }
       | {- empty -} { [] }

Ty : Int { SynTyInt }
   | Bool { SynTyBool }
   | String { SynTyString }
   | Unit { SynTyUnit }
   | fun '(' ')' ':' Ty { SynTyArrow [] $5 }
   | fun '(' CommaSeparatedTys ')' ':' Ty { SynTyArrow $3 $6 }
   | module OptionalImpClause { SynTyModule [] $2 }
   | module '(' CommaSeparatedTys ')' OptionalImpClause { SynTyModule $3 $5 }
   | interface '{' '}' { SynTyInterface }
   | default QualifiedId TyArgs { SynTyDefault $2 $3 }
   | struct '{' TyStructFields '}' { SynTyStruct $3 }
   | TyTuple { $1 }
   | QualifiedId { SynTyRef $1 [] }
   | QualifiedId '<' CommaSeparatedTys '>' { SynTyRef $1 $3 }
   | Ty '[' ']' { SynTyList $1 }

TyStructField : Ty id ';' { ($2, $1) }

TyStructFields : TyStructField { [$1] }
               | TyStructFields TyStructField { $1 ++ [$2] }
               | {- empty -} { [] }

StructFieldInitializer : id '=' Exp ';' { ($1, $3) }

StructFieldInitializers : StructFieldInitializer { [$1] }
                        | StructFieldInitializers StructFieldInitializer { $1 ++ [$2] }
                        | {- empty -} { [] }

QualifiedId : id  { Id $1 }
            | QualifiedId '.' id  { Path $1 $3 }

{

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

happyError :: Token -> Alex a
happyError (Token p t) =
  alexError' p ("parse error at token '" ++ unlex t ++ "'")

parseExp :: FilePath -> String -> Either Err (CompUnit RawId)
parseExp filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' parse filePath input

}
