{-# LANGUAGE OverloadedStrings #-}

import Database.MySQL.Simple
import Control.Monad
import Data.Text as Text
import Data.Typeable
--import Data.Text.Format
import qualified System.Process as SP
import Text.PrettyPrint.Tabulate (printTable)
import Text.Format (format)

--TODO: change before merge
clearScreen :: IO ()
clearScreen = do
  {-_ <- SP.system "reset"
  return ()-}
  putStr "\ESC[2J"

data User = User {login :: String, password :: String} deriving (Show)

separator :: IO ()
separator = putStrLn "********************************************************************************"

startProg :: Connection -> IO ()
startProg conn = do
  clearScreen
  separator
  putStrLn "\n\t\t\tSIGN IN\n"
  separator
  putStrLn "Login: "
  login' <- getLine
  putStrLn "Password: "
  password' <- getLine
  res <- query conn "SELECT * FROM Users where login=? and password=?" (login' :: String, password' :: String) 
  case res :: [(String, String)] of
    [] -> do
      putStrLn "ERROR: Please try again"
      --TODO: delete before merge
      menuView conn
    _ -> do
      putStrLn $ "Nice to meet you, " ++ login'
      menuView conn

menuView :: Connection -> IO ()
menuView conn = do
  clearScreen
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
    "4" -> putStrLn "doing"--statisticView conn
    _ -> putStrLn "Buy!"

softwareView conn = do
  clearScreen
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
    "4" -> softwareShow conn
    _ -> menuView conn

authorView conn = do
  clearScreen
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
    "4" -> authorShow conn
    _ -> menuView conn

usingView conn = do
  clearScreen
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
    "3" -> usingShow conn
    _ -> menuView conn

statisticView conn = do
  clearScreen
  separator
  putStrLn "Statistic Filter by Software"
  separator
  softId' <- getUniqSoft conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      res <- query conn "select count(*) from Using_info where software_id = ?" [id :: Int]
      case (unpackVal res) of
        Just 0 -> do
          putStrLn "Sorry, no any statistic"
        Just num -> do
          putStrLn $ format "It is used by {0} times" [(show num)]
  separator
  endTask conn


softwareShow conn = do
  clearScreen
  separator
  putStrLn "Look at Software + Term"
  separator
  res <- query_ conn "Select s.name, s.description, s.version, s.source, \
              \     IFNULL(t.info, 'NONE'),\
              \     DATE_FORMAT(IFNULL(t.start, NOW()), '%d %m %Y'), \
              \     IFNULL(t.end, 'infinity') \
              \from Software as s \
              \   left join Terms as t \
              \   on s.id = t.id"
  printTable (headers:(res :: [(String, String, String, String, String, String, String)]))
  separator
  endTask conn
  where
    headers = ("Name", "Description", "Version", "Source", "Info", "Start", "End")

authorShow conn = do
  clearScreen
  separator
  putStrLn "Look at Authors"
  separator
  res <- query_ conn "select a.name, group_concat(distinct s.name separator ', ')\
                      \from Author as a \
                      \   inner join Software_Author as sa on sa.author_id = a.id \
                      \   inner join Software as s on sa.software_id = s.id \
                      \group by a.name"
  printTable (headers:(res :: [(String, String)]))
  separator
  endTask conn
  where
    headers = ("Name", "Softs")

usingShow conn = do
  clearScreen
  separator
  putStrLn "Look at using"
  separator
  res <- query_ conn "select s.name, u.name, u.info \
                      \from Using_info as u \
                      \inner join Software as s on u.software_id = s.id"
  printTable (headers:(res :: [(String, String, String)]))
  separator
  endTask conn
  where
    headers = ("Software", "Name", "Info")


endTask :: Connection -> IO ()
endTask conn = do
  _ <- getLine
  menuView conn

getUniqAuth :: Connection -> IO (Maybe Int)
getUniqAuth conn = do
  putStrLn "Try to find Author. Enter name:" 
  name' <- getLine
  num <- query conn "select id from Author where name=?" [name' :: String]
  return $ unpackVal num

getUniqSoft :: Connection -> IO (Maybe Int)
getUniqSoft conn = do
  putStrLn "Try to find Software. Enter name:"
  name' <- getLine
  num <- query conn "select id from Software where name=?" [name' :: String]
  return $ unpackVal num

unpackVal :: [Only Int] -> Maybe Int
unpackVal onId = 
  case onId of
    [] -> Nothing
    [Only id] -> Just id

{-
tempee :: Connection -> IO (Maybe Int)
tempee conn = do
  name' <- getLine
  case name' of
    "" -> do
      return Nothing
    _-> do
      num <- query conn "select id from Software where name=?" ["windows" :: String]
      case num :: [Only Int] of
        [] -> do
          --putStrLn "Nonexistent"
          Nothing
        [Only id] -> do
          Just id
-}
  
main :: IO () 
main = do
  conn <- connect defaultConnectInfo
    { connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "haskell"
    }
  --startProg conn
  statisticView conn
  close conn