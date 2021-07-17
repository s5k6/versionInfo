
module Main ( main ) where

import RIO
import Compiletime.Info as CTI

main :: IO ()
main = runSimpleApp rioApp

rioApp :: RIO SimpleApp ()
rioApp = logInfo
  $
  "Version " <> CTI.versionText <> " " <> CTI.gitHash <> " " <>
  CTI.gitDate <> " compiled " <> CTI.dateCompiled
