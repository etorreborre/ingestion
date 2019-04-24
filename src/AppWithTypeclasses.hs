{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module AppWithTypeclasses where

import           Data.Generics.Product.Typed
import           Data.Registry.TH
import           Protolude

newtype App m = App {
  ingest :: m ()
}

data Record
data ProcessedRecordStat = ProcessedRecordStat

newtype Input m = Input {
  _readInput :: m (Maybe Record)
}

makeTypeclass ''Input

newtype Output m = Output {
  _saveOutput :: forall a . a -> m ()
}

makeTypeclass ''Output

newApp :: (Monad m) => Input m -> Output m -> App m
newApp input output = App { ingest =
  flip runReaderT (input, output) $ ingest'
}

ingest' :: (Monad m, WithInput m, WithOutput m) => m ()
ingest' = readInput >>= \case
  Nothing     -> pure ()
  Just record -> do
    saveOutput record
    saveOutput ProcessedRecordStat
    ingest'
