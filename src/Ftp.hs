module Ftp where

import Protolude hiding (get)

newtype Ftp m = Ftp {
  get :: Text -> m Text
}

data FtpConfig = FtpConfig {
  host :: Text
, port :: Int
}

newFtp :: FtpConfig -> Ftp m
newFtp _config = Ftp {
  get = panic "todo - FTP"
}
