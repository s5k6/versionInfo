{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fforce-recomp #-}

module Generated.Late ( dateCompiled, versionText ) where

import RIO
import RIO.Text ( intercalate )
import Data.Version ( versionBranch )
import qualified Generated.Templates
import qualified Paths_versionInfo as P

dateCompiled :: Utf8Builder
dateCompiled = $(Generated.Templates.dateCompiled)

versionText :: Utf8Builder
versionText = display . intercalate "." . map tshow $ versionBranch P.version
