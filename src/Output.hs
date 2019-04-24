module Output where

import           Data.Aeson
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

newBatchedOutput :: (Monad m) => Http m -> Output m
newBatchedOutput http = Output {
  saveOutputs = \stream -> concat $ saveOutputs' http (batchesOf 500 stream)
}

saveOutputs' :: (Monad m, ToJSON a) => Http m ->  Stream (Of a) m () -> Stream (Of a) m ()
saveOutputs' http = chain (void . postHttp http . makeRequest . toJSON)

batchesOf :: (Monad m) => Int -> Stream (Of a) m r -> Stream (Of [a]) m r
batchesOf batchSize stream = mapsM toList (chunksOf batchSize stream)
