import Distribution.Simple ( defaultMain )
import System.Process ( readProcessWithExitCode )
import System.Exit ( ExitCode(..), die )
import System.Directory ( doesDirectoryExist, doesFileExist )
import Control.Exception ( catch, SomeException )


main = do

  {- Note: a better question would be:  Are we in a pre-sdist situation? -}
  preSdist <- doesDirectoryExist ".git"
  if preSdist then earlyAutogen else pure ()

  defaultMain


{- Note: Having a separate directory to put these would be great.
Something like
`Distribution.Simple.BuildPaths.autogenPackageModulesDir`, which is
available to `UserHooks.buildHook` for *late* auto-generated code. -}

earlyGenFileName :: String
earlyGenFileName = "src/Generated/Early.hs"


{- This is auto generation required before `cabal sdist`. -}

earlyAutogen :: IO ()
earlyAutogen = do

  {- collect information from git -}
  gitHash <- git1 ["describe", "--always", "--dirty=+"]
  gitDate <- git1 ["show", "-s", "--format=%cd", "--date=format:%Y-%m-%d"]

  {- This is as ugly as Distribution.Simple.Build.PathsModule.Z -}
  writeFile earlyGenFileName $ unlines
    [ "module Generated.Early ( gitHash, gitDate ) where"
    , ""
    , "-- Note: This file is auto-generated before creating a source \
      \distribution."
    , ""
    , "import RIO"
    , ""
    , "gitHash :: Utf8Builder"
    , "gitHash = " ++ show gitHash
    , ""
    , "gitDate :: Utf8Builder"
    , "gitDate = " ++ show gitDate
    ]

  where
    git1 args = takeWhile (/= '\n') <$> run "git" args


{- Run command with arguments, die on failure -}

run :: String -> [String] -> IO String
run cmd args = do
  result <- readProcessWithExitCode cmd args "" `catch` cnf
  case result of
    (ExitSuccess, out, _) -> return out
    (_, _, err) -> die $ cmd ++ ": " ++ err

  where
    cnf :: SomeException -> IO a
    cnf _ = die $ "Command not found: " ++ cmd
