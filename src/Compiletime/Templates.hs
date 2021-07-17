module Compiletime.Templates ( dateCompiled, gitHash ) where

import Prelude
import Language.Haskell.TH ( Q, Exp, stringE, runIO )
import Data.Time ( getZonedTime, formatTime, defaultTimeLocale )

dateCompiled :: Q Exp
dateCompiled = runIO act >>= stringE
  where
    act = formatTime defaultTimeLocale fmt <$> getZonedTime
    fmt = "%Y-%m-%d %H:%M:%S %z (%Z)"

gitHash :: Q Exp
gitHash = runIO (takeWhile (/= '\n') <$> readFile "githash") >>= stringE
