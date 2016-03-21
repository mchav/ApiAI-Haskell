{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE NamedFieldPuns #-}
module ApiAI.Response where

import Control.Monad
import Data.Aeson
import Data.Aeson.TH
import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import qualified Data.HashMap.Strict as HM
import Data.Scientific
import GHC.Generics

-- curl 'https://api.api.ai/api/query?v=20150910&query=where%20is&lang=en&sessionId=2f3b5c64-se64-42e0-b7ae-c022c5913915&timezone=2016-03-19T00:46:35-0400' -H 'Authorization:Bearer e8efb77e7f5445f5b50613657dd9fcd4' -H 'ocp-apim-subscription-key:ca48a61e-bb0b-4b72-b3e3-68b1969ff80c'


type ActionParameter = HM.HashMap String String

data AIResponse = AIResponse { responseId :: String
                         , timestamp :: String
                         , result :: AIResult
                         , status :: Status
                         } deriving (Generic, ToJSON, Show)

data AIResult = AIResult { source :: String
                     , resolvedQuery :: String
                     , score :: Maybe Scientific
                     , action :: String
                     , actionIncomplete :: Maybe Bool
                     , parameters :: ActionParameter
                     , contexts :: [Context]
                     , fulfillment :: Fulfillment
                     , metadata :: Metadata
                     } deriving (Generic, Show, ToJSON, FromJSON)

instance FromJSON AIResponse where
    parseJSON (Object o) = do
        responseId          <- o .:  "id"
        timestamp           <- o .:  "timestamp"
        result              <- o .:  "result"
        status              <- o .:  "status"
        return AIResponse {responseId, timestamp, result, status}

data Status = Status { code :: Int
                     , errorType :: String
                     , errorId :: Maybe String
                     , errorDetails :: Maybe String
                     } deriving (Generic, Show, ToJSON)

instance FromJSON Status where
    parseJSON = withObject "status" $ \o -> do
        code          <- o .:  "code"
        errorType     <- o .:  "errorType"
        errorId       <- o .:? "errorId"
        errorDetails  <- o .:? "errorDetails"
        return Status {code, errorType, errorId, errorDetails}

data Context = Context { name :: Maybe String
                       , contextParameter :: Maybe ActionParameter
                       , lifespan :: Maybe Scientific
                       } deriving (Generic, ToJSON, Show)

instance FromJSON Context where
    parseJSON (Object o) = do
        name                <- o .:  "name"
        contextParameter    <- o .:  "parameters"
        lifespan            <- o .:  "lifespan"
        return Context {name, contextParameter, lifespan}

data Fulfillment = Fulfillment { speech :: String
                               , src :: Maybe String
                               } deriving (Generic, Show, ToJSON)
instance FromJSON Fulfillment where
    parseJSON (Object o) = do
        speech          <- o .:   "speech"
        src             <- o .:?  "source"
        return Fulfillment {speech, src}


data Metadata = Metadata { intentId :: Maybe String
                         , intentName :: Maybe String
                         } deriving (Generic, Show, ToJSON, FromJSON)


main = do
    fileData <- B.readFile "SampleJSON.txt"
    let str = maybe (error "Failed to parse JSON") id ((decode fileData) :: Maybe AIResponse)
    print ((result str))
