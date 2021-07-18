module Generated.Templates ( dateCompiled, gitinfo ) where

import Prelude
import Language.Haskell.TH ( Q, Exp, tupE, stringL, stringE, litE, runIO )
import Data.Time ( getZonedTime, formatTime, defaultTimeLocale )


dateCompiled :: Q Exp
dateCompiled = runIO act >>= stringE
  where
    act = formatTime defaultTimeLocale fmt <$> getZonedTime
    fmt = "%Y-%m-%d %H:%M:%S %z (%Z)"


gitinfo :: Q Exp
gitinfo = do

  {- Note: The following types and structure must be matched by the file
  created in Setup.hs -}

  (gitHash :: String, gitDate :: String) <- read <$> runIO (readFile "gitinfo")

  {- Note: The expression created below must match the types and structure
  expected in Generated.Info -}

  tupE [ litE $ stringL gitHash
       , litE $ stringL gitDate
       ]
