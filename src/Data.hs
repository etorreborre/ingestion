{-# LANGUAGE DeriveAnyClass #-}

module Data where

import           Data.Aeson
import           Protolude

data Record = Record deriving (Generic, ToJSON)

instance FromCSVRow Record where
  fromRow = const Record

data ProcessedRecordStat = ProcessedRecordStat deriving (Generic, ToJSON)

class FromCSVRow i where
  fromRow :: Text -> i
