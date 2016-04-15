module Types where

import AlphaConvert
import Common
import Control.Monad.Except
import Control.Monad.State
import Data.List
import qualified Data.Map as Map
import qualified Syntax as S

type TyVar = UniqId
type FieldName = UniqId
type TypeName = UniqId

data Ty =
    App TyCon [Ty]
  | Poly [TyVar] Ty
  | Var TyVar
  deriving (Eq, Show)

data TyCon =
    Int
  | Bool
  | String
  | Unit
  | List
  | Tuple
  | Struct [FieldName]
  | Module [TypeName] [FieldName]
  | TyFun [TyVar] Ty
  deriving (Eq, Show)

data TCEnv = TCEnv
  { typeEnv :: Map.Map UniqId TyCon
  , varEnv :: Map.Map UniqId Ty
  , alphaEnv :: AlphaEnv
  }
  deriving (Eq, Show)

mtEnv :: AlphaEnv -> TCEnv
mtEnv alphaEnv =
  TCEnv
    { typeEnv = Map.empty
    , varEnv = Map.empty
    , alphaEnv = alphaEnv
    }

type Checked a = ExceptT FailMessage (State TCEnv) a


mtApp :: TyCon -> Ty
mtApp tyCon = App tyCon []


freshId :: Checked UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let (uniqId, alphaEnv') = fresh "t" alphaEnv
  modify (\tcEnv -> tcEnv { alphaEnv = alphaEnv' })
  return uniqId


unifyAll :: [Ty] -> Checked Ty
unifyAll [] = return $ mtApp Int


tc :: S.Exp UniqId -> Checked Ty
tc S.ExpUnit = return $ mtApp Unit
tc (S.ExpString _) = return $ mtApp String
tc (S.ExpBool _) = return $ mtApp Bool
tc (S.ExpNum _) = return $ mtApp Int

tc (S.ExpList []) = do
  newTyVar <- freshId
  return $ Poly [newTyVar] $ App List [Var newTyVar]

tc (S.ExpList es) = do
  tys <- mapM tc es
  elemTy <- unifyAll tys
  return $ App List [elemTy]


tcEs :: [S.Exp UniqId] -> Checked Ty
tcEs [] = return $ mtApp Unit
tcEs es = do
  tys <- mapM tc es
  return $ last tys


typeCheck :: S.CompUnit UniqId -> AlphaEnv -> Either FailMessage (Ty, AlphaEnv)
typeCheck (S.CompUnit es) aEnv = do
  (tyResult, tcEnv) <- return $ runState (runExceptT $ tcEs es) $ mtEnv aEnv
  ty <- tyResult
  return (ty, alphaEnv tcEnv)
