{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE NamedFieldPuns    #-}

module ApiAI.TextRequest where

import ApiAI.Response
import Data.Aeson
import Data.Scientific
import Network.Http.Client
import Network.HTTP.Headers

baseURL = "https://api.api.ai/v1/query?"

data Client = Client { accessToken :: String
                     , subscriptionKey :: String
                     } deriving (Show, Eq)


testClient = Client { accessToken = "f3cf88fc26b84c65a6cd4123148c6e94"
                    , subscriptionKey = "ca48a61e-bb0b-4b72-b3e3-68b1969ff80c"
                    }

data TextRequest = TextRequest { query :: String
                               , v :: String
                               , confidence :: Maybe Scientific
                               , sessionId :: String
                               , lang : String
                               , contexts :: Maybe [Context]
                               , resetContext :: Bool
                               , entities :: Maybe[String]
                               , timezone :: Maybe String
                               }

processTextRequest :: TextRequest -> String
processTextRequest textRequest = "query=" ++ (query textRequest) ++ "&"
                              ++ "v=" ++ (v textRequest) ++ "&"
                              ++ "sessionId=" ++ (v textRequest) ++ "&"
                              ++ "lang=en"


client token key = Client { accessToken = token
                          , subscriptionKey = key
                          }

withClient :: Client -> TextRequest -> IO AIResponse
withClient client textRequest = do
        
        withConnection (openConnection "api.api.ai" 80) $ (\c -> do
        let aiRequest = buildRequest1 (do
                          http GET (processTextRequest TextRequest)
                          setHeader "Authorization" ("Bearer " ++ (accessToken client))
                          setHeader "ocp-apim-subscription-key" (subscriptionKey client) )
        sendRequest c aiRequest emptyBody
        return "blah")


main = do
