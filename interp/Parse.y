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
  if { Token _ TokenIf }
  else { Token _ TokenElse }
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

CompUnit : OneOrMoreExps { CompUnit $1 }

OneOrMoreExps : ExpT { [$1] }
              | OneOrMoreExps ExpT { $1 ++ [$2] }

ZeroOrMoreExps : ExpT { [$1] }
     | OneOrMoreExps ExpT { $1 ++ [$2] }
     | {- empty -} { [] }

ExpT : Exp ';'  { $1 }

AtomExp : '(' Exp ')' { $2 }
        | module '{' ZeroOrMoreExps '}'  { ExpModule $3 }
        | '(' ')' { ExpUnit }
        | num { ExpNum $1 }
        | True { ExpBool True }
        | False { ExpBool False }
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

Exp : '!' SubExp { ExpNot $2 }
    | SubExp { $1 }
    | import QualifiedId { ExpImport $2 }
    | id ':=' Exp { ExpAssign $1 $3 }
    | TypeDec { ExpTypeDec $1 }
    | FunDec { ExpFunDec $1 }
    | if '(' Exp ')' '{' ZeroOrMoreExps '}' else '{' ZeroOrMoreExps '}' { ExpIfElse $3 $6 $10 }

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

PatExp : id { PatExpVar $1 }

TyList : Ty { [$1] }
       | TyList ',' Ty { $1 ++ [$3] }
       | {- empty -} { [] }

Ty : Int { TyInt }
   | Bool { TyBool }
   | Unit { TyUnit }
   | fun '(' ')' ':' Ty { TyArrow [] $5 }
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

parseExp :: FilePath -> String -> Either String (CompUnit RawId)
parseExp = runAlex' parse

}
