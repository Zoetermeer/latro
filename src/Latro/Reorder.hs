module Reorder where

import Common
import Errors
import Semant


reorderInfixes :: UniqAst CompUnit -> Either Err (UniqAst CompUnit)
reorderInfixes compUnit = return compUnit
