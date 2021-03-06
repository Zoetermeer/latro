{

module Latro.Grammar where

import Control.Monad.Except
import Data.Bifunctor (first)
import Latro.Lex
import Latro.Ast

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
  struct { Token _ TokenStruct }
  let { Token _ TokenLet }
  True { Token _ TokenTrue }
  False { Token _ TokenFalse }
  if { Token _ TokenIf }
  else { Token _ TokenElse }
  switch { Token _ TokenSwitch }
  cond { Token _ TokenCond }
  case { Token _ TokenCase }
  precedence { Token _ TokenPrecedence }
  prim { Token _ TokenPrim }
  primtype { Token _ TokenPrimType }
  protocol { Token _ TokenProtocol }
  when { Token _ TokenWhen }
  infixl { Token _ TokenInfixl }
  except { Token _ TokenExcept }
  renaming { Token _ TokenRenaming }
  ':=' { Token _ TokenAssign }
  '->' { Token _ TokenArrow }
  '=>' { Token _ TokenRocket }
  '::' { Token _ TokenDblColon }
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
  ';' { Token _ TokenSemi }
  '.' { Token _ TokenDot }
  '=' { Token _ TokenEq }
  ':' { Token _ TokenColon }
  ',' { Token _ TokenComma }
  '_' { Token _ TokenUnderscore }
  '@' { Token _ TokenAtSymbol }
  '#' { Token _ TokenHash }
  num { Token _ (TokenNumLit _) }
  simple_id { Token _ (TokenSimpleId _) }
  mixed_id { Token _ (TokenMixedId _) }
  special_id { Token _ (TokenSpecialId _) }
  string { Token _ (TokenString _) }
  char { Token _ (TokenChar _) }

%name ruleParseTopLevel CompUnit
%name ruleParseInteractive InteractiveCompUnit

%%

CompUnit : OneOrMoreTopLevelExps { CompUnit (firstPos $1) $1 }

InteractiveCompUnit : InteractiveExp { CompUnit (nodeData $1) [$1] }

OneOrMoreExps : Exp { [$1] }
              | OneOrMoreExps Exp { $1 ++ [$2] }

ZeroOrMoreExps : Exp { [$1] }
               | OneOrMoreExps Exp { $1 ++ [$2] }
               | {- empty -} { [] }

Block : '{' ExpOrAssigns '}' { ExpBegin (pos $1) $2 }

TopLevelExp : ModuleDec { $1 }

ZeroOrMoreTopLevelExps : TopLevelExp { [$1] }
                       | ZeroOrMoreTopLevelExps TopLevelExp { $1 ++ [$2] }
                       | {- empty -} { [] }

OneOrMoreTopLevelExps : TopLevelExp { [$1] }
                      | OneOrMoreTopLevelExps TopLevelExp { $1 ++ [$2] }

ZeroOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                          | ZeroOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }
                          | {- empty -} { [] }

OneOrMoreModuleLevelExps : ModuleLevelExp { [$1] }
                         | OneOrMoreModuleLevelExps ModuleLevelExp { $1 ++ [$2] }

ModuleLevelExp : InterfaceDecExp { $1 }
               | TypeDec { ExpTypeDec (nodeData $1) $1 }
               | ProtoDec { $1 }
               | ProtoImp { $1 }
               | PrecedenceAssign { $1 }
               | ModuleLevelBindingExp { $1 }

InteractiveExp : InterfaceDecExp { $1 }
               | TypeDec { ExpTypeDec (nodeData $1) $1 }
               | ModuleDec { $1 }
               | PrecedenceAssign { $1 }
               | ExpOrAssign { $1 }

ImportExp : import SimpleOrQualifiedId { ExpImport (pos $1) $2 }
          | import SimpleOrQualifiedId '=' simple_id { ExpImportAs (pos $1) $2 (tokValue $4) }

CommaSeparatedSimpleOrMixedIds : AnyId { [tokValue $1] }
                               | CommaSeparatedSimpleOrMixedIds ',' AnyId { $1 ++ [tokValue $3] }

ImportExceptClause : except '(' CommaSeparatedSimpleOrMixedIds ')' { ImportClauseExcept (pos $1) $3 }

Renaming : AnyId '->' AnyId { (tokValue $1, tokValue $3) }

CommaSeparatedRenamings : Renaming { [$1] }
                        | CommaSeparatedRenamings ',' Renaming { $1 ++ [$3] }

ImportRenamingClause : renaming '(' CommaSeparatedRenamings ')' { ImportClauseRenaming (pos $1) $3 }

ImportClause : ImportExceptClause { $1 }
             | ImportRenamingClause { $1 }

ImportClauses : ImportClause { [$1] }
              | ImportClauses ImportClause { $1 ++ [$2] }

ImportSubset : '(' CommaSeparatedSimpleOrMixedIds ')' { $2 }


SelectiveImportExp : ImportExp ImportSubset '{' ImportClauses '}' { ExpSelectiveImport (nodeData $1) $1 $2 $4 }
                   | ImportExp '{' ImportClauses '}' { ExpSelectiveImport (nodeData $1) $1 [] $3 }
                   | ImportExp ImportSubset { ExpSelectiveImport (nodeData $1) $1 $2 [] }
                   | ImportExp { $1 }


ModuleDec : module SimpleOrQualifiedId '{' ZeroOrMoreModuleLevelExps '}'
  { ExpModule (pos $3) $2 $4 }

Constraint : when simple_id ':' simple_id { Constraint (pos $1) (tokValue $2) (tokValue $4) }

Constraints : Constraint { [$1] }
            | Constraints Constraint { $1 ++ [$2] }
            | {- empty -} { [] }

ProtoDecBody : '{' ZeroOrMoreTyAnns '}' { $2 }

ProtoDec : protocol simple_id '(' simple_id ')' Constraints ProtoDecBody
           { ExpProtoDec (pos $1) (tokValue $2) (tokValue $4) $6 $7 }

ProtoImp : imp SimpleOrMixedId '(' SimpleTy ')' Constraints '{' ZeroOrMoreModuleLevelBindingExps '}' { ExpProtoImp (pos $1) $4 (tokValue $2) $6 $8 }

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

AdtPatExp : SimpleOrQualifiedId '(' ZeroOrMorePatExps ')' { PatExpAdt (nodeData $1) $1 $3 }
          | QualifiedId { PatExpAdt (nodeData $1) $1 [] }

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

ListPatExp : AtomPatExp '@' ListPatExp { PatExpListCons (nodeData $1) $1 $3 }
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

SingleParamFunHeader : fun '(' PatExp ')' { (pos $1, $3) }

MultiParamFunHeader : fun '(' PatExpList ',' PatExp ')' { (pos $1, $3 ++ [$5]) }

FunHeader : SingleParamFunHeader { (fst $1, [snd $1]) }
          | MultiParamFunHeader { $1 }
          | fun '(' ')' { (pos $1, []) }

CommaSeparatedLiteralExps : LiteralExp { [$1] }
													| CommaSeparatedLiteralExps ',' LiteralExp { $1 ++ [$3] }
													| {- empty -} { [] }

LiteralListExp : '[' CommaSeparatedLiteralExps ']' { ExpList (pos $1) $2 }

LiteralExp : num { ExpNum (pos $1) (tokValue $1) }
           | True { ExpBool (pos $1) True }
           | False { ExpBool (pos $1) False }
           | string { ExpString (pos $1) (tokValue $1) }
           | char { ExpChar (pos $1) (tokValue $1) }
           | SimpleOrQualifiedId { ExpQualifiedRef (nodeData $1) $1 }

AtomExp : '(' Exp ')' { ExpInParens (nodeData $2) $2 }
        | '(' ')' { ExpUnit (pos $1) }
        | '(' SpecialId ')' { ExpRef (pos $1) (tokValue $2) }
        | '%(' Exp TupleRestExps ')' { ExpTuple (pos $1) ($2:$3) }
        | ListExp { $1 }
        | SimpleOrQualifiedId '%{' StructFieldInitializers '}' { ExpStruct (nodeData $1) $1 $3 }
        | FunHeader FunBody { ExpFun (fst $1) (snd $1) $2 }
        | prim '(' simple_id ')' { ExpPrim (pos $1) (tokValue $3) }
        | LiteralExp { $1 }

MemberAccessExp : AppExp '#' SimpleOrMixedId { ExpMemberAccess (nodeData $1) $1 (tokValue $3) }
                | AtomExp { $1 }

AppExp : AppExp '(' ArgExps ')' { ExpApp (nodeData $1) $1 $3 }
       | MemberAccessExp { $1 }

ConsExp : AppExp '@' ConsExp { ExpCons (nodeData $1) $1 $3 }
        | AppExp { $1 }

CustomInfixExp : CustomInfixExp SpecialId ConsExp { ExpCustomInfix (nodeData $1) $1 (tokValue $2) $3 }
               | ConsExp { $1 }

IfElseExp : if '(' Exp ')' Exp Exp { ExpIfElse (pos $1) $3 $5 $6 }

Exp : CustomInfixExp { $1 }
    | IfElseExp { $1 }
    | switch '(' Exp ')' '{' CaseClauses '}' { ExpSwitch (pos $1) $3 $6 }
    | cond '{' CondCaseClauses '}' { ExpCond (pos $1) $3 }
    | Block { $1 }

ExpOrAssign : let PatExp '=' Exp { ExpAssign (pos $1) $2 $4 }
            | TyAnn { ExpTyAnn $1 }
            | import SimpleOrQualifiedId { ExpImport (pos $1) $2 }
            | import SimpleOrQualifiedId '=' simple_id { ExpImportAs (pos $1) $2 (tokValue $4) }
            | Exp { $1 }

ExpOrAssigns : ExpOrAssign { [$1] }
             | ExpOrAssigns ExpOrAssign { $1 ++ [$2] }

ModuleLevelBindingExp : let PatExp '=' LiteralExp { ExpTopLevelAssign (pos $1) $2 $4 }
                      | let PatExp '=' LiteralListExp { ExpTopLevelAssign (pos $1) $2 $4 }
                      | FunDef { ExpFunDef $1 }
                      | TyAnn { ExpTopLevelTyAnn $1 }
                      | SelectiveImportExp { $1 }

ZeroOrMoreModuleLevelBindingExps : ModuleLevelBindingExp { [$1] }
                                 | ZeroOrMoreModuleLevelBindingExps ModuleLevelBindingExp { $1 ++ [$2] }
                                 | {- empty -} { [] }

PrecedenceAssign : precedence SpecialId num { ExpPrecAssign (pos $1) (tokValue $2) (read (tokValue $3)) }

FunDef : SimpleOrMixedId '(' PatExpList ')' FunBody { FunDefFun (pos $1) (tokValue $1) $3 $5 }
       | infixl '(' SpecialId ')' '(' PatExpList ')' FunBody { FunDefFun (pos $1) (tokValue $3) $6 $8 }

FunBody : '=' Exp { $2 }

TyParams : '<' CommaSeparatedIds '>' { $2 }
         | {- empty -} { [] }

TyAnn : SimpleOrMixedId ':' Ty Constraints { TyAnn (pos $1) (tokValue $1) [] $3 $4 }
      | SimpleOrMixedId '<' CommaSeparatedIds '>' ':' Ty Constraints { TyAnn (pos $1) (tokValue $1) $3 $6 $7 }
      | infixl '(' SpecialId ')' TyParams ':' Ty Constraints { TyAnn (pos $1) (tokValue $3) $5 $7 $8 }

OneOrMoreTyAnns : TyAnn { [$1] }
                | OneOrMoreTyAnns TyAnn { $1 ++ [$2] }

ZeroOrMoreTyAnns : OneOrMoreTyAnns { $1 }
                 | {- empty -} { [] }

InterfaceDecExp: interface SimpleOrMixedId TyParams '{' OneOrMoreTyAnns '}' { ExpInterfaceDec (pos $1) (tokValue $2) $3 $5 }

CaseClauses : CaseClause { [$1] }
            | CaseClauses CaseClause { $1 ++ [$2] }

CaseClause : PatExp '->' Exp { CaseClause (nodeData $1) $1 $3 }

CondCaseClauses : CondCaseClause { [$1] }
                | CondCaseClauses CondCaseClause { $1 ++ [$2] }

CondCaseClause : Exp '->' Exp { CondCaseClause (nodeData $1) $1 $3 }
               | '_' '->' Exp { CondCaseClauseWildcard (pos $1) $3 }

ArgExps : Exp { [$1] }
        | ArgExps ',' Exp { $1 ++ [$3] }
        | {- empty -} { [] }

FunParams : SimpleOrMixedId { [tokValue $1] }
          | FunParams ',' SimpleOrMixedId { $1 ++ [tokValue $3] }
          | {- empty -} { [] }

TypeDecImplicit : type TyParams Ty { TypeDecImplicit (pos $1) (TypeDecTy (nodeData $3) "<implicit>" $2 $3) }
                | type TyParams AdtAlternatives { TypeDecImplicit (pos $1) (TypeDecAdt (pos $1) "<implicit>" $2 $3) }

TypeDec : type SimpleOrMixedId TyParams '=' Ty { TypeDecTy (pos $1) (tokValue $2) $3 $5 }
        | type SimpleOrMixedId TyParams '=' AdtAlternatives { TypeDecAdt (pos $1) (tokValue $2) $3 $5 }
        | TypeDecImplicit { $1 }

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

TyArgs : '<' CommaSeparatedTys '>' { $2 }
       | {- empty -} { [] }

SimpleTy : primtype '(' simple_id ')' { SynTyPrim (pos $1) (tokValue $3) }
         | struct '{' TyStructFields '}' { SynTyStruct (pos $1) $3 }
         | TyTuple { $1 }
         | SimpleOrQualifiedAlphaNumericId TyArgs { SynTyRef (nodeData $1) $1 $2 }
         | SimpleTy '[' ']' { SynTyList (nodeData $1) $1 }
         | '(' Ty ')' { $2 }

TyArrow : SimpleTy { [$1] }
        | SimpleTy '->' TyArrow { $1 : $3 }
        | '(' '->' Ty ')' { [SynTyArrow (pos $1) [] $3] }

Ty : TyArrow { if length $1 == 1 then head $1 else SynTyArrow (firstPos $1) (take (length $1 - 1) $1) (last $1) }

TyStructField : SimpleOrMixedId ':' Ty { (tokValue $1, $3) }

TyStructFields : TyStructField { [$1] }
               | TyStructFields TyStructField { $1 ++ [$2] }
               | {- empty -} { [] }

StructFieldInitializer : SimpleOrMixedId '=' Exp ';' { FieldInit (tokValue $1) $3 }

StructFieldInitializers : StructFieldInitializer { [$1] }
                        | StructFieldInitializers StructFieldInitializer { $1 ++ [$2] }
                        | {- empty -} { [] }

SimpleOrQualifiedId : SimpleOrMixedId  { Id (pos $1) (tokValue $1) }
                    | QualifiedId { $1 }

SimpleOrQualifiedAlphaNumericId : simple_id { Id (pos $1) (tokValue $1) }
                                | SimpleOrQualifiedId '.' simple_id { Path (nodeData $1) $1 (tokValue $3) }

QualifiedId : SimpleOrQualifiedId '.' SimpleOrMixedId { Path (nodeData $1) $1 (tokValue $3) }

SimpleOrMixedId : simple_id { $1 }
                | mixed_id { $1 }

SpecialId : special_id { $1 }
          | '=' { Token (pos $1) $ TokenSpecialId "=" }
          | '=' SpecialId { Token (pos $1) $ TokenSpecialId $ "=" ++ tokValue $2 }
          | '|' { Token (pos $1) $ TokenSpecialId "|" }
          | '|' SpecialId { Token (pos $1) $ TokenSpecialId $ "|" ++ tokValue $2 }
          | '<' { Token (pos $1) $ TokenSpecialId "<" }
          | '>' { Token (pos $1) $ TokenSpecialId ">" }
          | '<' SpecialId { Token (pos $1) $ TokenSpecialId $ "<" ++ tokValue $2 }
          | '>' SpecialId { Token (pos $1) $ TokenSpecialId $ ">" ++ tokValue $2 }

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

getIdStr :: Token -> Alex String
getIdStr tok@(Token _ tokC) =
  case tokC of
    TokenSimpleId s  -> return s
    TokenMixedId s   -> return s
    TokenSpecialId s -> return s
    _                -> happyError tok

expectContextSensitiveKw :: Token -> String -> Alex Bool
expectContextSensitiveKw tok matchStr = do
  str <- getIdStr tok
  unless (str == matchStr) $ happyError tok
  return True 

happyError :: Token -> Alex a
happyError (Token (SourcePos _ line col) t) =
  alexError' (AlexPn 0 line col) ("parse error at token '" ++ unlex t ++ "'")

}
