module AlphaConvert where

import Common
import Control.Monad.Except
import Control.Monad.State
import Syntax

data UniqId =
    UserId RawId
  | UniqId Int RawId
  deriving (Eq, Show)


type RenameEnv = Env RawId UniqId
type AlphaConverted a = ExceptT FailMessage (State RenameEnv) a

alphaConvert :: CompUnit RawId -> Either FailMessage (CompUnit UniqId)
alphaConvert (CompUnit _) = return $ CompUnit []
