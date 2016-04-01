{
module Lex (Token(..), scan) where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-
  $white+ ;
  "//".*  ;
  module { \s -> TokenModule }
  import { \s -> TokenImport }
  type { \s -> TokenType }
  interface { \s -> TokenInterface }
  fun { \s -> TokenFun }
  imp { \s -> TokenImp }
  test { \s -> TokenTest }
  True { \s -> TokenTrue }
  False { \s -> TokenFalse }
  ":=" { \s -> TokenAssign }
  [\[] { \s -> TokenLBracket }
  [\]] { \s -> TokenRBracket }
  [\{] { \s -> TokenLBrace }
  [\}] { \s -> TokenRBrace }
  [\(] { \s -> TokenLParen }
  [\)] { \s -> TokenRParen }
  [\|] { \s -> TokenPipe }
  [\+] { \s -> TokenPlus }
  [\-] { \s -> TokenMinus }
  [\!] { \s -> TokenExclamation }
  [\;] { \s -> TokenSemi }
  [\.] { \s -> TokenDot }
  [\=] { \s -> TokenEq }
  [\:] { \s -> TokenColon }
  [\,] { \s -> TokenComma }
  $digit+ { \s -> TokenNumLit s }
  $alpha [$alpha $digit \_ \']* { \s -> TokenId s }

{

data Token =
    TokenModule
  | TokenImport
  | TokenType
  | TokenInterface
  | TokenFun
  | TokenImp
  | TokenTest
  | TokenTrue
  | TokenFalse
  | TokenAssign
  | TokenLBracket
  | TokenRBracket
  | TokenLBrace
  | TokenRBrace
  | TokenLParen
  | TokenRParen
  | TokenPipe
  | TokenPlus
  | TokenMinus
  | TokenExclamation
  | TokenSemi
  | TokenDot
  | TokenEq
  | TokenColon
  | TokenComma
  | TokenNumLit String
  | TokenId String
  deriving (Show)

scan :: String -> [Token]
scan = alexScanTokens

}
