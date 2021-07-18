
module Main ( main ) where

import RIO
import Generated.Early as GE
import Generated.Late as GL

main :: IO ()
main = runSimpleApp rioApp

rioApp :: RIO SimpleApp ()
rioApp = logInfo
  $
  "Version " <> GL.versionText <> " " <> GE.gitHash <> " " <>
  GE.gitDate <> " compiled " <> GL.dateCompiled
