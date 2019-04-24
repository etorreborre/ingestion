module FileProvider where

import           Data.Registry
import           Ftp
import           Protolude hiding (get)

newtype FileProvider m = FileProvider {
  getFile :: Text -> m Text
}

newFtpFileProvider :: Ftp m -> FileProvider m
newFtpFileProvider ftp = FileProvider {
  getFile = get ftp
}

newLocalFileProvider :: FileProvider m
newLocalFileProvider = FileProvider {
  getFile = panic "todo - getFile locally"
}

newDecryptedFileProvider :: (Monad m)
  => Encryption m
  -> Tag "clear" (FileProvider m)
  -> FileProvider m
newDecryptedFileProvider encryption fileProvider = FileProvider {
  getFile = \t -> decrypt encryption =<< getFile (unTag fileProvider) t
}

data Encryption m = Encryption {
  decrypt :: Text -> m Text
, encrypt :: Text -> m Text
}

newEncryption :: Encryption m
newEncryption = Encryption {
  decrypt = panic "todo - decrypt"
, encrypt = panic "todo - encrypt"
}
