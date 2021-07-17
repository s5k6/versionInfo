{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fforce-recomp #-}

module Compiletime.Info ( dateCompiled, versionText, gitHash ) where

import RIO
import RIO.Text ( intercalate )
import Data.Version ( versionBranch )
import qualified Compiletime.Templates
import qualified Paths_versionInfo as P

dateCompiled :: Utf8Builder
dateCompiled = $(Compiletime.Templates.dateCompiled)

versionText :: Utf8Builder
versionText = display . intercalate "." . map tshow $ versionBranch P.version

gitHash :: Utf8Builder
gitHash = $(Compiletime.Templates.gitHash)
