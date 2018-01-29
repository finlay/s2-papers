{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import GHC.Generics
import Data.Either
import Data.Maybe
import Prelude hiding (id)

import Data.Text (Text)
import qualified Data.Text as T
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
  toRecord paper@Paper{..}
    = Csv.record 
    [ Csv.toField s2Url
    , Csv.toField year
    , Csv.toField (first [ name a | a <- authors])
    , Csv.toField venue
    , Csv.toField title
    , Csv.toField paperAbstract
    ]

first :: [ Text ] -> Text
first (a:as) = a
first [] = "" 

select :: Paper -> Paper -> Bool
select rob paper
  -- = any (T.isInfixOf "Elshire") (map name authors)
  =  any (id rob ==)   (outCitations paper)
  || any (id paper ==) (inCitations rob)


parse :: ByteString -> Either String Paper
parse = eitherDecode

process :: Paper -> ByteString -> ByteString
process rob = Csv.encode . filter (select rob) . rights . map parse . B.lines

main :: IO ()
main = do
  rob <- fromJust . decode <$> B.readFile "robs-paper.json"
  B.interact (process rob)



