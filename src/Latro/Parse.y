{

module Parse where

import Control.Monad.Except
import Data.Bifunctor (first)
import Errors
import Lex
import Semant

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
  default { Token _ TokenDefault }
  fun { Token _ TokenFun }
  imp { Token _ TokenImp }
  test { Token _ TokenTest }
  struct { Token _ TokenStruct }
  def { Token _ TokenDef }
  True { Token _ TokenTrue }
  False { Token _ TokenFalse }
  Int { Token _ TokenInt }
  Bool { Token _ TokenBool }
  Char { Token _ TokenCharTy }
  Unit { Token _ TokenUnit }
  if { Token _ TokenIf }
  else { Token _ TokenElse }
  switch { Token _ TokenSwitch }
  cond { Token _ TokenCond }
  case { Token _ TokenCase }
  precedence { Token _ TokenPrecedence }
  ':=' { Token _ TokenAssign }
  '->' { Token _ TokenArrow }
  '=>' { Token _ TokenRocket }
  '::' { Token _ TokenCons }
  '%(' { Token _ TokenPctLParen }
  '%{' { Token _ TokenPctLBrace }
  '[' { Token _ TokenLBracket }
  ']' { Token _ TokenRBracket }
  '{' { Token _ TokenLBrace }
  '}' { Token _ TokenRBrace }
  '(' { Token _ TokenLParen }
  ')' { Token _ TokenRParen }
  '<' { Token _ TokenLt }
  '>' { Token _ TokenGt }
  '|' { Token _ TokenPipe }
  '+' { Token _ TokenPlus }
  '-' { Token _ TokenMinus }
  '*' { Token _ TokenStar }
  '/' { Token _ TokenFSlash }
  ';' { Token _ TokenSemi }
  '.' { Token _ TokenDot }
  '=' { Token _ TokenEq }
  ':' { Token _ TokenColon }
  ',' { Token _ TokenComma }
  '_' { Token _ TokenUnderscore }
  num { Token _ (TokenNumLit _) }
  simple_id { Token _ (TokenSimpleId _) }
  mixed_id { Token _ (TokenMixedId _) }
  special_id { Token _ (TokenSpecialId _) }
  string { Token _ (TokenString _) }
  char { Token _ (TokenChar _) }

%name parse

%%

CompUnit : OneOrMoreModuleLevelExps { CompUnit (firstPos $1) $1 }

OneOrMoreExps : Exp { [$1] }
              | OneOrMoreExps Exp { $1 ++ [$2] }

ZeroOrMoreExps : Exp { [$1] }
               | OneOrMoreExps Exp { $1 ++ [$2] }
               | {- empty -} { [] }

Block : '{' ExpOrAssigns '}' { $2 }

ZeroOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                          | ZeroOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }
                          | {- empty -} { [] }

OneOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                         | OneOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }

ModuleLevelExp : InterfaceDecExp { $1 }
               | TypeDec { ExpTypeDec (nodeData $1) $1 }
               | ModuleDec { $1 }
               | PrecedenceAssign { $1 }
               | ExpOrAssign { $1 }

ModuleDec : module SimpleOrMixedId ModuleParamList '{' ZeroOrMoreModuleLevelExps '}'
  { ExpAssign (pos $1) (PatExpId (pos $2) (tokValue $2)) (ExpModule (pos $4) $3 $5) }

TupleRestExps : ',' Exp { [$2] }
              | TupleRestExps ',' Exp { $1 ++ [$3] }

LiteralPatExp : num { PatExpNumLiteral (pos $1) (tokValue $1) }
              | True { PatExpBoolLiteral (pos $1) True }
              | False { PatExpBoolLiteral (pos $1) False }
              | string { PatExpStringLiteral (pos $1) (tokValue $1) }
              | char { PatExpCharLiteral (pos $1) (tokValue $1) }

TuplePatExpsRest : ',' PatExp { [$2] }
                 | TuplePatExpsRest ',' PatExp { $1 ++ [$3] }

TuplePatExp : '%(' PatExp TuplePatExpsRest ')' { PatExpTuple (pos $1) ([$2] ++ $3) }

AdtPatExp : QualifiedId '(' ZeroOrMorePatExps ')' { PatExpAdt (nodeData $1) $1 $3 }

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
           | SimpleOrMixedId { PatExpId (pos $1) (tokValue $1) }
           | '_' { PatExpWildcard (pos $1) }

ListPatExp : AtomPatExp '::' ListPatExp { PatExpListCons (nodeData $1) $1 $3 }
           | '[' ZeroOrMorePatExps ']' { PatExpList (pos $1) $2 }
           | AtomPatExp { $1 }

PatExp : ListPatExp { $1 }

CommaSeparatedExps : Exp { [$1] }
                   | CommaSeparatedExps ',' Exp { $1 ++ [$3] }
                   | {- empty -} { [] }

ListExp : '[' CommaSeparatedExps ']' { ExpList (pos $1) $2 }

CommaSeparatedIds : SimpleOrMixedId { [tokValue $1] }
                  | CommaSeparatedIds ',' SimpleOrMixedId { $1 ++ [tokValue $3] }
                  | {- empty -} { [] }

ModuleParamList : '(' ')' { [] }
                | '(' CommaSeparatedIds ')' { $2 }
                | {- empty -} { [] }

SingleParamFunHeader : fun '(' PatExp ')' { (pos $1, $3) }

MultiParamFunHeader : fun '(' PatExpList ',' PatExp ')' { (pos $1, $3 ++ [$5]) }

FunHeader : SingleParamFunHeader { (fst $1, [snd $1]) }
          | MultiParamFunHeader { $1 }
          | fun '(' ')' { (pos $1, []) }

AtomExp : '(' Exp ')' { $2 }
        | '(' ')' { ExpUnit (pos $1) }
        | '%(' Exp TupleRestExps ')' { ExpTuple (pos $1) ($2:$3) }
        | ListExp { $1 }
        | QualifiedId '%{' StructFieldInitializers '}' { ExpStruct (nodeData $1) $1 $3 }
        | FunHeader FunBody { ExpFun (fst $1) (snd $1) $2 }
        | num { ExpNum (pos $1) (tokValue $1) }
        | True { ExpBool (pos $1) True }
        | False { ExpBool (pos $1) False }
        | string { ExpString (pos $1) (tokValue $1) }
        | char { ExpChar (pos $1) (tokValue $1) }
        | QualifiedId { ExpQualifiedRef (nodeData $1) $1 }

MemberAccessExp : AppExp '.' SimpleOrMixedId{ ExpMemberAccess (nodeData $1) $1 (tokValue $3) }
                | AtomExp { $1 }

AppExp : AppExp '(' ArgExps ')' { ExpApp (nodeData $1) $1 $3 }
       | MemberAccessExp { $1 }

MulExp : MulExp '*' AppExp { ExpMul (nodeData $1) $1 $3 }
       | AppExp { $1 }

DivExp : DivExp '/' MulExp { ExpDiv (nodeData $1) $1 $3 }
       | MulExp { $1 }

AddExp : AddExp '+' DivExp { ExpAdd (nodeData $1) $1 $3 }
       | DivExp { $1 }

SubExp : SubExp '-' AddExp { ExpSub (nodeData $1) $1 $3 }
       | AddExp { $1 }

ConsExp : SubExp '::' ConsExp { ExpCons (nodeData $1) $1 $3 }
        | SubExp { $1 }

CustomInfixExp : CustomInfixExp SpecialId ConsExp { ExpCustomInfix (nodeData $1) $1 (tokValue $2) $3 }
               | ConsExp { $1 }

Exp : CustomInfixExp { $1 }
    | if '(' Exp ')' '{' ExpOrAssigns '}' else '{' ExpOrAssigns '}' { ExpIfElse (pos $1) $3 $6 $10 }
    | switch '(' Exp ')' '{' CaseClauses '}' { ExpSwitch (pos $1) $3 $6 }
    | cond '{' CondCaseClauses '}' { ExpCond (pos $1) $3 }

ExpOrAssign : def PatExp '=' Exp { ExpAssign (pos $1) $2 $4 }
            | FunDef { ExpFunDef $1 }
            | TyAnn { ExpTyAnn $1 }
            | import QualifiedId { ExpImport (pos $1) $2 }
            | Exp { $1 }

ExpOrAssigns : ExpOrAssign { [$1] }
             | ExpOrAssigns ExpOrAssign { $1 ++ [$2] }

PrecedenceAssign : precedence SpecialId num { ExpPrecAssign (pos $1) (tokValue $2) (read (tokValue $3)) }

FunDef : fun AnyId '(' PatExpList ')' FunBody { FunDefFun (pos $1) (tokValue $2) $4 $6 }
       | SingleParamFunHeader '.' SimpleOrMixedId '(' PatExpList ')' FunBody { FunDefInstFun (fst $1) (snd $1) (tokValue $3) $5 $7 }

FunBody : '{' ExpOrAssigns '}' { $2 }
        | '=' Exp { [$2] }

TyParams : '{' CommaSeparatedIds '}' { $2 }
         | {- empty -} { [] }

TyAnn : SimpleOrMixedId TyParams '=>' Ty { TyAnn (pos $1) (tokValue $1) $2 $4 }


TyAnns : TyAnn { [$1] }
       | TyAnns TyAnn { $1 ++ [$2] }

InterfaceDecExp: interface SimpleOrMixedId TyParams '{' TyAnns '}' { ExpInterfaceDec (pos $1) (tokValue $2) $3 $5 }

CaseClauses : CaseClause { [$1] }
            | CaseClauses CaseClause { $1 ++ [$2] }

CaseClause : case PatExp '->' Exp { CaseClause (pos $1) $2 [$4] }
           | case PatExp '->' Block { CaseClause (pos $1) $2 $4 }

CondCaseClauses : CondCaseClause { [$1] }
                | CondCaseClauses CondCaseClause { $1 ++ [$2] }

CondCaseClause : case Exp '->' OneOrMoreExps { CondCaseClause (pos $1) $2 $4 }
               | case '_' '->' OneOrMoreExps { CondCaseClauseWildcard (pos $1) $4 }

ArgExps : Exp { [$1] }
        | ArgExps ',' Exp { $1 ++ [$3] }
        | {- empty -} { [] }

FunParams : SimpleOrMixedId { [tokValue $1] }
          | FunParams ',' SimpleOrMixedId { $1 ++ [tokValue $3] }
          | {- empty -} { [] }

TypeDec : type SimpleOrMixedId TyParams '=' Ty { TypeDecTy (pos $1) (tokValue $2) $3 $5 }
        | type SimpleOrMixedId TyParams '=' AdtAlternatives { TypeDecAdt (pos $1) (tokValue $2) $3 $5 }

AdtAlternatives : AdtAlternative  { [$1] }
                | AdtAlternatives AdtAlternative  { $1 ++ [$2] }

AdtAlternative : '|' SimpleOrMixedId '(' CommaSeparatedTys ')' { AdtAlternative (pos $1) (tokValue $2) 0 $4 }
               | '|' SimpleOrMixedId { AdtAlternative (pos $2) (tokValue $2) 0 [] }

Tys : Ty { [$1] }
    | Tys Ty { $1 ++ [$2] }
    | {- empty -} { [] }

InstancePat : '(' PatExp ')' '.'  { $2 }

PatExpList : PatExp { [$1] }
           | PatExpList ',' PatExp { $1 ++ [$3] }
           | {- empty -} { [] }

CommaSeparatedTys : Ty { [$1] }
                  | CommaSeparatedTys ',' Ty { $1 ++ [$3] }
                  | {- empty -} { [] }

TyTupleRest : ',' Ty { [$2] }
            | TyTupleRest ',' Ty { $1 ++ [$3] }

TyTuple : '%(' Ty TyTupleRest ')' { SynTyTuple (pos $1) ($2:$3) }

OptionalImpClause : ':' Ty { Just $2 }
                  | {- empty -} { Nothing }

TyArgs : '{' CommaSeparatedTys '}' { $2 }
       | {- empty -} { [] }

Ty : Int { SynTyInt (pos $1)  }
   | Bool { SynTyBool (pos $1) }
   | Char { SynTyChar (pos $1) }
   | Unit { SynTyUnit (pos $1) }
   | fun '(' ')' ':' Ty { SynTyArrow (pos $1) [] $5 }
   | fun '(' CommaSeparatedTys ')' ':' Ty { SynTyArrow (pos $1) $3 $6 }
   | interface '{' '}' { SynTyInterface (pos $1) [] }
   | default QualifiedSimpleId TyArgs { SynTyDefault (pos $1) $2 $3 }
   | struct '{' TyStructFields '}' { SynTyStruct (pos $1) $3 }
   | TyTuple { $1 }
   | QualifiedSimpleId TyArgs { SynTyRef (nodeData $1) $1 $2 }
   | Ty '[' ']' { SynTyList (nodeData $1) $1 }

TyStructField : Ty SimpleOrMixedId ';' { (tokValue $2, $1) }

TyStructFields : TyStructField { [$1] }
               | TyStructFields TyStructField { $1 ++ [$2] }
               | {- empty -} { [] }

StructFieldInitializer : SimpleOrMixedId '=' Exp ';' { (tokValue $1, $3) }

StructFieldInitializers : StructFieldInitializer { [$1] }
                        | StructFieldInitializers StructFieldInitializer { $1 ++ [$2] }
                        | {- empty -} { [] }

QualifiedId : SimpleOrMixedId  { Id (pos $1) (tokValue $1) }
            | QualifiedId '.' SimpleOrMixedId  { Path (nodeData $1) $1 (tokValue $3) }

QualifiedSimpleId : simple_id { Id (pos $1) (tokValue $1) }
                  | QualifiedId '.' simple_id { Path (nodeData $1) $1 (tokValue $3) }

SimpleOrMixedId : simple_id { $1 }
                | mixed_id { $1 }

SpecialId : special_id { $1 }
          | '|' { Token (pos $1) $ TokenSpecialId "|" }
          | '<' { Token (pos $1) $ TokenSpecialId "<" }
          | '>' { Token (pos $1) $ TokenSpecialId ">" }

AnyId : simple_id { $1 }
      | mixed_id { $1 }
      | SpecialId { $1 }

{

pos :: Token -> SourcePos
pos (Token sourcePos _) = sourcePos

firstPos :: AstNode a => [a SourcePos RawId] -> SourcePos
firstPos [] = SourcePos "" 0 0
firstPos (e:_) = nodeData e

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap = (alexMonadScan' >>=)

happyError :: Token -> Alex a
happyError (Token (SourcePos _ line col) t) =
  alexError' (AlexPn 0 line col) ("parse error at token '" ++ unlex t ++ "'")

parseExp :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseExp filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' parse filePath input

}
