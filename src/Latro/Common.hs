{-# LANGUAGE FlexibleContexts #-}
module Latro.Common where

import Control.Monad.Except
import Debug.Trace (trace)
import Latro.Errors
import Latro.Semant (SourcePos(..))


type FailMessage = String

errWithSourcePos :: Err -> String -> SourcePos -> Err
errWithSourcePos err@(ErrAtPos _ _ _) _ _ = err
errWithSourcePos err moduleName srcPos = ErrAtPos srcPos moduleName err

-- This annotation is correct but not allowed without FlexibleContexts
-- reportPosOnFail :: MonadError Err m => m a -> SourcePos -> m a
reportPosOnFail a moduleName p = do
  a `catchError` (\err -> throwError $ errWithSourcePos err moduleName p)

withFailPos p moduleName a = reportPosOnFail a moduleName p


traceStrict :: String -> a -> a
traceStrict msg x = seq x $ trace msg x


class Show a => PrettyShow a where
  showShort :: a -> String
  showLong :: a -> String
  showLong x = show x


mapInd :: (Int -> a -> b) -> Int -> [a] -> [b]
mapInd _ _ [] = []
mapInd f i (x:xs) =
  (f i x):(mapInd f (i + 1) xs)

mapi :: (Int -> a -> b) -> [a] -> [b]
mapi f xs = mapInd f 0 xs


mapIndM :: Monad m => (Int -> a -> m b) -> Int -> [a] -> m [b]
mapIndM _ _ [] = return []
mapIndM f i (x:xs) = do
  x' <- f i x
  xs' <- mapIndM f (i + 1) xs
  return (x':xs')

mapMi :: Monad m => (Int -> a -> m b) -> [a] -> m [b]
mapMi f xs = mapIndM f 0 xs


mapSnd :: (b -> c) -> [(a, b)] -> [(a, c)]
mapSnd f tups = zip as cs
  where (as, bs) = unzip tups
        cs = map f bs
