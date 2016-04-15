module Types where

import AlphaConvert
import Common
import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
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
  | ErrUndefinedMember UniqId
  | ErrInvalidStructType TyCon
  | ErrNotImplemented String
  | ErrUnboundIdentifier UniqId
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


-- Convenience methods for manipulating the environment
putTyBinding :: UniqId -> TyCon -> Checked ()
putTyBinding id ty = do
  modify (\tcEnv -> tcEnv { typeEnv = Map.insert id ty (typeEnv tcEnv) })


mtApp :: TyCon -> Ty
mtApp tyCon = App tyCon []


-- Shortcuts for primitive types
tyInt :: Ty
tyInt = mtApp Int

tyBool :: Ty
tyBool = mtApp Bool

tyStr :: Ty
tyStr = mtApp String

tyUnit :: Ty
tyUnit = mtApp Unit


freshId :: Checked UniqId
freshId = do
  alphaEnv <- gets alphaEnv
  let (uniqId, alphaEnv') = fresh "t" alphaEnv
  modify (\tcEnv -> tcEnv { alphaEnv = alphaEnv' })
  return uniqId


lookupTy :: UniqId -> Checked TyCon
lookupTy id = do
  tyConEnv <- gets typeEnv
  hoistEither $ maybeToEither (ErrUnboundIdentifier id) $ Map.lookup id tyConEnv


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


tcTy :: S.Ty UniqId -> Checked Ty
tcTy S.TyInt = return tyInt
tcTy S.TyBool = return tyBool
tcTy S.TyString = return tyStr
tcTy S.TyUnit = return tyUnit


tcTyDec :: S.TypeDec UniqId -> Checked TyCon
tcTyDec (S.TypeDecTy id S.TyInt) = return Int
tcTyDec (S.TypeDecTy id (S.TyStruct fields)) =
  let (fieldNames, fieldSynTys) = unzip fields
  in do
    fieldTys <- mapM tcTy fieldSynTys
    return $ TyFun [] $ App (Struct fieldNames) fieldTys


-- The language grammar only permits the expression
-- to be a MemberAccessExp, which is either an application
-- followed by a '. ID', or an atom expression.
-- The reason this must be an expression (and not a qualified identifier)
-- is that we can access some type defined on an inline module, for example.
-- module { type t = ...; }.t { ... };
--
-- Which is odd, but is permitted (at least at the syntactic level).
-- The question is (1) why anyone would want to do that, and (2)
-- how (or if) we need to refer to the type of this object elsewhere.
-- We are allowing a value to escape "further" than its corresponding type.
tcTyconExp :: S.Exp UniqId -> Checked TyCon
tcTyconExp (S.ExpRef id) = lookupTy id


tcStructFields :: [(UniqId, Ty)] -> [(UniqId, S.Exp UniqId)] -> Checked Ty
tcStructFields _ [] = return tyUnit
tcStructFields tyFields ((fieldId, fieldExp):fieldInitExps) =
  let maybeField = find (flip ((==) . fst) fieldId) tyFields
  in
    case maybeField of
      Nothing -> throwError $ ErrUndefinedMember fieldId
      Just (matchedFieldId, matchedTy) -> do
        initExpTy <- tc fieldExp
        unify matchedTy initExpTy
        tcStructFields tyFields fieldInitExps


tc :: S.Exp UniqId -> Checked Ty
tc S.ExpUnit = return $ mtApp Unit
tc (S.ExpRef id) = throwError $ ErrNotImplemented "tc"
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
  case tyListE of
    App List _ -> unify tyListE $ App List [tyHeadE]
    _ -> unify (App List [tyHeadE]) tyListE

tc (S.ExpNot e) = do
  te <- tc e >>= unify tyBool
  return tyBool

tc (S.ExpFun _ _) = throwError $ ErrNotImplemented "tc"

tc (S.ExpList []) = do
  newTyVar <- freshId
  return $ Poly [newTyVar] $ App List [Var newTyVar]

tc (S.ExpList es) = do
  tys <- mapM tc es
  elemTy <- unifyAll tys
  return $ App List [elemTy]

tc (S.ExpSwitch e clauses) = throwError $ ErrNotImplemented "tc"

tc (S.ExpTuple es) = do
  tys <- mapM tc es
  return $ App Tuple tys

tc (S.ExpMakeAdt synTy i es) = throwError $ ErrNotImplemented "tc"

tc (S.ExpStruct strSynTyE fieldInitEs) = do
  structTyCon <- tcTyconExp strSynTyE
  case structTyCon of
    TyFun [] structTyConApp@(App (Struct fids) ftys) -> do
      tcStructFields (zip fids ftys) fieldInitEs
      return structTyConApp
    _ -> throwError $ ErrInvalidStructType structTyCon

tc (S.ExpIfElse testE thenEs elseEs) = do
  testTy <- tc testE >>= unify tyBool
  thenTy <- tcEs thenEs
  elseTy <- tcEs elseEs
  unify thenTy elseTy

tc (S.ExpTypeDec tyDec) =
  let id = S.getTypeDecId tyDec
  in do
    tycon <- tcTyDec tyDec
    putTyBinding id tycon
    return tyUnit


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
