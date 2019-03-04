{-# LANGUAGE OverloadedStrings #-}

import Database.MySQL.Simple
import Control.Monad
import Data.Text as Text
import Data.Typeable
--import Data.Text.Format
import qualified System.Process as SP
import Text.PrettyPrint.Tabulate (printTable)
import Text.Format (format)
import Control.Exception
import GHC.Int

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
    "4" -> statisticView conn
    _ -> putStrLn "Bye!"

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
    "1" -> addSoftware conn
    "2" -> deleteSoftware conn
    "3" -> editSoftware conn
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
    "1" -> editAuthView conn
    "2" -> deleteAuthor conn
    "3" -> addAuthor conn
    "4" -> authorShow conn
    _ -> menuView conn

usingView conn = do
  clearScreen
  putStrLn "\tUsing:\n\
            \\t\t1. Delete\n\
            \\t\t2. Add\n\
            \\t\t3. Show\n\
            \\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> deleteUse conn
    "2" -> addUse conn
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

editAuthView conn = do
  clearScreen
  separator
  putStrLn "\t\tChoose union operation:\
            \\t\t\t1. Add\n\
            \\t\t\t2. Delete\n\
            \\t\t\t_. RETURN"
  choose <- getLine
  clearScreen
  case choose of
    "1" -> deleteUnion conn
    "2" -> addUnion conn
    _ -> authorView conn

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

deleteSoftware conn = do
  clearScreen
  separator
  putStrLn "Let's delete Software"
  softId' <- getUniqSoft conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      execute conn "delete from Software where id = ?" [id :: Int]
      putStrLn "Deleted"
  separator
  endTask conn

deleteAuthor conn = do
  clearScreen
  separator
  putStrLn "Let's delete Author"
  softId' <- getUniqAuth conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      execute conn "delete from Author where id = ?" [id :: Int]
      putStrLn "Deleted"
  separator
  endTask conn

addSoftware conn = do
  clearScreen
  separator
  putStrLn "Add new Software"
  separator
  dataS <- collectSoft
  resultS <- try (execute conn "insert into Software (name, description, version, source) \
                              \values (?, ?, ?, ?)" dataS) :: IO (Either SomeException Int64)
  case resultS of
    Left ex  -> putStrLn "Hey, duplicate! Try again!"
    Right val -> do
      dataT <- collectTerm
      resultT <- try (execute conn "insert into Terms (info, start, end) \
                    \values (?, STR_TO_DATE(?,'%d,%m,%Y'), STR_TO_DATE(?,'%d,%m,%Y'))" dataT) :: IO (Either SomeException Int64)
      case resultT of
        Left ex  -> putStrLn "Incorrect Time! Term set default!"
        Right val -> putStrLn "Done"

  separator
  endTask conn

editSoftware conn = do
  clearScreen
  separator
  putStrLn "What Software do you want to edit?"
  softId' <- getUniqSoft conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      [n, d, v, s] <- collectSoft
      resultS <- try(execute conn "update Software \
                    \set name=?, description=?, version=?, source=? \
                    \where id = ?" [n, d, v, s, (show id)]) :: IO (Either SomeException Int64)
      case resultS of
        Left ex  -> putStrLn "Hey, duplicate name! Try again!"
        Right val -> do
          putStrLn (show val)
          [i, ss, e] <- collectTerm
          resultT <- try (execute conn "update Terms \ 
                        \set info=?, \
                        \start = STR_TO_DATE(?,'%d,%m,%Y'), \
                        \end = STR_TO_DATE(?,'%d,%m,%Y') \
                      \where id=?" [i, ss, e, (show id)]) :: IO (Either SomeException Int64)
          case resultT of
            Left ex  -> putStrLn "Incorrect Time! Term left old!"
            Right val -> putStrLn "Done"
  separator
  endTask conn

addAuthor conn = do
  clearScreen
  separator
  putStrLn "Add new Author"
  separator
  dataA <- collectAuthor
  resultA <- try (execute conn "insert into Author (name) \
                              \values (?)" dataA) :: IO (Either SomeException Int64)
  case resultA of
    Left ex  -> putStrLn "Hey, duplicate! Try again!"
    Right val -> do
      putStrLn "Done"

  separator
  endTask conn

addUnion conn = do
  clearScreen
  separator
  putStrLn "Add new Author to Software rights"
  softId' <- getUniqAuth conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten Software"
    Just sid -> do
      authId' <- getUniqAuth conn
      case authId' of
        Nothing -> do
          putStrLn "Nonexisten Author"
        Just aid -> do
          resultSA <- try(execute conn "insert Software_Author (software_id, author_id) \
                    \values (?, ?)" [(show sid), (show aid)]) :: IO (Either SomeException Int64)
          case resultSA of
            Left ex  -> putStrLn "Hey, duplicate pair! Try again!"
            Right val -> putStrLn "Done"

  separator
  endTask conn

deleteUnion conn = do
  clearScreen
  separator
  putStrLn "Delete Author from Software rights"
  softId' <- getUniqAuth conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten Software"
    Just sid -> do
      authId' <- getUniqAuth conn
      case authId' of
        Nothing -> do
          putStrLn "Nonexisten Author"
        Just aid -> do
          resultSA <- try(execute conn "delete Software_Author \
                                        \where software_id=? and author_id=?" [(show sid), (show aid)]) :: IO (Either SomeException Int64)
          case resultSA of
            Left ex  -> putStrLn "Hey, nonexisten! Try again!"
            Right val -> putStrLn "Done"

addUse conn = do
  clearScreen
  separator
  putStrLn "Add new Usage"
  separator
  softId' <- getUniqSoft conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      [n, i] <- collectUse
      execute conn "insert into Using_info (name, info, software_id) \
                    \values (?, ?, ?)" [n, i, (show id)]
      putStrLn "Done"

  separator
  endTask conn

deleteUse conn = do
  clearScreen
  separator
  putStrLn "What Usage do you want to delete?"
  separator
  softId' <- getUniqSoft conn
  case softId' of
    Nothing -> do
      putStrLn "Nonexisten"
    Just id -> do
      [n, i] <- collectUse
      resultA <- try (execute conn "delete Using_info \
                                  \where name=? and info=? and software_id=?" [n, i, (show id)]) :: IO (Either SomeException Int64)
      case resultA of
        Left ex  -> putStrLn "Hey, nonexisten! Try again!"
        Right val -> do
          putStrLn "Done"

  separator
  endTask conn

collectUse = do
  putStrLn "Create Usage, Please"
  putStr "Name: "
  name' <- getLine
  putStr "Info: "
  info' <- getLine

  return [name', info']

collectAuthor = do
  putStrLn "Create Author, Please"
  putStr "Name: "
  name' <- getLine

  return [name']

collectSoft :: IO [String]
collectSoft = do
  putStrLn "Create Software, Please"
  putStr "Name:"
  name' <- getLine
  putStr "Description: "
  description' <- getLine
  putStr "Version: "
  version' <- getLine
  putStr "Source: "
  source' <- getLine
  
  return [name', description', version', source']

collectTerm :: IO [String]
collectTerm = do
  putStrLn "Create Term for Software, Please"
  putStr "Information:"
  info' <- getLine
  putStrLn "Write date in format '%d,%m,%Y'. It is important!"
  putStr "Start date: "
  start' <- getLine
  putStr "End date: "
  end' <- getLine
  putStr "Source: "

  return [info', start', end']

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
  
main :: IO () 
main = do
  conn <- connect defaultConnectInfo
    { connectUser = "root"
    , connectPassword = ""
    , connectDatabase = "haskell"
    }
  --startProg conn
  editSoftware conn
  close conn