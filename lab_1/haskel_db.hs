{-# LANGUAGE OverloadedStrings #-}

import Database.MySQL.Simple
import Control.Monad
import Data.Text as Text
import Data.Typeable
--import Data.Text.Format
import qualified System.Process as SP

--TODO: change before merge
clearScreen :: IO ()
clearScreen = do
  {-_ <- SP.system "reset"
  return ()-}
  putStr "\ESC[2J"

data User = User {login :: String, password :: String} deriving (Show)

separator = "********************************************************************************"

startProg :: Connection -> IO ()
startProg conn = do
  putStrLn (separator ++ "\n\t\t\tSIGN IN\n" ++ separator)
  putStrLn "Login: "
  login' <- getLine
  putStrLn "Password: "
  password' <- getLine
  putStrLn separator
  res <- query conn "SELECT * FROM Users where login=? and password=?" (login' :: String, password' :: String) 
  case res :: [(String, String)] of
    [] -> do
      putStrLn "ERROR: Please try again"
      --TODO: delete before merge
      menuView conn
    _ -> do
      putStrLn $ "Nice to meet you, " ++ login'
      clearScreen
      menuView conn

menuView :: Connection -> IO ()
menuView conn = do
  putStrLn "What do you want to change?\n\
            \\t1. Softwares + its terms\n\
            \\t2. Authors\n\
            \\t3. Usage\n\
            \\t4. Statistic View\n\
            \_. EXIT"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> softwareView conn
    "2" -> authorView conn
    "3" -> usingView conn
    "4" -> statisticView conn
    _ -> putStrLn "Buy!"

softwareView conn = do
  putStrLn "\tSoftware + Terms:\n\
            \\t\t1. Edit\n\
            \\t\t2. Delete\n\
            \\t\t3. Add\n\
            \\t\t4. Show\n\
            \\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> putStrLn "S1!"
    "2" -> putStrLn "S2!"
    "3" -> putStrLn "S3!"
    "4" -> putStrLn "S4!"
    _ -> menuView conn

authorView conn = do
  putStrLn "\tAuthors:\n\
            \\t\t1. Edit\n\
            \\t\t2. Delete\n\
            \\t\t3. Add\n\
            \\t\t4. Show\n\
            \\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> putStrLn "A1!"
    "2" -> putStrLn "A2!"
    "3" -> putStrLn "A3!"
    "4" -> putStrLn "A4!"
    _ -> menuView conn

usingView conn = do
  putStrLn "\tUsing:\n\
            \\t\t1. Edit\n\
            \\t\t2. Add\n\
            \\t\t3. Show\n\
            \\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> putStrLn "U1!"
    "2" -> putStrLn "U2!"
    "3" -> putStrLn "U3!"
    _ -> menuView conn

statisticView conn = do
  putStrLn "\tStatistic:\n\
            \\tFilter by:\n\
            \\t\t1. Software\n\
            \\t\t2. Time\n\
            \\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> putStrLn "SF1!"
    "2" -> putStrLn "SF2!"
    _ -> menuView conn

main :: IO () 
main = do
  conn <- connect defaultConnectInfo
    { connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "haskell"
    }
  clearScreen
  startProg conn
  close conn