module Redis where

import           Data.Aeson
import           Protolude

newtype Redis m = Redis {
  saveToRedis  :: Key -> Value -> m ()
}

newtype Key = Key Text

newRedis :: (MonadIO m) => Redis m
newRedis = Redis {
  saveToRedis  = panic "todo - saveToRedis"
}
