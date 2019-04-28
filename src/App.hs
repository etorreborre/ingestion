{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module App where

import           Data
import           Data.Registry hiding (Output)
import           FileProvider
import           Ftp
import           Http
import           Input
import           Output
import           Protolude
import           Redis
import           Stats

data App m = App {
  input  :: Input m Record
, output :: Output m
, stats  :: Stats m
}

testRegistry = funTo @RIO (newLocalFileProvider @IO) +: registry

mainTest :: IO ()
mainTest = withRegistry testRegistry $ \_ App {..} ->
  readInput input &
  saveOutputs output &
  saveStats stats ProcessedRecordStat


registry =
     funTo @RIO (App @IO)
  +: funTo @RIO (newCsvInput @IO @Record)
  +: funTo @RIO (newBatchedOutput @IO)
  +: funTo @RIO (tag @"unbatched" (newHttpOutput @IO))
  +: funTo @RIO (newRedisStats @IO)
  +: funTo @RIO (newDecryptedFileProvider @IO)
  +: funTo @RIO (tag @"clear" (newFtpFileProvider @IO))
  +: funTo @RIO (newFtp @IO)
  +: funTo @RIO (newEncryption @IO)
  +: funTo @RIO (newHttp @IO)
  +: funTo @RIO (newRedis @IO)
  +: valTo @RIO (FtpConfig "host" 8080)
  +: end

app :: RIO (App IO)
app = make @(RIO (App IO)) registry
