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
  cond { Token _ TokenCond }
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

CompUnit : OneOrMoreModuleLevelExps { CompUnit (firstPos $1) $1 }

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

LiteralPatExp : num { PatExpNumLiteral (pos $1) $1 }
              | True { PatExpBoolLiteral (pos $1) True }
              | False { PatExpBoolLiteral (pos $1) False }

TuplePatExpsRest : ',' PatExp { [$2] }
                 | TuplePatExpsRest ',' PatExp { $1 ++ [$3] }

TuplePatExp : '(' PatExp TuplePatExpsRest ')' { PatExpTuple (pos $1) ([$2] ++ $3) }

AdtPatExp : id '(' ZeroOrMorePatExps ')' { PatExpAdt (pos $1) $1 $3 }

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
           | id { PatExpId (pos $1) $1 }
           | '_' { PatExpWildcard (pos $1) }

ListPatExp : AtomPatExp '::' ListPatExp { PatExpListCons (pos $1) $1 $3 }
           | '[' ZeroOrMorePatExps ']' { PatExpList (pos $1) $2 }
           | AtomPatExp { $1 }

PatExp : ListPatExp { $1 }

CommaSeparatedExps : Exp { [$1] }
                   | CommaSeparatedExps ',' Exp { $1 ++ [$3] }
                   | {- empty -} { [] }

ListExp : '[' CommaSeparatedExps ']' { ExpList (pos $1) $2 }

CommaSeparatedIds : id { [$1] }
                  | CommaSeparatedIds ',' id { $1 ++ [$3] }
                  | {- empty -} { [] }

ModuleParamList : '(' ')' { [] }
                | '(' CommaSeparatedIds ')' { $2 }
                | {- empty -} { [] }

ModuleExp : module ModuleParamList '{' ZeroOrMoreModuleLevelExps'}'  { ExpModule (pos $1) $2 $4 }

AtomExp : '(' Exp ')' { $2 }
        | ModuleExp { $1 }
        | '(' ')' { ExpUnit (pos $1) }
        | '(' Exp TupleRestExps ')' { ExpTuple (pos $1) ($2:$3) }
        | ListExp { $1 }
        | fun '(' CommaSeparatedIds ')' '{' ZeroOrMoreExps '}' { ExpFun (pos $1) $3 $6 }
        | num { ExpNum (pos $1) $1 }
        | True { ExpBool (pos $1) True }
        | False { ExpBool (pos $1) False }
        | string { ExpString (pos $1) $1 }
        | id  { ExpRef (pos $1) $1 }

MemberAccessExp : AppExp '.' id { ExpMemberAccess (pos $1) $1 $3 }
                | AtomExp { $1 }

AppExp : AppExp '(' ArgExps ')' { ExpApp (pos $1) $1 $3 }
       | MemberAccessExp { $1 }

MulExp : MulExp '*' AppExp { ExpMul (pos $1) $1 $3 }
       | AppExp { $1 }

DivExp : DivExp '/' MulExp { ExpDiv (pos $1) $1 $3 }
       | MulExp { $1 }

AddExp : AddExp '+' DivExp { ExpAdd (pos $1) $1 $3 }
       | DivExp { $1 }

SubExp : SubExp '-' AddExp { ExpSub (pos $1) $1 $3 }
       | AddExp { $1 }

ConsExp : SubExp '::' ConsExp { ExpCons (pos $1) $1 $3 }
        | SubExp { $1 }

Exp : '!' ConsExp { ExpNot (pos $1) $2 }
    | ConsExp { $1 }
    | import QualifiedId { ExpImport (pos $1) $2 }
    | def PatExp '=' Exp { ExpAssign (pos $1) $2 $4 }
    | MemberAccessExp '{' StructFieldInitializers '}' { ExpStruct (pos $1) $1 $3 }
    | TypeDec { ExpTypeDec (pos $1) $1 }
    | if '(' Exp ')' '{' ZeroOrMoreExps '}' else '{' ZeroOrMoreExps '}' { ExpIfElse (pos $1) $3 $6 $10 }
    | switch '(' Exp ')' '{' CaseClauses '}' { ExpSwitch (pos $1) $3 $6 }
    | cond '{' CondCaseClauses '}' { ExpCond (pos $1) $3 }

AnnDefExp : id '=' ModuleExp { AnnDefModule (pos $1) $1 $3 }
          | FunDef { AnnDefFun (pos $1) $1 }

AnnDefs : AnnDefExp { [$1] }
        | AnnDefs AnnDefExp { $1 ++ [$2] }

TyParams : '<' CommaSeparatedIds '>' { $2 }
         | {- empty -} { [] }

AnnDecExp : id TyParams '=>' Ty ';' AnnDefs ';' { ExpAnnDec (pos $1) $1 $2 $4 $6 }

TyAnn : id TyParams '=>' Ty ';' { TyAnn (pos $1) $1 $2 $4 }


TyAnns : TyAnn { [$1] }
       | TyAnns TyAnn { $1 ++ [$2] }

InterfaceDecExp: interface id TyParams '{' TyAnns '}' { ExpInterfaceDec (pos $1) $2 $3 $5 }

ModuleLevelExp : AnnDecExp { $1 }
               | InterfaceDecExp ';' { $1 }
               | ExpT { $1 }

CaseClauses : CaseClause { [$1] }
            | CaseClauses CaseClause { $1 ++ [$2] }

CaseClause : case PatExp '->' OneOrMoreExps { CaseClause (pos $1) $2 $4 }

CondCaseClauses : CondCaseClause { [$1] }
                | CondCaseClauses CondCaseClause { $1 ++ [$2] }

CondCaseClause : case Exp '->' OneOrMoreExps { CondCaseClause (pos $1) $2 $4 }
               | case '_' '->' OneOrMoreExps { CondCaseClauseWildcard (pos $1) $4 }

ArgExps : Exp { [$1] }
        | ArgExps ',' Exp { $1 ++ [$3] }
        | {- empty -} { [] }

FunParams : id { [$1] }
          | FunParams ',' id { $1 ++ [$3] }
          | {- empty -} { [] }

TypeDec : type id TyParams '=' Ty { TypeDecTy (pos $1) $2 $5 }
        | type id TyParams '=' AdtAlternatives { TypeDecAdt (pos $1) $2 $3 $5 }

AdtAlternatives : AdtAlternative  { [$1] }
                | AdtAlternatives AdtAlternative  { $1 ++ [$2] }

AdtAlternative : '|' id Tys { AdtAlternative (pos $1) $2 0 $3 }

Tys : Ty { [$1] }
    | Tys Ty { $1 ++ [$2] }
    | {- empty -} { [] }

FunDefs : FunDef  { [$1] }
        | FunDefs FunDef { $1 ++ [$2] }

FunDef : InstancePat id '(' PatExpList ')' '{' OneOrMoreExps '}' { FunDefInstFun (pos $1) $1 $2 $4 $7 }
       | id '(' PatExpList ')' '{' OneOrMoreExps '}' { FunDefFun (pos $1) $1 $3 $6 }

InstancePat : '(' PatExp ')' '.'  { $2 }

PatExpList : PatExp { [$1] }
           | PatExpList ',' PatExp { $1 ++ [$3] }
           | {- empty -} { [] }

CommaSeparatedTys : Ty { [$1] }
                  | CommaSeparatedTys ',' Ty { $1 ++ [$3] }
                  | {- empty -} { [] }

TyTupleRest : ',' Ty { [$2] }
            | TyTupleRest ',' Ty { $1 ++ [$3] }

TyTuple : '(' Ty TyTupleRest ')' { SynTyTuple (pos $1) ($2:$3) }

OptionalImpClause : ':' Ty { Just $2 }
                  | {- empty -} { Nothing }

TyArgs : '<' CommaSeparatedTys '>' { $2 }
       | {- empty -} { [] }

Ty : Int { SynTyInt (pos $1)  }
   | Bool { SynTyBool (pos $1) }
   | String { SynTyString (pos $1) }
   | Unit { SynTyUnit (pos $1) }
   | fun '(' ')' ':' Ty { SynTyArrow (pos $1) [] $5 }
   | fun '(' CommaSeparatedTys ')' ':' Ty { SynTyArrow (pos $1) $3 $6 }
   | module OptionalImpClause { SynTyModule (pos $1) [] $2 }
   | module '(' CommaSeparatedTys ')' OptionalImpClause { SynTyModule (pos $1) $3 $5 }
   | interface '{' '}' { SynTyInterface (pos $1) [] }
   | default QualifiedId TyArgs { SynTyDefault (pos $1) $2 $3 }
   | struct '{' TyStructFields '}' { SynTyStruct (pos $1) $3 }
   | TyTuple { $1 }
   | QualifiedId { SynTyRef (pos $1) $1 [] }
   | QualifiedId '<' CommaSeparatedTys '>' { SynTyRef (pos $1) $1 $3 }
   | Ty '[' ']' { SynTyList (pos $1) $1 }

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

pos :: Token -> SourcePos
pos (Token sourcePos _) = sourcePos

firstPos :: AstNode a => [a] -> SourcePos
firstPos [] = SourcePos 0 0
firstPos (e:_) = nodeData e

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

happyError :: Token -> Alex a
happyError (Token p t) =
  alexError' p ("parse error at token '" ++ unlex t ++ "'")

parseExp :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseExp filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' parse filePath input

}
