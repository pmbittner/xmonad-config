import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing

-- for XMobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDocks

import qualified XMonad.StackSet as W

import XMonad.Util.SpawnOnce (spawnOnce)

-- import Data.Map (Map, fromList)

myTerminal   = "kitty"
myBrowser    = "firefox"
myTextEditor = "emacsclient -c -a 'emacs'"

myStartupHook :: X ()
myStartupHook = do
  spawn "nitrogen --restore &"

myLayoutHook =
  avoidStruts $ -- leave space for status bar
  spacingWithEdge 5 $ -- 
  layoutHook def

myXmobarPP :: PP
myXmobarPP = def
  { ppCurrent = xmobarColor "#0db9d7" ""
  , ppHidden = xmobarColor "#a9b1d6" ""
  , ppHiddenNoWindows = xmobarColor "#444b6a" ""
  }

myStatusBar :: StatusBarConfig
myStatusBar = statusBarProp "xmobar" (pure myXmobarPP)
-- M = Mod Key
-- S = Shift
myKeys :: [(String, X ())]
myKeys =
  [ ("M-S-r", spawn "xmonad --recompile" >> spawn "xmonad --restart")
  , ("M-<Return>", spawn "dmenu_run")
  , ("M-q", kill)
  , ("M-S-s" , withFocused $ windows . W.sink)

  -- programs
  , ("M-t", spawn myTerminal)
  , ("M-f", spawn myBrowser)
  , ("M-e", spawn myTextEditor)
  ]

-- myMouseBindings :: XConfig Layout -> Map (KeyMask, Button) (Window -> X ())
-- myMouseBindings XConfig { modMask = modm } = fromList
--   [ ((modm, button1), \w -> do
--         focus w
--         mouseMoveWindow w
--         windows W.sink
--     )
--   , ((modm, button3), \w -> do
--         focus w
--         mouseResizeWindow w
--         windows W.sink
--     )
--   ]

main :: IO ()
main = xmonad
  $ withEasySB myStatusBar defToggleStrutsKey
  $ def
  { modMask = mod4Mask -- use Super as mod Key
  , terminal = myTerminal
  , borderWidth = 1
  , normalBorderColor = "#444b6a"
  , focusedBorderColor = "#ad8ee6"
  , startupHook = myStartupHook
  , layoutHook = myLayoutHook
  -- , mouseBindings = myMouseBindings
  }
  `additionalKeysP` myKeys
