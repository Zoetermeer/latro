module Latro.Compiler where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity
import Data.Map as Map
import Latro.Errors
import Latro.Semant

type GenericCompilerPassT e env m a = ExceptT e (StateT env m) a
type GenericCompilerPass e env a = GenericCompilerPassT e env Identity a
type CompilerPassT env m a = GenericCompilerPassT Err env m a
type CompilerPass env a = CompilerPassT env Identity a

class RunCompilerModule a where
  runModule :: a inp out -> inp -> CompilerEnv -> Either Err out

class Environment a where
  mt :: a


newtype CompilerModule inp out = CompilerModule { run :: inp -> CompilerEnv -> Either Err (out, CompilerEnv) }
type ModuleAlphaConvert   = CompilerModule (RawAst CompUnit) (UniqAst CompUnit)
type ModuleReorderInfixes = CompilerModule (UniqAst CompUnit) (UniqAst CompUnit)
type ModuleTypecheck      = CompilerModule (Untyped ILCompUnit) (Typed ILCompUnit)
type ModuleInterp         = CompilerModule (Typed ILCompUnit) (IO Value)


data TypeNamespace =
    TypeNsAdt UniqId (RawIdEnv UniqId)
  | TypeNsStruct UniqId (RawIdEnv UniqId)
  | TypeNsSimple UniqId
  deriving (Eq, Show)


typeId :: TypeNamespace -> UniqId
typeId (TypeNsAdt id _) = id
typeId (TypeNsStruct id _) = id
typeId (TypeNsSimple id) = id


data Namespace = Ns
  { name      :: UniqId
  , scope     :: LexicalScope
  , exports   :: LexicalScope
  }
  deriving (Eq, Show)


mkNs :: UniqId -> Int -> Namespace
mkNs nsId index = Ns { name = nsId, scope = mtLexicalScope index, exports = mtLexicalScope index }


-- |Alpha conversion environment
data LexicalScope = LexicalScope
  { index     :: Int
  , varIdEnv  :: RawIdEnv UniqId
  , typeIdEnv :: RawIdEnv UniqId
  , typeNsEnv :: UniqIdEnv TypeNamespace
  , ctorEnv   :: RawIdEnv UniqId
  }
  deriving (Eq, Show)


mtLexicalScope :: Int -> LexicalScope
mtLexicalScope ind =
  LexicalScope { index     = ind
               , varIdEnv  = mtRawIdEnv
               , typeIdEnv = mtRawIdEnv
               , typeNsEnv = mtUniqIdEnv
               , ctorEnv   = mtRawIdEnv
}


data AlphaEnv = AlphaEnv
  { counter :: Int
  , stack   :: [LexicalScope]
  , nsEnv   :: Map.Map (UniqAst QualifiedId) Namespace
  , curPath :: Maybe (UniqAst QualifiedId)
  , curNs   :: Maybe Namespace
  }
  deriving (Eq, Show)


instance Environment AlphaEnv where
  mt = AlphaEnv { counter = i
                , stack   = [mtLexicalScope i]
                , nsEnv = Map.empty
                , curPath = Nothing
                , curNs = Nothing
                }
    where i = 1


-- |Infix-application reordering environment
type PrecLevel = Int
type InfixReorderEnv = Env PrecLevel


-- |Type checking environment
type VarEnv = Map.Map UniqId Ty


data TCEnv = TCEnv
  { varEnv        :: VarEnv
  , typeEnv       :: Map.Map UniqId TyCon
  , tcAlphaEnv    :: AlphaEnv
  , patEnv        :: Map.Map UniqId Ty
  , fieldIndexEnv :: Map.Map UniqId Int
  , polyEnv       :: Map.Map UniqId Ty
  , metaEnv       :: Map.Map UniqId Ty
  , protoEnv      :: Map.Map UniqId Protocol
  -- protocolId --o--> (implementing tycon --o--> instance dictionary)
  , impEnv        :: Map.Map UniqId (Map.Map TyCon (ImpDict CheckedData))
  }
  deriving (Eq, Show)


instance Environment TCEnv where
  mt =
    TCEnv
      { varEnv        = Map.empty
      , typeEnv       = Map.empty
      , tcAlphaEnv    = mt
      , patEnv        = Map.empty
      , fieldIndexEnv = Map.empty
      , polyEnv       = Map.empty
      , metaEnv       = Map.empty
      , protoEnv      = Map.empty
      , impEnv        = Map.empty
      }


mtTCEnv :: AlphaEnv -> TCEnv
mtTCEnv aEnv = mt { tcAlphaEnv = aEnv }


-- |Interpreter environment
data InterpEnv = InterpEnv
  { valEnv         :: VEnv
  , curMod         :: Module
  , interpAlphaEnv :: AlphaEnv
  , entrypoint     :: Maybe (Typed IL)
  }
  deriving (Eq, Show)

mtExports :: Exports
mtExports = Exports { exportTypes = Map.empty
                    , exportVars =  Map.empty
                    }


instance Environment InterpEnv where
  mt =
    InterpEnv { valEnv          = Map.empty
              , curMod          = mod
              , interpAlphaEnv  = mt
              , entrypoint      = Nothing
              }
    where
      mod = Module mtEnv [] mtExports

mtInterpEnv :: AlphaEnv -> InterpEnv
mtInterpEnv aEnv = mt { interpAlphaEnv = aEnv } :: InterpEnv


data CompilerEnv =
  CompilerEnv { alphaEnv  :: AlphaEnv
              , opPrecEnv :: InfixReorderEnv
              , tcEnv     :: TCEnv
              , interpEnv :: InterpEnv
              }
  deriving (Eq, Show)

instance Environment CompilerEnv where
  mt =
    CompilerEnv { alphaEnv  = mt
                , opPrecEnv = Map.empty
                , tcEnv     = mt
                , interpEnv = mt
                }

