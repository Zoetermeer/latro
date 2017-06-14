module Latro.Parser where

import Data.Bifunctor (first)
import Latro.Ast
import Latro.Errors
import Latro.Grammar
import Latro.Lex


parse :: Alex a -> FilePath -> String -> Either Err a
parse rule filePath input = first (\errMsg -> ErrSyntax errMsg) $ runAlex' rule filePath input


parseInteractive :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseInteractive = parse ruleParseInteractive


parseTopLevel :: FilePath -> String -> Either Err (CompUnit SourcePos RawId)
parseTopLevel = parse ruleParseTopLevel
