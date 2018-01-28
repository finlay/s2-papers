{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import GHC.Generics
import Data.Either

import Data.Text (Text)
import Data.ByteString.Lazy.Char8 (ByteString)
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Aeson
import qualified Data.Csv as Csv



-- Take from the example on http://labs.semanticscholar.org/corpus/

data Author
  = Author
  { ids            :: [ Text ]
  , name           :: Text
  } deriving (Show, Eq, Generic)
instance FromJSON Author

data Paper
  = Paper
  { id             :: Text
  , title          :: Text
  , paperAbstract  :: Text
  , keyPhrases     :: [ Text ]
  , authors        :: [ Author ]
  , inCitations    :: [ Text ]
  , outCitations   :: [ Text ]
  , year           :: Maybe Int
  , s2Url          :: Text
  , venue          :: Text
  , journalVolume  :: Text
  , journalPages   :: Text
  }  deriving (Show, Eq, Generic)
instance FromJSON Paper

instance Csv.ToRecord Paper where
  toRecord person@Paper{..}
    = Csv.record 
    [ Csv.toField year
    , Csv.toField (first [ name a | a <- authors])
    , Csv.toField venue
    , Csv.toField title
    --, Csv.toField paperAbstract
    ]

first :: [ Text ] -> Text
first (a:as) = a
first [] = "" 


parse :: ByteString -> Either String Paper
parse = eitherDecode

process :: ByteString -> ByteString
process = Csv.encode . rights . map parse . B.lines

main :: IO ()
main = B.interact process
