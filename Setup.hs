import Distribution.Simple ( defaultMain )
import System.Environment ( getArgs )
import System.Process ( readProcessWithExitCode )
import System.Exit ( ExitCode(..), die )
import System.Directory ( doesFileExist )
import Control.Exception ( catch, SomeException )

main = do
  writeGitHash
  defaultMain

writeGitHash :: IO ()
writeGitHash = do

  githash <- readProcess "git" ["describe", "--always", "--dirty=+"]
  case githash of
    (ExitSuccess, out, _) -> writeFile "githash" out
    (_, _, err) -> die $ "git: " ++ err


readProcess :: String -> [String] -> IO (ExitCode, String, String)
readProcess cmd args = readProcessWithExitCode cmd args "" `catch` cnf
  where
    cnf :: SomeException -> IO a
    cnf _ = die $ "Command not found: " ++ cmd
