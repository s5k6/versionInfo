import Distribution.Simple ( defaultMain )
import System.Environment ( getArgs )
import System.Process ( readProcessWithExitCode )
import System.Exit ( ExitCode(..), die )
import System.Directory ( doesDirectoryExist, doesFileExist )
import Control.Exception ( catch, SomeException )

main = do
  doesDirectoryExist ".git" ?? updateGitinfo $ requireGitinfo
  defaultMain


updateGitinfo :: IO ()
updateGitinfo = do

  {- collect information from git -}
  gitHash <- git1 ["describe", "--always", "--dirty=+"]
  gitDate <- git1 ["show", "-s", "--format=%cd", "--date=format:%Y-%m-%d"]

  {- Note: The file written below must match the structure and
  types expected in Compiletime.Templates.gitinfo -}

  writeFile "gitinfo" $ show (gitHash, gitDate) ++ "\n"


requireGitinfo :: IO ()
requireGitinfo = do
  doesFileExist "gitinfo" ?? return () $ die "Missing file: gitinfo"


{- Run git, return first line with trailing newline stripped -}

git1 :: [String] -> IO String
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



{- monadic ternary conditional operator -}

infix 1 ??
(??) :: Monad m => m Bool -> m a -> m a -> m a
(??) c t f = do
  c' <- c
  if c' then t else f
