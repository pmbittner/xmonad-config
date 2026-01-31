import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing

-- for XMobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDocks

myLayoutHook =
  avoidStruts $ -- leave space for status bar
  spacingWithEdge 3 $ -- 
  layoutHook def

myXmobarPP :: PP
myXmobarPP = def
  { ppCurrent = xmobarColor "#0db9d7" ""
  , ppHidden = xmobarColor "#a9b1d6" ""
  , ppHiddenNoWindows = xmobarColor "#444b6a" ""
  }

myStatusBar = statusBarProp "xmobar" (pure myXmobarPP)

myKeys =
  [ ("M-t", spawn "kitty")
  , ("M-f", spawn "firefox")
  , ("M-e", spawn "emacsclient -c -a 'emacs'")
  , ("M-<Return>", spawn "dmenu_run")
  , ("M-S-r", spawn "xmonad --recompile" >> spawn "xmonad --restart")
  , ("M-q", kill)
  ]

main :: IO ()
main = xmonad
  $ withEasySB myStatusBar defToggleStrutsKey
  $ def
  { modMask = mod4Mask -- use Super as mod Key
  , terminal = "kitty"
  , borderWidth = 2
  , normalBorderColor = "#444b6a"
  , focusedBorderColor = "#ad8ee6"
  , layoutHook = myLayoutHook
  }
  `additionalKeysP` myKeys
