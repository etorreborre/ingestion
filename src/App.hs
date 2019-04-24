module App where

import           Data
import           Input
import           Output
import           Stats
import           Protolude

newtype App m = App {
  ingest :: m ()
}

newApp :: (Monad m) => Input m Record -> Output m -> Stats m -> App m
newApp input output stats = App {
  ingest = ingest' input output stats
}

ingest' :: (Monad m) => Input m Record -> Output m -> Stats m -> m ()
ingest' input output stats =
  readInput input &
  saveOutputs output &
  saveStats stats (const ProcessedRecordStat)
