module AlphaConvert (UniqId(..), alphaConvert, showHum) where

import Common
import Control.Monad.Except
import Control.Monad.State
import Data.List (find)
import Prelude hiding (lookup)
import Syntax
import Text.Printf (printf)

data UniqId =
    UserId RawId
  | UniqId Int RawId

instance Eq UniqId where
  (UserId raw) == (UserId raw') = raw == raw'
  (UserId raw) == (UniqId _ raw') = raw == raw'
  (UniqId c _) == (UniqId c' _) = c == c'
  a == b = b == a

instance Show UniqId where
  show (UserId raw) = raw
  show (UniqId _ raw) = raw


showHum :: UniqId -> String
showHum (UserId id) = id
showHum (UniqId _ id) = id


data AlphaEnv = AlphaEnv Int [(RawId, UniqId)]
  deriving (Eq, Show)


type AlphaConverted a = ExceptT FailMessage (State AlphaEnv) a


fresh :: RawId -> AlphaConverted UniqId
fresh id = do
  (AlphaEnv counter table) <- lift get
  let counter' = counter + 1
      uniqId = UniqId counter id
  lift $ put $ AlphaEnv counter' ((id, uniqId):table)
  return uniqId


lookup :: RawId -> AlphaConverted UniqId
lookup id = do
  (AlphaEnv _ table) <- lift get
  let maybeUniqId = find (\(key, uid) -> key == id) table
  case maybeUniqId of
    Just uniqId -> return $ snd uniqId
    Nothing ->
      throwError $ printf "Unbound identifier '%s'" id


convertBin :: (Exp UniqId -> Exp UniqId -> Exp UniqId) -> Exp RawId -> Exp RawId -> AlphaConverted (Exp UniqId)
convertBin c a b = do
  a' <- convert a
  b' <- convert b
  return $ c a' b'


convertQualId :: QualifiedId RawId -> AlphaConverted (QualifiedId UniqId)
convertQualId (Id id) = do
  id' <- lookup id
  return $ Id id'

convertQualId (Path qid id) = do
  qid' <- convertQualId qid
  id' <- lookup id
  return $ Path qid' id'

convertTy :: Ty RawId -> AlphaConverted (Ty UniqId)
convertTy TyInt = return TyInt
convertTy TyBool = return TyBool
convertTy TyUnit = return TyUnit
convertTy (TyArrow paramTys retTy) = do
  paramTys' <- mapM convertTy paramTys
  retTy' <- convertTy retTy
  return $ TyArrow paramTys' retTy'

convertTy TyModule = return TyModule
convertTy TyInterface = return TyInterface
convertTy (TyRef qid) = do
  qid' <- convertQualId qid
  return $ TyRef qid'


convertAdtAlternative :: AdtAlternative RawId -> AlphaConverted (AdtAlternative UniqId)
convertAdtAlternative (AdtAlternative id tys) = do
  id' <- fresh id
  tys' <- mapM convertTy tys
  return $ AdtAlternative id' tys'


convertPatExp :: PatExp RawId -> AlphaConverted (PatExp UniqId)
convertPatExp (PatExpVar id) = do
  id' <- fresh id
  return $ PatExpVar id'


convertFunDef :: FunDef RawId -> AlphaConverted (FunDef UniqId)
convertFunDef (FunDefFun id argPatEs bodyEs) = do
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- lookup id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefFun id' argPatEs' bodyEs'

convertFunDef (FunDefInstFun instPatE id argPatEs bodyEs) = do
  instPatE' <- convertPatExp instPatE
  argPatEs' <- mapM convertPatExp argPatEs
  id' <- fresh id
  bodyEs' <- mapM convert bodyEs
  return $ FunDefInstFun instPatE' id' argPatEs' bodyEs'


convert :: Exp RawId -> AlphaConverted (Exp UniqId)
convert (ExpAdd a b) = convertBin ExpAdd a b
convert (ExpSub a b) = convertBin ExpSub a b
convert (ExpDiv a b) = convertBin ExpDiv a b
convert (ExpMul a b) = convertBin ExpMul a b
convert (ExpNot e) = do
  e' <- convert e
  return $ ExpNot e'

convert (ExpMemberAccess e id) = do
  e' <- convert e
  return $ ExpMemberAccess e' (UserId id)

convert (ExpApp ratorE randEs) = do
  ratorE' <- convert ratorE
  randEs' <- mapM convert randEs
  return $ ExpApp ratorE' randEs'

convert (ExpAssign id e) = do
  e' <- convert e
  id' <- fresh id
  return $ ExpAssign id' e'

convert (ExpTypeDec (TypeDecTy id ty)) = do
  id' <- fresh id
  ty' <- convertTy ty
  return $ ExpTypeDec $ TypeDecTy id' ty'

convert (ExpTypeDec (TypeDecAdt id alts)) = do
  id' <- fresh id
  alts' <- mapM convertAdtAlternative alts
  return $ ExpTypeDec $ TypeDecAdt id' alts'

convert (ExpFunDec (FunDecFun id funTy fundefs)) = do
  id' <- fresh id
  funTy' <- convertTy funTy
  fundefs' <- mapM convertFunDef fundefs
  return $ ExpFunDec $ FunDecFun id' funTy' fundefs'

convert (ExpFunDec (FunDecInstFun id instTy funTy fundefs)) = do
  id' <- fresh id
  instTy' <- convertTy instTy
  funTy' <- convertTy funTy
  fundefs' <- mapM convertFunDef fundefs
  return $ ExpFunDec $ FunDecInstFun id' instTy' funTy' fundefs'

convert (ExpModule bodyEs) = do
  bodyEs' <- mapM convert bodyEs
  return $ ExpModule bodyEs'

convert (ExpIfElse condE thenEs elseEs) = do
  condE' <- convert condE
  thenEs' <- mapM convert thenEs
  elseEs' <- mapM convert elseEs
  return $ ExpIfElse condE' thenEs' elseEs'

convert (ExpNum s) = return $ ExpNum s
convert (ExpBool b) = return $ ExpBool b
convert (ExpRef id) = do
  id' <- lookup id
  return $ ExpRef id'


alphaConvert :: CompUnit RawId -> Either FailMessage (CompUnit UniqId)
alphaConvert (CompUnit exps) = do
  exps' <- evalState (runExceptT $ mapM convert exps) (AlphaEnv 1 [])
  return $ CompUnit exps'
