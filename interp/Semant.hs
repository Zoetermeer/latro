{-# LANGUAGE NamedFieldPuns #-}
module Semant where

import AlphaConvert
import Common
import Control.Error.Util (hoistEither)
import Control.Monad.Except
import Control.Monad.State
import Data.Either.Utils (maybeToEither)
import Data.Functor.Identity (runIdentity)
import Data.List hiding (lookup)
import qualified Data.Map as Map
import Data.Monoid ((<>), mempty)
import Parse
import Prelude hiding (lookup)
import Syntax
import Text.Printf (printf)

type VEnv = Map.Map UniqId Value
type TEnv = Map.Map UniqId (Ty UniqId)

showMap :: (Show k, Show v) => Map.Map k v -> String
showMap m =
  intersperse ',' $ concat $ map show $ Map.keys m

data ClosureEnv = ClosureEnv
  { cloTypeEnv :: TEnv
  , cloVarEnv :: VEnv
  }
  deriving (Eq, Show)

instance PrettyShow ClosureEnv where
  showShort (ClosureEnv { cloTypeEnv, cloVarEnv }) =
      printf "(Closure [%s] [%s])" typeStr varStr
    where
      typeStr = showMap cloTypeEnv
      varStr = showMap cloVarEnv


data Exports = Exports
  { exportTypes :: TEnv
  , exportVars :: VEnv
  }
  deriving (Eq, Show)

instance PrettyShow Exports where
  showShort (Exports { exportTypes, exportVars }) =
      printf "(Exports [%s] [%s])" typeStr varStr
    where
      typeStr = showMap exportTypes
      varStr = showMap exportVars


data InterpEnv = InterpEnv
  { typeEnv :: TEnv
  , varEnv  :: VEnv
  , curModule :: Module
  }
  deriving (Eq, Show)

-- A module value has two environments:
-- A closure environment, and an export
-- environment.  A name lookup on a module
-- can't search the closure environment, so we
-- separate them
data Module = Module ClosureEnv Exports
  deriving (Eq, Show)

instance PrettyShow Module where
  showShort (Module cloEnv exports) =
    printf "<module %s %s>" (showShort cloEnv) (showShort exports)
  showLong m = show m

data Closure = Closure UniqId ClosureEnv [UniqId] [Exp UniqId]
  deriving (Eq, Show)

data Struct = Struct UniqId [(UniqId, Value)]
  deriving (Eq, Show)

data Value =
    ValueInt Int
  | ValueBool Bool
  | ValueStr String
  | ValueModule Module
  | ValueFun Closure
  | ValueStruct Struct
  | ValueUnit
  | Err String
  deriving (Eq)

instance Show Value where
  show (ValueInt i) = show i
  show (ValueBool b) = show b
  show (ValueStr s) = s
  show (ValueModule m) = showShort m
  show (ValueFun (Closure id _ _ _)) = printf "<closure %s>" $ show id
  show ValueUnit = "()"
  show (Err msg) = "Error: " ++ msg

-- An evaluator monad is a possibly-failing computation
-- with a state: (variable environment, current module)
-- The variable environment maps ID --o--> Value
-- The "current module" is the module currently being evaluated,
-- at the top level it's an invented anonymous one.
-- The top-level anonymous module gives the nice property
-- that bindings at the top (not in any explicitly defined
-- module) are closed over in submodules, but will
-- not be accessible from other compilation units.
-- Each new binding occurrence adds the id to the current
-- module's list of exports
type Eval a = ExceptT FailMessage (State InterpEnv) a

mtClosureEnv :: ClosureEnv
mtClosureEnv = ClosureEnv { cloTypeEnv = Map.empty
                          , cloVarEnv = Map.empty
                          }

mtExports :: Exports
mtExports = Exports { exportTypes = Map.empty
                    , exportVars =  Map.empty
                    }

mtInterpEnv :: InterpEnv
mtInterpEnv =
    InterpEnv
      { typeEnv = Map.empty
      , varEnv = Map.empty
      , curModule = mod
      }
  where
    mod = Module mtClosureEnv mtExports


lookup :: UniqId -> Map.Map UniqId v -> Eval v
lookup id map =
    hoistEither eithV
  where
    eithV = maybeToEither errMsg $ Map.lookup id map
    errMsg = printf "Unbound identifier '%s'" $ show id


lookupQualIn  :: QualifiedId UniqId
              -> InterpEnv
              -> (Exports -> Map.Map UniqId a)
              -> (InterpEnv -> Map.Map UniqId a)
              -> Eval a
lookupQualIn (Id id) intEnv _ extractAEnv = lookup id $ extractAEnv intEnv
lookupQualIn (Path qid id) intEnv extractExportEnv _ = do
  (ValueModule (Module _ exports)) <- lookupQualIn qid intEnv exportVars varEnv
  lookup id $ extractExportEnv exports

lookupTyQualIn :: QualifiedId UniqId -> InterpEnv -> Eval (Ty UniqId)
lookupTyQualIn id intEnv = lookupQualIn id intEnv exportTypes typeEnv

lookupVarQualIn :: QualifiedId UniqId -> InterpEnv -> Eval Value
lookupVarQualIn id intEnv = lookupQualIn id intEnv exportVars varEnv


lookupVarQual :: QualifiedId UniqId -> Eval Value
lookupVarQual id = get >>= lookupVarQualIn id


lookupTyQual :: QualifiedId UniqId -> Eval (Ty UniqId)
lookupTyQual id = get >>= lookupTyQualIn id


lookupVarId :: UniqId -> Eval Value
lookupVarId id = getVarEnv >>= lookup id


getVarEnv :: Eval VEnv
getVarEnv = gets varEnv


getTyEnv :: Eval TEnv
getTyEnv = gets typeEnv


putVarBinding :: UniqId -> Value -> Eval ()
putVarBinding id v = do
  modify (\intEnv -> intEnv { varEnv = Map.insert id v (varEnv intEnv) })


addToEnv :: UniqId -> a -> Env UniqId a -> Env UniqId a
addToEnv id v (Env table) = Env ((id, v):table)


putModuleExport :: UniqId -> Value -> Eval ()
putModuleExport id v = do
  modify (\intEnv ->
            let (Module cloEnv exports) = curModule intEnv
                exports' = exports { exportVars = Map.insert id v (exportVars exports) }
            in
              intEnv { curModule = Module cloEnv exports' })


pushNewModuleContext :: Eval InterpEnv
pushNewModuleContext = do
  curEnv <- get
  let modCloEnv = ClosureEnv { cloTypeEnv = typeEnv curEnv, cloVarEnv = varEnv curEnv }
  modify (\intEnv -> intEnv { curModule = Module modCloEnv mtExports })
  return curEnv


restoreEnv :: InterpEnv -> Eval ()
restoreEnv intEnv = put intEnv


-- This is a placeholder; to be replaced
-- by real pattern matching
patExpBindingId :: PatExp UniqId -> UniqId
patExpBindingId (PatExpVar id) = id


type BinOp = Int -> Int -> Int

evalBinArith :: BinOp -> Exp UniqId -> Exp UniqId -> Eval Value
evalBinArith f a b = do
  (ValueInt a') <- evalE a
  (ValueInt b') <- evalE b
  return $ ValueInt $ f a' b'


evalE :: Exp UniqId -> Eval Value
evalE (ExpNum str) = return $ ValueInt $ read str
evalE (ExpBool b) = return $ ValueBool b
evalE (ExpAdd a b) = evalBinArith (+) a b
evalE (ExpSub a b) = evalBinArith (-) a b
evalE (ExpDiv a b) = evalBinArith quot a b
evalE (ExpMul a b) = evalBinArith (*) a b

evalE (ExpTypeDec _) = return ValueUnit

evalE (ExpModule moduleEs) = do
  oldEnv <- pushNewModuleContext
  mapM_ evalE moduleEs
  newModule <- gets curModule
  restoreEnv oldEnv
  return $ ValueModule newModule

evalE (ExpFunDec (FunDecFun id _ [])) = do
  throwError $ printf "No definition given for function declaration '%s'" $ show id

evalE (ExpFunDec (FunDecInstFun id _ _ [])) = do
  throwError $ printf "No definition given for instance function declaration '%s'" $ show id

evalE (ExpFunDec (FunDecFun id ty (funDef:_))) =
  case funDef of
    FunDefInstFun _ _ _ _ -> do
      throwError $ printf "Function '%s' is not an instance function" $ show id
    FunDefFun fid argPatExps bodyExps ->
      if id /= fid then
        do { throwError $ printf "Invalid definition for function '%s' in definition context for '%s'" (show fid) (show id) }
      else do
        cloEnv <- gets (\intEnv -> ClosureEnv { cloTypeEnv = typeEnv intEnv, cloVarEnv = varEnv intEnv })
        let paramIds = map patExpBindingId argPatExps
            clo = Closure fid cloEnv paramIds bodyExps
            vClo = ValueFun clo
        putVarBinding id vClo
        putModuleExport id vClo
        return ValueUnit

evalE (ExpFunDec (FunDecInstFun id instTy funTy funDefs)) =
  return ValueUnit

evalE (ExpAssign id e) = do
  v <- evalE e
  putVarBinding id v
  putModuleExport id v
  return ValueUnit

evalE (ExpRef rawId) = do
  v <- lookupVarId rawId
  return v


evalE (ExpApp e argEs) = do
  fv@(ValueFun (Closure fid fenv paramIds bodyEs)) <- evalE e
  argVs <- mapM evalE argEs

  preApplyInterpEnv <- get
  put (preApplyInterpEnv { typeEnv = cloTypeEnv fenv, varEnv = cloVarEnv fenv })

  putVarBinding fid fv
  let argVTbl = zip paramIds argVs
  mapM (\(paramId, paramV) -> putVarBinding paramId paramV) argVTbl
  retV <- evalEs bodyEs

  restoreEnv preApplyInterpEnv
  return retV

evalE (ExpMemberAccess e id) = do
  (ValueModule (Module _ exports)) <- evalE e
  lookup id $ exportVars exports

-- For now we allow 0 to evaluate
-- to 'False' in the test position of a
-- conditional, and any nonzero --> 'True'.
-- Ultimately this should not be the case
-- as we don't want to support implicit conversion
-- We throw away the updated environment
-- after each evaluation to avoid local binding
-- escape
evalE (ExpIfElse condE thenEs elseEs) = do
  curEnv <- get
  condV <- evalE condE
  restoreEnv curEnv
  let es = case condV of
            ValueBool True -> thenEs
            ValueInt 0 -> elseEs
            ValueInt _ -> thenEs
            _ -> elseEs
  v <- evalEs es
  restoreEnv curEnv
  return v

evalE e = throwError $ printf "I don't know how to evaluate '%s'" $ show e


evalEs :: [Exp UniqId] -> Eval Value
evalEs [] = return ValueUnit
evalEs (e:[]) = evalE e
evalEs es = do
  vs <- mapM evalE es
  return $ last vs


eval :: CompUnit UniqId -> Eval Value
eval (CompUnit es) = evalEs es


interp :: CompUnit RawId -> Either FailMessage Value
interp compUnit = do
  alphaConverted <- alphaConvert compUnit
  evalState (runExceptT $ eval alphaConverted) mtInterpEnv
