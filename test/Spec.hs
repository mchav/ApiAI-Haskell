import ApiAI

testClient = Client { accessToken = "f3cf88fc26b84c65a6cd4123148c6e94"
                    , subscriptionKey = "ca48a61e-bb0b-4b72-b3e3-68b1969ff80c"
                    }

myRequest :: TextRequest
myRequest = TextRequest { query = "5 + 12", 
                          v = "20150910", 
                          confidence = Nothing, 
                          sessionId = "1234567890", 
                          lang = "en", 
                          context = Nothing, 
                          resetContext = Nothing, 
                          entities = Nothing, 
                          timezone = Nothing
                        } 


main :: IO ()
main = do
    myresponse <- withClient testClient myRequest
    print $ toCommand myresponse