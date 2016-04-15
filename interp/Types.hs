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

data TCError =
    ErrCantUnify Ty Ty
  | ErrNotImplemented
  deriving (Eq)

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

type Checked a = ExceptT TCError (State TCEnv) a


mtApp :: TyCon -> Ty
mtApp tyCon = App tyCon []


-- Shortcuts for primitive types
tyInt :: Ty
tyInt = mtApp Int

tyBool :: Ty
tyBool = mtApp Bool

tyStr :: Ty
tyStr = mtApp String


freshId :: Checked UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let (uniqId, alphaEnv') = fresh "t" alphaEnv
  modify (\tcEnv -> tcEnv { alphaEnv = alphaEnv' })
  return uniqId


unify :: Ty -> Ty -> Checked Ty
unify a@(App tyconA tyArgsA) b@(App tyconB tyArgsB) =
  if tyconA == tyconB
  then do mapM_ (uncurry unify) $ zip tyArgsA tyArgsB
          return a
  else throwError $ ErrCantUnify a b


unifyAll :: [Ty] -> Checked Ty
unifyAll [] = freshId >>= return . Var
unifyAll [ty] = return ty
unifyAll (ta:tb:tys) = do
  ty' <- unify ta tb
  unifyAll (ty':tys)


tcArith :: S.Exp UniqId -> S.Exp UniqId -> Checked Ty
tcArith a b = do
  tc a >>= unify tyInt
  tc b >>= unify tyInt
  return tyInt

tc :: S.Exp UniqId -> Checked Ty
tc S.ExpUnit = return $ mtApp Unit
tc (S.ExpRef id) = throwError ErrNotImplemented
tc (S.ExpString _) = return $ mtApp String
tc (S.ExpBool _) = return $ mtApp Bool
tc (S.ExpNum _) = return $ mtApp Int

tc (S.ExpAdd a b) = tcArith a b
tc (S.ExpSub a b) = tcArith a b
tc (S.ExpDiv a b) = tcArith a b
tc (S.ExpMul a b) = tcArith a b

tc (S.ExpCons headE listE) = do
  tyListE <- tc listE
  tyHeadE <- tc headE
  unify tyListE $ App List [tyHeadE]

tc (S.ExpNot e) = do
  te <- tc e >>= unify tyBool
  return tyBool

tc (S.ExpFun _ _) = throwError ErrNotImplemented

tc (S.ExpList []) = do
  newTyVar <- freshId
  return $ Poly [newTyVar] $ App List [Var newTyVar]

tc (S.ExpList es) = do
  tys <- mapM tc es
  elemTy <- unifyAll tys
  return $ App List [elemTy]

tc (S.ExpSwitch e clauses) = throwError ErrNotImplemented

tc (S.ExpTuple es) = do
  tys <- mapM tc es
  return $ App Tuple tys

tc (S.ExpMakeAdt synTy i es) = throwError ErrNotImplemented

tc (S.ExpIfElse testE thenEs elseEs) = do
  testTy <- tc testE >>= unify tyBool
  thenTy <- tcEs thenEs
  elseTy <- tcEs elseEs
  unify thenTy elseTy


tcEs :: [S.Exp UniqId] -> Checked Ty
tcEs [] = return $ mtApp Unit
tcEs es = do
  tys <- mapM tc es
  return $ last tys


typeCheck :: S.CompUnit UniqId -> AlphaEnv -> Either TCError (Ty, AlphaEnv)
typeCheck (S.CompUnit es) aEnv = do
  (tyResult, tcEnv) <- return $ runState (runExceptT $ tcEs es) $ mtEnv aEnv
  ty <- tyResult
  return (ty, alphaEnv tcEnv)
