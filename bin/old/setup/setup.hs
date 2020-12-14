#!/usr/bin/env stack
{- stack script
 --optimize
 --resolver lts-14.2
 --package turtle
-}

{-# LANGUAGE OverloadedStrings #-}

import Turtle
import Prelude hiding (FilePath)

-- parser :: Parser (FilePath, FilePath)
-- parser = (,) <$> argPath "SOURCE_PATH" "Symlink is created to this file"
--              <*> argPath  "SYMLINK_PATH"  "Symlink is created at this path"

nixosConfigFolder = "/etc/nixos" :: FilePath
nixosHardwareConfig = nixosConfigFolder </> "hardware-configuration.nix"

safelink :: FilePath -> FilePath -> IO ExitCode
safelink linkTo linkFrom = do
  pathExists <- testpath linkTo
  isSymlink <-  isSymbolicLink linkTo

  -- Deal with already existent path
  if pathExists then
    -- Do not link and give warning if real file already exists
    if !isSymlink then do
      eprintf
        (fp%" already exists as a real file. Please remove it so that the "%fp%" -> "%fp%" symlink can take place.")
        linkTo linkFrom linkTo

      exit $ ExitFailure 1

    -- Focefully override old symlinks
    else do
      oldLinkFrom <- readlink linkTo
      printf
        ("WARNING: Overriding old symlink: from "%fp%" -> "%fp%" to "%fp" -> "%fp)
        oldLinkFrom linkTo linkFrom linkTo

  -- No path at `linkTo`, just create symlink
  else
  -- TODO: YOU WERE HERE CICCIOCACCA
  proc 

main = do
  wd <- pwd
  safelink (wd </> "hello") "hello-there"
