{

module Parse where

import Control.Monad.Except
import Lex
import Syntax

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
  '::' { Token _ TokenCons }
  '[' { Token _ TokenLBracket }
  ']' { Token _ TokenRBracket }
  '{' { Token _ TokenLBrace }
  '}' { Token _ TokenRBrace }
  '(' { Token _ TokenLParen }
  ')' { Token _ TokenRParen }
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

CompUnit : OneOrMoreExps { CompUnit $1 }

OneOrMoreExps : ExpT { [$1] }
              | OneOrMoreExps ExpT { $1 ++ [$2] }

ZeroOrMoreExps : ExpT { [$1] }
     | OneOrMoreExps ExpT { $1 ++ [$2] }
     | {- empty -} { [] }

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

AtomExp : '(' Exp ')' { $2 }
        | module '{' ZeroOrMoreExps '}'  { ExpModule $3 }
        | '(' ')' { ExpUnit }
        | '(' Exp TupleRestExps ')' { ExpTuple ($2:$3) }
        | ListExp { $1 }
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
    | def PatExp ':=' Exp { ExpAssign $2 $4 }
    | MemberAccessExp '{' StructFieldInitializers '}' { ExpStruct $1 $3 }
    | TypeDec { ExpTypeDec $1 }
    | FunDec { ExpFunDec $1 }
    | if '(' Exp ')' '{' ZeroOrMoreExps '}' else '{' ZeroOrMoreExps '}' { ExpIfElse $3 $6 $10 }
    | switch '(' Exp ')' '{' CaseClauses '}' { ExpSwitch $3 $6 }

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

FunDec : fun '(' Ty ')' id '(' TyList ')' ':' Ty ';' FunDefs { FunDecInstFun $5 $3 (TyArrow $7 $10) $12 }
       | fun id '(' TyList ')' ':' Ty ';' FunDefs { FunDecFun $2 (TyArrow $4 $7) $9 }

FunDefs : FunDef  { [$1] }
        | FunDefs FunDef { $1 ++ [$2] }

FunDef : InstancePat id '(' PatExpList ')' ':=' '{' OneOrMoreExps '}' { FunDefInstFun $1 $2 $4 $8 }
       | id '(' PatExpList ')' ':=' '{' OneOrMoreExps '}' { FunDefFun $1 $3 $7 }

InstancePat : '(' PatExp ')' '.'  { $2 }

PatExpList : PatExp { [$1] }
           | PatExpList ',' PatExp { $1 ++ [$3] }
           | {- empty -} { [] }

TyList : Ty { [$1] }
       | TyList ',' Ty { $1 ++ [$3] }
       | {- empty -} { [] }

TyTupleRest : ',' Ty { [$2] }
            | TyTupleRest ',' Ty { $1 ++ [$3] }

TyTuple : '(' Ty TyTupleRest ')' { TyTuple ($2:$3) }

Ty : Int { TyInt }
   | Bool { TyBool }
   | String { TyString }
   | Unit { TyUnit }
   | fun '(' ')' ':' Ty { TyArrow [] $5 }
   | fun '(' TyList ')' ':' Ty { TyArrow $3 $6 }
   | module '{' '}' { TyModule }
   | interface '{' '}' { TyInterface }
   | struct '{' TyStructFields '}' { TyStruct $3 }
   | TyTuple { $1 }
   | QualifiedId { TyRef $1 }
   | Ty '[' ']' { TyList $1 }

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

parseExp :: FilePath -> String -> Either String (CompUnit RawId)
parseExp = runAlex' parse

}
