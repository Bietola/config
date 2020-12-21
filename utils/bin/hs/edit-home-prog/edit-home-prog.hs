#!/usr/bin/env stack
{- stack script
 --optimize
 --resolver lts-14.2
 --package turtle
-}

import Turtle

parseArgs :: Parser String
parseArgs = String <$> argPath argName "description"

main = do
   programName <- parseArgs
