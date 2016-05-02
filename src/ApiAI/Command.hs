module ApiAI.Command where

import ApiAI.TextRequest
import ApiAI.Response

data Command = Command String deriving (Show)

toCommand :: AIResponse -> Command
toCommand res = Command (action $ result res)
