{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fforce-recomp #-}

module Compiletime.Info ( dateCompiled, versionText, gitHash, gitDate ) where

import RIO
import RIO.Text ( intercalate )
import Data.Version ( versionBranch )
import qualified Compiletime.Templates
import qualified Paths_versionInfo as P


dateCompiled :: Utf8Builder
dateCompiled = $(Compiletime.Templates.dateCompiled)


versionText :: Utf8Builder
versionText = display . intercalate "." . map tshow $ versionBranch P.version



{- Note: The following types and structure must be matched by the
expression created in Compiletime.Templates.gitinfo -}

gitHash :: Utf8Builder
gitDate :: Utf8Builder

(gitHash, gitDate) = $(Compiletime.Templates.gitinfo)
