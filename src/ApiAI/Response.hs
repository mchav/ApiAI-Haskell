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

--data 

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
                     , parameters :: Maybe Object
                     , contexts :: Maybe [Context]
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
