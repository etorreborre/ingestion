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

registry =
     funTo @RIO (App @IO)
  +: funTo @RIO (newInput @IO @Record)
  +: funTo @RIO (newBatchedOutput @IO)
  +: funTo @RIO (newRedisStats @IO)
  +: funTo @RIO (newFtpFileProvider @IO)
  +: funTo @RIO (newDecryptedFileProvider @IO)
  +: funTo @RIO (newFtp @IO)
  +: funTo @RIO (newEncryption @IO)
  +: funTo @RIO (newHttp @IO)
  +: funTo @RIO (newRedis @IO)
  +: end
