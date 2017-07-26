{-# LANGUAGE BangPatterns, StrictData #-}
module Latro.Compiler where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity
import Data.Map as Map
import Latro.Ast
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


-- |Alpha conversion environment
-- Global scope --> Namespace scope --> Local scope

data TypeNamespace =
    TypeNsAdt UniqId (RawIdEnv UniqId)
  | TypeNsStruct UniqId (RawIdEnv UniqId)
  | TypeNsSimple UniqId
  deriving (Eq, Show)


typeId :: TypeNamespace -> UniqId
typeId (TypeNsAdt id _) = id
typeId (TypeNsStruct id _) = id
typeId (TypeNsSimple id) = id



data AlphaEnv = AlphaEnv
  { counter         :: Int
  -- Includes all defined namespaces, and imported aliased ones at the global (outermost) scope
  , globalNsEnv     :: QualIdEnv NamespaceScope
  , curNamespace    :: NamespaceScope
  }
  deriving (Eq, Show)

type GlobalScope = AlphaEnv


topLevelNs :: NamespaceScope
topLevelNs = mkNs $ Id mtSourcePos $ UserId "/"


instance Environment AlphaEnv where
  mt = AlphaEnv { counter       = i
                , globalNsEnv   = Map.empty
                , curNamespace  = topLevelNs
                }
    where i = 1

data NamespaceScope = Ns
  { path              :: UniqAst QualifiedId
  -- All defined and namespace-imported namespaces (superset of the global NS env)
  , nsEnv             :: QualIdEnv NamespaceScope
  -- All variables imported and bound at this scope
  , varIdEnv          :: RawIdEnv UniqId
  -- All types imported and bound at this scope
  , typeIdEnv         :: RawIdEnv UniqId
  -- All constructors imported and bound at this scope
  , ctorIdEnv         :: RawIdEnv UniqId
  -- All protocols imported and bound at this scope
  , protoIdEnv        :: RawIdEnv UniqId
  -- The stack of local scopes for the current context.
  -- The head is the innermost local scope.
  -- Local scopes only apply to the right-hand side of a variable binding occurrence,
  -- or a type binding occurrence.  A type environment is needed even for
  -- the variable case, because type variables can be introduced in a local scope.
  , localScopeStack   :: [LocalScope]
  -- Exported variables
  , exportVarIdEnv    :: RawIdEnv UniqId
  -- Exported types
  , exportTypeIdEnv   :: RawIdEnv UniqId
  -- Exported constructors
  , exportCtorIdEnv   :: RawIdEnv UniqId
  -- Exported protocols
  , exportProtoIdEnv  :: RawIdEnv UniqId
  }
  deriving (Eq, Show)


mkNs :: UniqAst QualifiedId -> NamespaceScope
mkNs path = Ns { path             = path
               , nsEnv            = Map.empty
               , varIdEnv         = Map.empty
               , typeIdEnv        = Map.empty
               , ctorIdEnv        = Map.empty
               , protoIdEnv       = Map.empty
               , localScopeStack  = []
               , exportVarIdEnv   = Map.empty
               , exportTypeIdEnv  = Map.empty
               , exportCtorIdEnv  = Map.empty
               , exportProtoIdEnv = Map.empty
               }


data LocalScope = LocalScope
  { localVarIdEnv  :: RawIdEnv UniqId
  , localTypeIdEnv :: RawIdEnv UniqId
  } deriving (Eq, Show)


mtScope :: LocalScope
mtScope = LocalScope { localVarIdEnv = mtRawIdEnv, localTypeIdEnv = mtRawIdEnv }


-- |Infix-application reordering environment
type PrecLevel = Int
type InfixReorderEnv = Env PrecLevel


-- |Type checking environment
type VarEnv = Map.Map UniqId Ty
type DictParamEnv = Map.Map (ProtocolId, Ty) UniqId


data TCEnv = TCEnv
  { varEnv         :: VarEnv
  , typeEnv        :: Map.Map UniqId TyCon
  , tcAlphaEnv     :: AlphaEnv
  , patEnv         :: Map.Map UniqId Ty
  , fieldIndexEnv  :: Map.Map UniqId Int
  , polyEnv        :: Map.Map UniqId Ty
  , metaEnv        :: Map.Map UniqId Ty
  , protoEnv       :: Map.Map UniqId [MethodId]
  -- protocolId --o--> (implementing tycon --o--> instance dictionary)
  -- The 'instance dictionary' will be an instance of the tuple/ADT type
  -- we declare to represent the dictionary itself
  , impEnv         :: Map.Map UniqId (Map.Map TyCon (Typed IL))
  , methodEnv      :: Map.Map MethodId ProtocolId
  , dictParamEnv   :: DictParamEnv
  }
  deriving (Eq, Show)


instance Environment TCEnv where
  mt =
    TCEnv
      { varEnv          = Map.empty
      , typeEnv         = Map.empty
      , tcAlphaEnv      = mt
      , patEnv          = Map.empty
      , fieldIndexEnv   = Map.empty
      , polyEnv         = Map.empty
      , metaEnv         = Map.empty
      , protoEnv        = Map.empty
      , impEnv          = Map.empty
      , methodEnv       = Map.empty
      , dictParamEnv    = Map.empty
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

