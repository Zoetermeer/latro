{

module Main where

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
  ':=' { TokenAssign }
  '[' { TokenLBracket }
  ']' { TokenRBracket }
  '{' { TokenLBrace }
  '}' { TokenRBrace }
  '|' { TokenPipe }
  '+' { TokenPlus }
  '-' { TokenMinus }
  '!' { TokenExclamation }
  ';' { TokenSemi }
  '.' { TokenDot }
  '=' { TokenEq }
  ':' { TokenColon }
  id  { TokenId $$ }

%name parse

%%

CompUnit : Imports ModuleDecs { CompUnit $1 $2 }

Imports : Import  { [$1] }
        | Imports Import { $1 ++ [$2] }

Import : import QualifiedId ';' { Import $2 }

ModuleDecs : ModuleDec { [$1] }
           | ModuleDecs ModuleDec { $1 ++ [$2] }

ModuleDec : id ':=' ModuleExp { ModuleDec $1 $3 }

ModuleExp : QualifiedId { ModuleExpRef $1 }
          | module '{' ModuleLevelDecs '}'  { ModuleExpDef $3 }

ModuleLevelDecs : ModuleLevelDec { [$1] }
                | ModuleLevelDecs ModuleLevelDec { $1 ++ [$2] }

ModuleLevelDec : TypeDec  { ModuleLevelDecType $1 }

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

main = getContents >>= print . parse . scan

}
