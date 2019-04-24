module Http where

import           Protolude
import           Data.Aeson

data Http m = Http {
  getHttp  :: Request -> m Response
, postHttp :: Request -> m Response
}

data Request = Request
data Response = Response

newHttp :: (MonadIO m) => Http m
newHttp = Http {
  getHttp  = panic "todo - getHttp"
, postHttp = panic "todo - postHttp"
}

makeRequest :: (ToJSON a) => a -> Request
makeRequest _ = Request
