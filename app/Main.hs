{-# LANGUAGE RecordWildCards #-}

module Main where

import           App
import           Data
import           Data.Registry
import           Protolude

main :: IO ()
main = withRegistry registry $ \App {..} ->
  readInput input &
  saveOutputs output &
  saveStats stats (const ProcessedRecordStat)
