module Stats where

import           Data.Aeson
import           Protolude hiding (map)
import           Streaming
import           Streaming.Prelude

newtype Stats m = Stats {
 saveStats :: forall a b . (ToJSON b) => (a -> b) -> Stream (Of a) m () -> m ()
}

newRedisStats :: (Monad m) => Redis m -> Stats m
newRedisStats redis = Stats {
 saveStats = \f stream -> effects $ chain (postRedis redis) (map f stream)
}

data Redis m = Redis {
  postRedis :: forall a . (ToJSON a) => a -> m ()
}
