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
  ":=" { \s -> TokenAssign }
  [\[] { \s -> TokenLBracket }
  [\]] { \s -> TokenRBracket }
  [\{] { \s -> TokenLBrace }
  [\}] { \s -> TokenRBrace }
  [\|] { \s -> TokenPipe }
  [\+] { \s -> TokenPlus }
  [\-] { \s -> TokenMinus }
  [\!] { \s -> TokenExclamation }
  [\;] { \s -> TokenSemi }
  [\.] { \s -> TokenDot }
  [\=] { \s -> TokenEq }
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
  | TokenAssign
  | TokenLBracket
  | TokenRBracket
  | TokenLBrace
  | TokenRBrace
  | TokenPipe
  | TokenPlus
  | TokenMinus
  | TokenExclamation
  | TokenSemi
  | TokenDot
  | TokenEq
  | TokenId String
  deriving (Show)

scan :: String -> [Token]
scan = alexScanTokens

}
