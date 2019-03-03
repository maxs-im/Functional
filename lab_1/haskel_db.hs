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

separator = "********************************************************************************"

startProg :: Connection -> IO ()
startProg conn = do
  putStrLn (separator ++ "\n\t\t\tSIGN IN\n" ++ separator  )
  putStrLn "Enter your login: "
  login' <- getLine
  putStrLn "Enter your password: "
  password' <- getLine
  putStrLn separator
  res <- query conn "select login from Users where login=? and password=?" ["heh", "1"]
  case res of
    [] -> do
      putStrLn "ERROR: Please try again"
      --start conn
    _ -> do
      putStrLn $ "ALERT: Hello " ++ login'

main :: IO () 
main = do
  conn <- connect defaultConnectInfo
    { connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "haskell"
    }
  startProg conn
  close conn