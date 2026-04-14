module Generator where

import Sudoku
import Solver (solve)
import Data.Maybe (fromJust, isJust)
import System.Random (randomRIO)

generateSolution :: Int -> IO Board
generateSolution size = do
  let empty = replicate size (replicate size 0)
  result <- fillRandom empty size
  case result of
    Just board -> return board
    Nothing    -> generateSolution size   

fillRandom :: Board -> Int -> IO (Maybe Board)
fillRandom board size = do
  values <- shuffle [1 .. size]
  let boardWithFirstRow = foldr
        (\(c, v) b -> setValue b 0 c v)
        board
        (zip [0..] values)
  return (solve boardWithFirstRow)

shuffle :: [a] -> IO [a]
shuffle []  = return []
shuffle lst = do
  idx <- randomRIO (0, length lst - 1)
  let (before, el : after) = splitAt idx lst
  rest <- shuffle (before ++ after)
  return (el : rest)

generatePuzzle :: Int -> Board -> IO Board
generatePuzzle numToRemove solution = do
  let size       = boardSize solution
      allPositions = [(r, c) | r <- [0..size-1], c <- [0..size-1]]
  shuffled <- shuffle allPositions
  let toRemove = take numToRemove shuffled
  return (removeCells solution toRemove)

removeCells :: Board -> [(Int, Int)] -> Board
removeCells = foldr (\(r, c) b -> setValue b r c 0)

generate4x4 :: Int -> IO (Board, Board)
generate4x4 numEmpty = do
  solution <- generateSolution 4
  puzzle   <- generatePuzzle numEmpty solution
  return (puzzle, solution)

generate9x9 :: Int -> IO (Board, Board)
generate9x9 numEmpty = do
  solution <- generateSolution 9
  puzzle   <- generatePuzzle numEmpty solution
  return (puzzle, solution)

runDemo :: IO ()
runDemo = do
  putStrLn "=== Generating 4x4 puzzle (8 empty cells) ==="
  (puzzle, solution) <- generate4x4 8
  putStrLn "\nGenerated puzzle:"
  printBoard puzzle
  putStrLn "\nComplete solution:"
  printBoard solution

-- TESTS 
-- Generator.runDemo