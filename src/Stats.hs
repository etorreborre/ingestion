module Stats where

import           Data
import           Data.Aeson
import           Protolude         hiding (map)
import           Redis
import           Streaming
import           Streaming.Prelude

newtype Stats m = Stats {
 saveStats :: Stream (Of ProcessedRecordStat) m () -> m ()
}

newRedisStats :: (Monad m) => Redis m -> Stats m
newRedisStats redis = Stats {
 saveStats = effects .
   chain (\s -> saveToRedis redis (Key "aKey") (toJSON s))
}
