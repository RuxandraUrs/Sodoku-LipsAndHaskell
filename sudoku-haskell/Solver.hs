module Solver where 
import Sudoku (Board, valid, findEmpty, setValue, boardSize, printBoard,
               exampleBoard4x4, exampleBoard9x9)

tryValue :: Board -> Int -> Int -> Int -> Maybe Board
tryValue board row col val
  | valid board row col val = solve (setValue board row col val)
  | otherwise               = Nothing

tryValues :: Board -> Int -> Int -> [Int] -> Maybe Board
tryValues _     _   _   []     = Nothing
tryValues board row col (v:vs) =
  case tryValue board row col v of
    Just solution -> Just solution   
    Nothing       -> tryValues board row col vs 

solve :: Board -> Maybe Board
solve board =
  case findEmpty board of
    Nothing     -> Just board  
    Just (r, c) -> tryValues board r c [1 .. boardSize board]

solveAndPrint :: Board -> IO ()
solveAndPrint board = do
  putStrLn "Initial board:"
  printBoard board
  putStrLn ""
  case solve board of
    Nothing       -> putStrLn "No solution exists for this board."
    Just solution -> do
      putStrLn "Solution found:"
      printBoard solution