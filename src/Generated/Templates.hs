module Generated.Templates ( dateCompiled ) where

import RIO.Prelude
import Language.Haskell.TH ( Q, Exp, stringE, runIO )
import Data.Time ( getZonedTime, formatTime, defaultTimeLocale )


dateCompiled :: Q Exp
dateCompiled = runIO act >>= stringE
  where
    act = formatTime defaultTimeLocale fmt <$> getZonedTime
    fmt = "%Y-%m-%d %H:%M:%S %z (%Z)"
