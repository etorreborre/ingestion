module Input where

import           Data
import           FileProvider
import           Protolude         hiding (toList)
import           Streaming         (Stream, effect, mapsM, chunksOf)
import           Streaming.Prelude

newtype Input m i = Input {
  readInput :: Stream (Of i) m ()
}

newInput :: (Monad m, FromCSVRow i) => FileProvider m -> Input m i
newInput fileProvider =
  Input {
    readInput = readInput' fileProvider
  }

readInput' :: (Monad m, FromCSVRow i) => FileProvider m -> Stream (Of i) m ()
readInput' fileProvider = effect $ do
  fileContent <- getFile fileProvider "input.txt"
  pure $ each (parseCsv fileContent)

parseCsv :: FromCSVRow i => Text -> [i]
parseCsv _fileContent = panic "todo - parse rows"

batchesOf :: Monad m => Int -> Stream (Of a) m r -> Stream (Of [a]) m r
batchesOf batchSize = mapsM toList . chunksOf batchSize
