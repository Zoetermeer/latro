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
  True { Token _ TokenTrue }
  False { Token _ TokenFalse }
  Int { Token _ TokenInt }
  Bool { Token _ TokenBool }
  Unit { Token _ TokenUnit }
  ':=' { Token _ TokenAssign }
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
  num { Token _ (TokenNumLit $$) }
  id  { Token _ (TokenId $$) }

%name parse

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
        | FunDefs FunDef { $1 ++ [$2] }

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
   | module '{' '}' { TyModule }
   | interface '{' '}' { TyInterface }
   | QualifiedId { TyRef $1 }

QualifiedId : id  { Id $1 }
            | QualifiedId '.' id  { Path $1 $3 }

{

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

happyError :: Token -> Alex a
happyError (Token p t) =
  alexError' p ("parse error at token '" ++ unlex t ++ "'")

parseExp :: FilePath -> String -> Either String CompUnit
parseExp = runAlex' parse

}
