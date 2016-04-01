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
    | Exp '(' ArgExps ')' { ExpApp $1 $3 }
    | '(' Exp ')' { $2 }
    | '!' Exp { ExpNot $2 }
    | import QualifiedId { ExpImport $2 }
    | id ':=' Exp { ExpAssign $1 $3 }
    | TypeDec { ExpTypeDec $1 }
    | module '{' Exps '}'  { ExpModule $3 }
    | num { ExpNum $1 }
    | True { ExpBool True }
    | False { ExpBool False }
    | QualifiedId { ExpQualId $1 }

ArgExps : Exp { [$1] }
        | ArgExps ',' Exp { $1 ++ [$3] }

TypeDec : type id '=' QualifiedId { TypeDecTy $2 $4 }
        | type id '=' AdtAlternatives { TypeDecAdt $2 $4 }

AdtAlternatives : AdtAlternative  { [$1] }
                | AdtAlternatives AdtAlternative  { $1 ++ [$2] }

AdtAlternative : '|' id Tys { AdtAlternative $2 $3 }

Tys : QualifiedId { [$1] }
    | Tys QualifiedId { $1 ++ [$2] }

QualifiedId : id  { Id $1 }
            | QualifiedId '.' id  { Path $1 $3 }

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

parse = parseIt . scan

}
