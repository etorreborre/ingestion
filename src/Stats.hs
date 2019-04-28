module Stats where

import           Data.Aeson
import           Protolude         hiding (map)
import           Redis
import           Streaming
import           Streaming.Prelude

newtype Stats m = Stats {
 saveStats :: forall a b . (ToJSON b) => (a -> b) -> Stream (Of a) m () -> m ()
}

newRedisStats :: (Monad m) => Redis m -> Stats m
newRedisStats redis = Stats {
 saveStats = \f -> effects .
   chain (\s -> saveToRedis redis (Key "aKey") (toJSON s)) . map f
}
