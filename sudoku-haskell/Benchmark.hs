module Benchmark where

import Sudoku
import Solver (solve)
import Generator (generate4x4, generate9x9)
import Data.Time.Clock (getCurrentTime, diffUTCTime)
import Control.Monad (replicateM)

measureTime :: IO a -> IO (a, Double)
measureTime action = do
  start  <- getCurrentTime
  result <- action
  end    <- getCurrentTime
  let duration = realToFrac (diffUTCTime end start) :: Double
  return (result, duration)

benchmarkSolver :: Board -> IO Double
benchmarkSolver puzzle = do
  (_, time) <- measureTime (return $! solve puzzle)
  return time

benchmarkAverage :: Board -> Int -> IO Double
benchmarkAverage puzzle n = do
  times <- replicateM n (benchmarkSolver puzzle)
  return (sum times / fromIntegral n)

runBenchmark :: IO ()
runBenchmark = do
  putStrLn "BENCHMARK: Haskell Sudoku Solver"

  putStrLn "--- 4x4 puzzle (10 empty cells, 5 runs) ---"
  (puzzle4, _) <- generate4x4 10
  putStrLn "Puzzle:"
  printBoard puzzle4
  time4 <- benchmarkAverage puzzle4 5
  putStrLn $ "Average solve time 4x4: " ++ show (time4 * 1000) ++ " ms\n"

  putStrLn "--- 9x9 puzzle (40 empty cells, 3 runs) ---"
  (puzzle9, _) <- generate9x9 40
  putStrLn "Puzzle:"
  printBoard puzzle9
  time9 <- benchmarkAverage puzzle9 3
  putStrLn $ "Average solve time 9x9: " ++ show (time9 * 1000) ++ " ms\n"

  putStrLn "--- 9x9 puzzle hard (55 empty cells, 3 runs) ---"
  (puzzle9hard, _) <- generate9x9 55
  printBoard puzzle9hard
  time9hard <- benchmarkAverage puzzle9hard 3
  putStrLn $ "Average solve time 9x9 hard: " ++ show (time9hard * 1000) ++ " ms\n"

  putStrLn "SUMMARY:"
  putStrLn $ "  4x4 (10 empty): " ++ show (time4 * 1000)     ++ " ms"
  putStrLn $ "  9x9 (40 empty): " ++ show (time9 * 1000)     ++ " ms"
  putStrLn $ "  9x9 (55 empty): " ++ show (time9hard * 1000) ++ " ms"

checkCorrectness :: IO ()
checkCorrectness = do
  putStrLn "=== Correctness check ==="

  let puzzle4 = exampleBoard4x4
  case solve puzzle4 of
    Just sol -> putStrLn "4x4: SOLVED" >> printBoard sol
    Nothing  -> putStrLn "4x4: ERROR - no solution found"

  let puzzle9 = exampleBoard9x9
  case solve puzzle9 of
    Just sol -> putStrLn "9x9: SOLVED" >> printBoard sol
    Nothing  -> putStrLn "9x9: ERROR - no solution found"

-- MANUAL TESTS 
-- ghci> Benchmark.checkCorrectness
-- ghci> Benchmark.runBenchmark