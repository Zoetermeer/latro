module Compiler where

import Control.Monad.Except
import Control.Monad.State
import Data.Functor.Identity
import Data.Map as Map
import Errors
import Semant

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
data Frame = Frame
  { index :: Int
  , varIdEnv  :: RawIdEnv AlphaEntry
  , typeIdEnv :: RawIdEnv AlphaEntry
  }
  deriving (Eq, Show)


mtFrame :: Int -> Frame
mtFrame ind = Frame { index = ind
                    , varIdEnv = mtRawIdEnv
                    , typeIdEnv = mtRawIdEnv
                    }


data AlphaEntry =
    UniqIdEntry UniqId
  | FrameEntry UniqId Frame
  | UnknownEntry UniqId
  deriving (Eq, Show)


data AlphaEnv = AlphaEnv
  { counter :: Int
  , stack   :: [Frame]
  , pass    :: Int
  }
  deriving (Eq, Show)


instance Environment AlphaEnv where
  mt = AlphaEnv { counter = i
                , stack   = [mtFrame i]
                , pass    = 0
                }
    where i = 1


-- |Infix-application reordering environment
type PrecLevel = Int
type InfixReorderEnv = Env PrecLevel


-- |Type checking environment
type VarEnv = Map.Map UniqId Ty


data TCEnv = TCEnv
  { curModule   :: TCModule
  , varEnv      :: VarEnv
  , tcAlphaEnv  :: AlphaEnv
  , polyEnv     :: Map.Map UniqId Ty
  , metaEnv     :: Map.Map UniqId Ty
  }
  deriving (Eq, Show)


instance Environment TCEnv where
  mt =
    TCEnv
      { curModule   = mtTCModule
      , varEnv      = Map.empty
      , tcAlphaEnv  = mt
      , polyEnv     = Map.empty
      , metaEnv     = Map.empty
      }


mtTCEnv :: AlphaEnv -> TCEnv
mtTCEnv aEnv = mt { tcAlphaEnv = aEnv }


-- |Interpreter environment
data InterpEnv = InterpEnv
  { valEnv         :: VEnv
  , curMod         :: Module
  , interpAlphaEnv :: AlphaEnv
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

