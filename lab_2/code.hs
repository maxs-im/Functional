import System.Process         (callCommand)
import Control.Concurrent     (rtsSupportsBoundThreads)
import System.Environment     (getArgs)

{-|
  ...
  Some interesting lines connected to Haskell archiver
  ...
-} 

main :: IO ()
main = do  
  args <- getArgs
  callCommand $ "timecmd cheat " ++ (if args == [] then "1" else "0") ++ " " ++ (if rtsSupportsBoundThreads then "0" else "1")