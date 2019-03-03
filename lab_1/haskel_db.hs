{-|
sign in

  software (+term)
    add
    show
      edit
      delete
  
  author
    add
    show
      edit
      delete
    
  using
    add
    show
      edit
      delete
  
  show info by software   
-}  

{-# LANGUAGE OverloadedStrings #-}

import Database.MySQL.Simple
import Control.Monad
import Data.Text as Text
import Data.Typeable
--import Data.Text.Format

data User = User {login :: String, password :: String} deriving (Show)

separator = "********************************************************************************"

startProg :: Connection -> IO ()
startProg conn = do
  putStrLn (separator ++ "\n\t\t\tSIGN IN\n" ++ separator  )
  putStrLn "Enter your login: "
  login' <- getLine
  putStrLn "Enter your password: "
  password' <- getLine
  putStrLn separator
  res <- query conn "SELECT * FROM Users where login=? and password=?" (login' :: String, password' :: String)
  --forM_ res $ \num ->
    --putStrLn $ Text.unpack fname ++ " " ++ Text.unpack lname
  --print (res :: [(String, String)]) 
  case res :: [(String, String)] of
    [] -> do
      putStrLn "ERROR: Please try again"
      --start conn
    _ -> do
      putStrLn $ "ALERT: Hello " ++ login'

--process :: m => m ()
      
main :: IO () 
main = do
  conn <- connect defaultConnectInfo
    { connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "haskell"
    }
  startProg conn
  close conn