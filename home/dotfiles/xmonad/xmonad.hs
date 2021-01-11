import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

-- main = xmonad defaultConfig
--         { modMask = mod4Mask
--         , terminal = "alacritty"
--         }

-- Important nixos config paths
nixosConfigDir = "/etc/nixos/"
nixosDotsDir = nixosConfigDir ++ "home/dotfiles/"
nixosXMDir = nixosDotsDir ++ "xmonad/"

main = do
  -- Reified xmobar pipe
  xmproc <- spawnPipe $
    "xmobar" ++ " " ++ nixosXMDir ++ "xmobarrc"

  -- Start xmonad
  xmonad $ docks def
    -- IDK...
    { layoutHook = avoidStruts $ layoutHook def

    -- Send output to xmobar pipe with `hPutStrLn xmproc`
    , logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  -- First 50 characters of window name are xmobar title
                  }

    -- Other obvious config
    , modMask = mod4Mask
    , terminal = "alacritty"
    }
