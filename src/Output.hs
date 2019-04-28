module Output where

import           Data.Aeson
import           Data.Registry hiding (Output)
import           Http
import           Protolude         hiding (concat, toList)
import           Streaming
import           Streaming.Prelude

newtype Output m = Output {
  saveOutputs :: forall a . (ToJSON a) => Stream (Of a) m () -> Stream (Of a) m ()
}

newHttpOutput :: (Monad m) => Http m -> Output m
newHttpOutput http = Output {
  saveOutputs = saveOutputs' http
}

newBatchedOutput :: (Monad m) => Tag "unbatched" (Output m) -> Output m
newBatchedOutput output = Output {
  saveOutputs = concat . saveOutputs (unTag output). batchesOf 500
}

saveOutputs' :: (Monad m, ToJSON a) => Http m ->  Stream (Of a) m () -> Stream (Of a) m ()
saveOutputs' http = chain (void . postHttp http . makeRequest . toJSON)

batchesOf :: (Monad m) => Int -> Stream (Of a) m r -> Stream (Of [a]) m r
batchesOf batchSize = mapsM toList . chunksOf batchSize
