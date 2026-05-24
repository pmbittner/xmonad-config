import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing ( spacingWithEdge )

-- for XMobar
import XMonad.Hooks.DynamicLog
    ( xmobarColor, PP(ppHiddenNoWindows, ppCurrent, ppHidden) )
import XMonad.Hooks.StatusBar
    ( defToggleStrutsKey, StatusBarConfig, statusBarProp, withEasySB )
import XMonad.Hooks.ManageDocks ( avoidStruts )

import qualified XMonad.StackSet as W

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.AfterDrag (afterDrag)

import Data.Map (Map, fromList)

myTerminal :: String
myTerminal   = "kitty"

myBrowser :: String
myBrowser    = "firefox"

myTextEditor :: String
myTextEditor = "emacsclient -c -a 'emacs'"

myWorkspaces :: [String]
myWorkspaces = ["1", "2"]

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
  [ -- XMonad and OS interaction
    ("M-S-r", spawn "xmonad --recompile" >> spawn "xmonad --restart")
  , ("M-<Return>", spawn "dmenu_run")
  , ("M-q", kill)
  , ("M-s" , withFocused $ windows . W.sink)

  -- programs
  , ("M-t", spawn myTerminal)
  , ("M-f", spawn myBrowser)
  , ("M-e", spawn myTextEditor)

  -- workspace navigation
  -- , ("M-h", (windows $ W.greedyView $ myWorkspaces !! 0))
  -- , ("M-l", (windows $ W.greedyView $ myWorkspaces !! 1))

  -- , ("M-h", (windows $ shiftTo Prev nonNSP >> moveTo Prev nonNSP))
  -- , ("M-l", (windows $ shiftTo Next nonNSP >> moveTo Next nonNSP))
  ]

myMouseBindings :: XConfig Layout -> Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig { modMask = modm } = fromList
  [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> afterDrag (windows $ W.sink w))
  ]


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
  , mouseBindings = myMouseBindings
  }
  `additionalKeysP` myKeys
