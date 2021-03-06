{
module Latro.Lex
  ( Token(..)
  , AlexPosn(..)
  , TokenClass(..)
  , Alex(..)
  , tokValue
  , unlex
  , runAlex'
  , alexMonadScan'
  , alexError'
  ) where

import Prelude hiding (lex)
import Control.Monad (liftM)
import Latro.Ast (SourcePos(..))

}

%wrapper "monadUserState"

$digit = 0-9
$alpha = [a-zA-Z]
$special = [\?\!\/\\\|\~\&\=\+\-\*\^]

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
  let { lex' TokenLet }
  True { lex' TokenTrue }
  False { lex' TokenFalse }
  if { lex' TokenIf }
  else { lex' TokenElse }
  switch { lex' TokenSwitch }
  cond { lex' TokenCond }
  case { lex' TokenCase }
  precedence { lex' TokenPrecedence }
  prim { lex' TokenPrim }
  primtype { lex' TokenPrimType }
  protocol { lex' TokenProtocol }
  when { lex' TokenWhen }
  infixl { lex' TokenInfixl }
  except { lex' TokenExcept }
  renaming { lex' TokenRenaming }
  ":=" { lex' TokenAssign }
  "->" { lex' TokenArrow }
  "=>" { lex' TokenRocket }
  "::" { lex' TokenDblColon }
  "%(" { lex' TokenPctLParen }
  "%{" { lex' TokenPctLBrace }
  [\[] { lex' TokenLBracket }
  [\]] { lex' TokenRBracket }
  [\{] { lex' TokenLBrace }
  [\}] { lex' TokenRBrace }
  [\(] { lex' TokenLParen }
  [\)] { lex' TokenRParen }
  [\<] { lex' TokenLt }
  [\>] { lex' TokenGt }
  [\|] { lex' TokenPipe }
  [\;] { lex' TokenSemi }
  [\.] { lex' TokenDot }
  [\=] { lex' TokenEq }
  [\:] { lex' TokenColon }
  [\,] { lex' TokenComma }
  [\_] { lex' TokenUnderscore }
  [\@] { lex' TokenAtSymbol }
  [\#] { lex' TokenHash }
  $digit+ { lex TokenNumLit }
  [$alpha] [$alpha $digit \_ \']* { lex TokenSimpleId }
  [\_] [$alpha $digit \_ \']+ [$alpha $digit \']+ { lex TokenSimpleId }
  [$alpha] [$alpha $digit \_ \' \- $special]+ { lex TokenMixedId }
  [$special]+ { lex TokenSpecialId }
  [\"] [^\"]* [\"] { lex TokenString }
  [\'] [^\']{1} [\'] { lex TokenChar }

{

data AlexUserState = AlexUserState { filePath :: FilePath }

alexInitUserState :: AlexUserState
alexInitUserState = AlexUserState "<unknown>"

getFilePath :: Alex FilePath
getFilePath = liftM filePath alexGetUserState

setFilePath :: FilePath -> Alex ()
setFilePath = alexSetUserState . AlexUserState

data Token = Token SourcePos TokenClass
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
  | TokenLet
  | TokenTrue
  | TokenFalse
  | TokenIf
  | TokenElse
  | TokenSwitch
  | TokenCond
  | TokenCase
  | TokenPrecedence
  | TokenPrim
  | TokenPrimType
  | TokenProtocol
  | TokenWhen
  | TokenInfixl
  | TokenExcept
  | TokenRenaming
  | TokenAssign
  | TokenArrow
  | TokenRocket
  | TokenDblColon
  | TokenPctLParen
  | TokenPctLBrace
  | TokenLBracket
  | TokenRBracket
  | TokenLBrace
  | TokenRBrace
  | TokenLParen
  | TokenRParen
  | TokenLt
  | TokenGt
  | TokenPipe
  | TokenSemi
  | TokenDot
  | TokenEq
  | TokenColon
  | TokenComma
  | TokenUnderscore
  | TokenAtSymbol
  | TokenHash
  | TokenNumLit String
  | TokenSimpleId String
  | TokenMixedId String
  | TokenSpecialId String
  | TokenString String
  | TokenChar String
  | TokenEOF
  deriving (Show)


tokValue :: Token -> String
tokValue (Token _ tok) =
  case tok of
    TokenNumLit s -> s
    TokenSimpleId s -> s
    TokenMixedId s -> s
    TokenSpecialId s -> s
    TokenString s -> s
    TokenChar s -> s


alexEOF :: Alex Token
alexEOF = do
  fp <- getFilePath
  (p, _, _, _) <- alexGetInput
  return $ Token (sourcePos fp p) TokenEOF

unlex :: TokenClass -> String
unlex (TokenModule) = "module"
unlex (TokenImport) = "import"
unlex (TokenType) = "type"
unlex (TokenInterface) = "interface"
unlex (TokenFun) = "fun"
unlex (TokenImp) = "imp"
unlex (TokenTest) = "test"
unlex (TokenStruct) = "struct"
unlex (TokenLet) = "let"
unlex (TokenTrue) = "True"
unlex (TokenFalse) = "False"
unlex (TokenIf) = "if"
unlex (TokenElse) = "else"
unlex (TokenSwitch) = "switch"
unlex (TokenCond) = "cond"
unlex (TokenCase) = "case"
unlex (TokenPrecedence) = "precedence"
unlex (TokenPrim) = "prim"
unlex (TokenPrimType) = "primtype"
unlex (TokenProtocol) = "protocol"
unlex (TokenWhen) = "when"
unlex (TokenInfixl) = "infixr"
unlex (TokenExcept) = "except"
unlex (TokenRenaming) = "renaming"
unlex (TokenAssign) = ":="
unlex (TokenArrow) = "->"
unlex (TokenRocket) = "=>"
unlex (TokenDblColon) = "::"
unlex (TokenPctLParen) = "%("
unlex (TokenPctLBrace) = "%{"
unlex (TokenLBracket) = "["
unlex (TokenRBracket) = "]"
unlex (TokenLBrace) = "{"
unlex (TokenRBrace) = "}"
unlex (TokenLParen) = "("
unlex (TokenRParen) = ")"
unlex (TokenLt) = "<"
unlex (TokenGt) = ">"
unlex (TokenPipe) = "|"
unlex (TokenSemi) = ";"
unlex (TokenDot) = "."
unlex (TokenEq) = "="
unlex (TokenColon) = ":"
unlex (TokenComma) = ","
unlex (TokenUnderscore) = "_"
unlex (TokenAtSymbol) = "@"
unlex (TokenHash) = "#"
unlex (TokenNumLit s) = s
unlex (TokenSimpleId s) = s
unlex (TokenMixedId s) = s
unlex (TokenSpecialId s) = s
unlex (TokenString s) = s
unlex (TokenEOF) = "<EOF>"

sourcePos :: String -> AlexPosn -> SourcePos
sourcePos filePath (AlexPn _ line col) =
  SourcePos filePath line col

lex :: (String -> TokenClass) -> AlexAction Token
lex f = \(p, _, _, s) i -> do
  fp <- getFilePath
  return $ Token (sourcePos fp p) (f (take i s))

lex' :: TokenClass -> AlexAction Token
lex' = lex . const

stripQuotes :: String -> String
stripQuotes (['\'', c, '\'']) = [c]
stripQuotes ('\"':s) =
  take ((length s) - 1) s


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
      tok <- action (ignorePendingBytes inp) len
      case tok of
        Token p (TokenString s) -> return $ Token p $ TokenString $ stripQuotes s
        Token p (TokenChar s) -> return $ Token p $ TokenChar $ stripQuotes s
        _ -> return tok

alexError' :: AlexPosn -> String -> Alex a
alexError' (AlexPn _ l c) msg = do
  fp <- getFilePath
  alexError (fp ++ ":" ++ show l ++ ":" ++ show c ++ ": " ++ msg)

runAlex' :: Alex a -> FilePath -> String -> Either String a
runAlex' a fp input = runAlex input (setFilePath fp >> a)

}
