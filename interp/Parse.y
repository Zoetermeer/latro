{

module Parse where

import Control.Monad.Except
import Lex
import Syntax

}

%tokentype { Token }
%monad { Except String } { (>>=) } { return }
%error { parseError }

%token
  module { TokenModule }
  import { TokenImport }
  type { TokenType }
  interface { TokenInterface }
  fun { TokenFun }
  imp { TokenImp }
  test { TokenTest }
  True { TokenTrue }
  False { TokenFalse }
  Int { TokenInt }
  Bool { TokenBool }
  Unit { TokenUnit }
  ':=' { TokenAssign }
  '[' { TokenLBracket }
  ']' { TokenRBracket }
  '{' { TokenLBrace }
  '}' { TokenRBrace }
  '(' { TokenLParen }
  ')' { TokenRParen }
  '|' { TokenPipe }
  '+' { TokenPlus }
  '-' { TokenMinus }
  '*' { TokenStar }
  '/' { TokenFSlash }
  '!' { TokenExclamation }
  ';' { TokenSemi }
  '.' { TokenDot }
  '=' { TokenEq }
  ':' { TokenColon }
  ',' { TokenComma }
  num { TokenNumLit $$ }
  id  { TokenId $$ }

%name parseIt

%%

CompUnit : Exps { CompUnit $1 }

Exps : ExpT { [$1] }
     | Exps ExpT { $1 ++ [$2] }
     | {- empty -} { [] }

ExpT : Exp ';'  { $1 }

Exp : Exp '+' Exp { ExpAdd $1 $3 }
    | Exp '-' Exp { ExpSub $1 $3 }
    | Exp '/' Exp { ExpDiv $1 $3 }
    | Exp '*' Exp { ExpMul $1 $3 }
    | Exp '.' id  { ExpMemberAccess $1 $3 }
    | Exp '(' ArgExps ')' { ExpApp $1 $3 }
    | '(' Exp ')' { $2 }
    | '!' Exp { ExpNot $2 }
    | import QualifiedId { ExpImport $2 }
    | id ':=' Exp { ExpAssign $1 $3 }
    | TypeDec { ExpTypeDec $1 }
    | FunDec { ExpFunDec $1 }
    | module '{' Exps '}'  { ExpModule $3 }
    | num { ExpNum $1 }
    | True { ExpBool True }
    | False { ExpBool False }
    | id  { ExpRef $1 }

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

AdtAlternative : '|' id Tys { AdtAlternative $2 $3 }

Tys : Ty { [$1] }
    | Tys Ty { $1 ++ [$2] }
    | {- empty -} { [] }

FunDec : fun '(' Ty ')' id '(' TyList ')' ':' Ty ';' FunDefs { FunDecInstFun $5 (TyInstArrow $3 $7 $10) $12 }
       | fun id '(' TyList ')' ':' Ty ';' FunDefs { FunDecFun $2 (TyArrow $4 $7) $9 }

FunDefs : FunDef  { [$1] }
        | FunDefs ';' FunDef { $1 ++ [$3] }

FunDef : InstancePat id '(' PatExpList ')' ':=' '{' Exps '}' { FunDefInstFun $1 $2 $4 $8 }
       | id '(' PatExpList ')' ':=' '{' Exps '}' { FunDefFun $1 $3 $7 }

InstancePat : '(' PatExp ')' '.'  { $2 }

PatExpList : PatExp { [$1] }
           | PatExpList ',' PatExp { $1 ++ [$3] }
           | {- empty -} { [] }

PatExp : id { PatExpVar $1 }

TyList : Ty { [$1] }
       | TyList ',' Ty { $1 ++ [$3] }
       | {- empty -} { [] }

Ty : Int { TyInt }
   | Bool { TyBool }
   | Unit { TyUnit }
   | fun '(' TyList ')' ':' Ty { TyArrow $3 $6 }
   | fun '(' Ty ')' '(' TyList ')' ':' Ty { TyInstArrow $3 $6 $9 }
   | QualifiedId { TyRef $1 }

QualifiedId : id  { Id $1 }
            | QualifiedId '.' id  { Path $1 $3 }

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

parse = parseIt . scan

}
