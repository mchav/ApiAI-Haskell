import ApiAI

main :: IO ()
main = do
    myresponse <- withClient testClient myRequest
    print $ toCommand myresponse