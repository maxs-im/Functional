module Main where

  import Text.Printf
  import Control.Arrow
  import Data.Foldable (traverse_)
  import System.Random
  import Data.Bool
  import Data.List
  import Data.Ord
  import Data.Maybe (fromMaybe, isNothing, maybe)
  import Debug.Trace (traceShow)
  
  
  import Data.Typeable
  
  deskSize = 8
  
  valid :: Int -> Bool
  valid num = (0 <= num) && (num < deskSize)
  
  readStart :: IO (Int, Int)
  readStart = do
    putStrLn "Enter start point: "
    ints <- fmap (map read.words) getLine
    if length ints /= 2 || not (all valid (map (\x -> x-1) ints))
      then do
        putStrLn "Incorrect input -> will choose randomly"
        x <- randomRIO (1, deskSize :: Int)
        y <- randomRIO (1, deskSize :: Int)
        printf "Your point: %d %d" x y
        return (x-1, y-1)
    else return (ints!!0 - 1, ints!!1 - 1)
  
  moves :: [(Int, Int)]
  moves = [(1, 2), (-1, 2), (1, -2), (-1, -2)
          , (2, 1), (-2, 1), (2, -1), (-2, -1)]
  
  countStatus :: [(Int, Int)] -> [(Int, Int)]
  countStatus visited =
    let
      (x, y) = last visited
      ways = map (\(x0, y0) -> (x + x0, y + y0)) moves
      correctWays = filter (\(x, y) -> valid x && valid y) ways
      available = (correctWays \\ visited)
    in
      available
  
  go :: [(Int, Int)] -> Maybe [(Int, Int)]
  go saved =
    let
      choose = countStatus saved
      sortedC = sortOn (\x -> length $ countStatus (saved ++ [x])) choose
      square = deskSize*deskSize
      getGood :: Maybe [(Int, Int)] -> (Int, Int) -> Maybe [(Int, Int)]
      getGood = \acc point -> 
        let
          chain = go (saved ++ [point])
        in
          if (isNothing acc)
            then chain
          else acc
    in
      if length saved == square
        then Just saved
      else
        foldl getGood Nothing sortedC
  
  slice from to xs = take (to - from + 1) (drop from xs)
  
  cellToString :: Maybe Int -> String
  cellToString (Just x) = show x
  cellToString (Nothing) = "-"
  
  printDesk :: [(Int, Int)] -> String
  printDesk arr = output
    where
      numbered = [ elemIndex (i, j) arr | i <- [0..deskSize-1], j <- [0..deskSize-1]] :: [Maybe Int]
      slicedNumbers = [slice (i*deskSize) ((i+1)*deskSize-1) numbered | i <- [0..deskSize-1]] :: [[Maybe Int]]
      output = intercalate "\n" $ map (intercalate " " . map cellToString) slicedNumbers
  
  main :: IO ()
  main = do
    point <- readStart
    let a = go [point]

    print $ maybe "No soulution" printDesk a