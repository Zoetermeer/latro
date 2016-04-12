{
module Lex
  ( Token(..)
  , AlexPosn(..)
  , TokenClass(..)
  , Alex(..)
  , unlex
  , runAlex'
  , alexMonadScan'
  , alexError'
  ) where

import Prelude hiding (lex)
import Control.Monad (liftM)

}

%wrapper "monadUserState"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-
  $white+ ;
  "//".*  ;
  module { lex' TokenModule }
  import { lex' TokenImport }
  type { lex' TokenType }
  interface { lex' TokenInterface }
  fun { lex' TokenFun }
  imp { lex' TokenImp }
  test { lex' TokenTest }
  struct { lex' TokenStruct }
  def { lex' TokenDef }
  True { lex' TokenTrue }
  False { lex' TokenFalse }
  Int { lex' TokenInt }
  Bool { lex' TokenBool }
  Unit { lex' TokenUnit }
  if { lex' TokenIf }
  else { lex' TokenElse }
  switch { lex' TokenSwitch }
  case { lex' TokenCase }
  ":=" { lex' TokenAssign }
  "->" { lex' TokenArrow }
  [\[] { lex' TokenLBracket }
  [\]] { lex' TokenRBracket }
  [\{] { lex' TokenLBrace }
  [\}] { lex' TokenRBrace }
  [\(] { lex' TokenLParen }
  [\)] { lex' TokenRParen }
  [\|] { lex' TokenPipe }
  [\+] { lex' TokenPlus }
  [\-] { lex' TokenMinus }
  [\*] { lex' TokenStar }
  [\/] { lex' TokenFSlash }
  [\!] { lex' TokenExclamation }
  [\;] { lex' TokenSemi }
  [\.] { lex' TokenDot }
  [\=] { lex' TokenEq }
  [\:] { lex' TokenColon }
  [\,] { lex' TokenComma }
  [\_] { lex' TokenUnderscore }
  $digit+ { lex TokenNumLit }
  $alpha [$alpha $digit \_ \']* { lex TokenId }

{

data AlexUserState = AlexUserState { filePath :: FilePath }

alexInitUserState :: AlexUserState
alexInitUserState = AlexUserState "<unknown>"

getFilePath :: Alex FilePath
getFilePath = liftM filePath alexGetUserState

setFilePath :: FilePath -> Alex ()
setFilePath = alexSetUserState . AlexUserState

data Token = Token AlexPosn TokenClass
  deriving (Show)

data TokenClass =
    TokenModule
  | TokenImport
  | TokenType
  | TokenInterface
  | TokenFun
  | TokenImp
  | TokenTest
  | TokenStruct
  | TokenDef
  | TokenTrue
  | TokenFalse
  | TokenInt
  | TokenBool
  | TokenUnit
  | TokenIf
  | TokenElse
  | TokenSwitch
  | TokenCase
  | TokenAssign
  | TokenArrow
  | TokenLBracket
  | TokenRBracket
  | TokenLBrace
  | TokenRBrace
  | TokenLParen
  | TokenRParen
  | TokenPipe
  | TokenPlus
  | TokenMinus
  | TokenStar
  | TokenFSlash
  | TokenExclamation
  | TokenSemi
  | TokenDot
  | TokenEq
  | TokenColon
  | TokenComma
  | TokenUnderscore
  | TokenNumLit String
  | TokenId String
  | TokenEOF
  deriving (Show)

alexEOF :: Alex Token
alexEOF = do
  (p, _, _, _) <- alexGetInput
  return $ Token p TokenEOF

unlex :: TokenClass -> String
unlex (TokenModule) = "module"
unlex (TokenImport) = "import"
unlex (TokenType) = "type"
unlex (TokenInterface) = "interface"
unlex (TokenFun) = "fun"
unlex (TokenImp) = "imp"
unlex (TokenTest) = "test"
unlex (TokenStruct) = "struct"
unlex (TokenDef) = "def"
unlex (TokenTrue) = "True"
unlex (TokenFalse) = "False"
unlex (TokenInt) = "Int"
unlex (TokenBool) = "Bool"
unlex (TokenUnit) = "Unit"
unlex (TokenIf) = "if"
unlex (TokenElse) = "else"
unlex (TokenSwitch) = "switch"
unlex (TokenCase) = "case"
unlex (TokenAssign) = ":="
unlex (TokenArrow) = "->"
unlex (TokenLBracket) = "["
unlex (TokenRBracket) = "]"
unlex (TokenLBrace) = "{"
unlex (TokenRBrace) = "}"
unlex (TokenLParen) = "("
unlex (TokenRParen) = ")"
unlex (TokenPipe) = "|"
unlex (TokenMinus) = "-"
unlex (TokenPlus) = "+"
unlex (TokenStar) = "*"
unlex (TokenFSlash) = "/"
unlex (TokenExclamation) = "!"
unlex (TokenSemi) = ";"
unlex (TokenDot) = "."
unlex (TokenEq) = "="
unlex (TokenColon) = ":"
unlex (TokenComma) = ","
unlex (TokenUnderscore) = "_"
unlex (TokenNumLit s) = s
unlex (TokenId s) = s
unlex (TokenEOF) = "<EOF>"

lex :: (String -> TokenClass) -> AlexAction Token
lex f = \(p, _, _, s) i -> return $ Token p (f (take i s))

lex' :: TokenClass -> AlexAction Token
lex' = lex . const

alexMonadScan' :: Alex Token
alexMonadScan' = do
  inp <- alexGetInput
  sc <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError (p, _, _, s) ->
      alexError' p ("lexical error at character '" ++ take 1 s ++ "'")
    AlexSkip inp' len -> do
      alexSetInput inp'
      alexMonadScan'
    AlexToken inp' len action -> do
      alexSetInput inp'
      action (ignorePendingBytes inp) len

alexError' :: AlexPosn -> String -> Alex a
alexError' (AlexPn _ l c) msg = do
  fp <- getFilePath
  alexError (fp ++ ":" ++ show l ++ ":" ++ show c ++ ": " ++ msg)

runAlex' :: Alex a -> FilePath -> String -> Either String a
runAlex' a fp input = runAlex input (setFilePath fp >> a)

}
