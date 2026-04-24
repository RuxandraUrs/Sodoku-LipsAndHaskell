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

-- Verbose version with a step limit
-- maxSteps = how many steps to display before going silent
solveVerboseLimited :: Int -> Board -> IO (Maybe Board)
solveVerboseLimited maxSteps board = do
  putStrLn $ "=== Showing the first " ++ show maxSteps ++ " steps ===\n"
  putStrLn "Initial board:"
  printBoard board
  putStrLn ""
  (result, stepsUsed) <- solveStep maxSteps 0 board
  case result of
    Just solution -> do
      putStrLn $ "\n=== Solved (displayed " ++ show (min stepsUsed maxSteps) ++ " steps) ==="
      putStrLn "Final solution:"
      printBoard solution
      return (Just solution)
    Nothing -> do
      putStrLn "\nNo solution exists."
      return Nothing

-- Returns (result, number of steps attempted)
solveStep :: Int -> Int -> Board -> IO (Maybe Board, Int)
solveStep maxSteps currentStep board =
  case findEmpty board of
    Nothing     -> return (Just board, currentStep)
    Just (r, c) -> tryValuesStep maxSteps currentStep board r c [1 .. boardSize board]

tryValuesStep :: Int -> Int -> Board -> Int -> Int -> [Int] -> IO (Maybe Board, Int)
tryValuesStep _ step _ _ _ [] = return (Nothing, step)
tryValuesStep maxSteps step board row col (v:vs)
  | valid board row col v = do
      let newBoard = setValue board row col v
          newStep  = step + 1
      -- Display only if we haven't exceeded the limit
      if newStep <= maxSteps
        then do
          putStrLn $ "Step " ++ show newStep ++ ": placing " ++ show v
                  ++ " at (" ++ show row ++ ", " ++ show col ++ ")"
          printBoard newBoard
          putStrLn ""
        else if newStep == maxSteps + 1
          then putStrLn "... (continuing silently) ...\n"
          else return ()
      (result, finalStep) <- solveStep maxSteps newStep newBoard
      case result of
        Just solution -> return (Just solution, finalStep)
        Nothing       -> tryValuesStep maxSteps finalStep board row col vs
  | otherwise = tryValuesStep maxSteps step board row col vs