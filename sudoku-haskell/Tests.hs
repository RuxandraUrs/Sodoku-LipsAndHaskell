module Main where

import Test.HUnit
import Test.QuickCheck
import Data.Maybe (isJust, isNothing, fromJust)

import Sudoku (Board, valid, findEmpty, setValue, boardSize)
import Solver (solve)

puzzle4x4 :: Board
puzzle4x4 =
  [ [1, 0, 0, 0]
  , [0, 0, 3, 0]
  , [0, 1, 0, 0]
  , [0, 0, 0, 2]
  ]

solution4x4 :: Board
solution4x4 =
  [ [1, 3, 2, 4]
  , [2, 4, 3, 1]
  , [4, 1, 1, 3]
  , [3, 2, 4, 2]
  ]

impossible4x4 :: Board
impossible4x4 =
  [ [1, 1, 0, 0]
  , [0, 0, 0, 0]
  , [0, 0, 0, 0]
  , [0, 0, 0, 0]
  ]

empty4x4 :: Board
empty4x4 = replicate 4 (replicate 4 0)

complete4x4 :: Board
complete4x4 =
  [ [1, 2, 3, 4]
  , [3, 4, 1, 2]
  , [2, 1, 4, 3]
  , [4, 3, 2, 1]
  ]

puzzle9x9 :: Board
puzzle9x9 =
  [ [5, 3, 0, 0, 7, 0, 0, 0, 0]
  , [6, 0, 0, 1, 9, 5, 0, 0, 0]
  , [0, 9, 8, 0, 0, 0, 0, 6, 0]
  , [8, 0, 0, 0, 6, 0, 0, 0, 3]
  , [4, 0, 0, 8, 0, 3, 0, 0, 1]
  , [7, 0, 0, 0, 2, 0, 0, 0, 6]
  , [0, 6, 0, 0, 0, 0, 2, 8, 0]
  , [0, 0, 0, 4, 1, 9, 0, 0, 5]
  , [0, 0, 0, 0, 8, 0, 0, 7, 9]
  ]

testValidRowOk :: Test
testValidRowOk = TestCase $ assertBool
  "valid: value not on row"
  (valid complete4x4 0 0 5)

testValidRowFail :: Test
testValidRowFail = TestCase $ assertBool
  "valid: duplicate value on row"
  (not $ valid complete4x4 0 0 1)

testValidColFail :: Test
testValidColFail = TestCase $ assertBool
  "valid: duplicate value on column"
  (not $ valid complete4x4 0 0 3)

testValidBoxFail :: Test
testValidBoxFail = TestCase $ assertBool
  "valid: duplicate value in sub-grid"
  (not $ valid complete4x4 0 0 2)


testFindEmptyExists :: Test
testFindEmptyExists = TestCase $ assertEqual
  "findEmpty: finds first empty cell"
  (Just (0, 1))
  (findEmpty puzzle4x4)

testFindEmptyNone :: Test
testFindEmptyNone = TestCase $ assertEqual
  "findEmpty: returns Nothing on complete board"
  Nothing
  (findEmpty complete4x4)

testFindEmptyFirst :: Test
testFindEmptyFirst = TestCase $ assertEqual
  "findEmpty: first empty cell on empty board is (0,0)"
  (Just (0, 0))
  (findEmpty empty4x4)


testSolveValid4x4 :: Test
testSolveValid4x4 = TestCase $ assertBool
  "solve: finds solution for valid 4x4 puzzle"
  (isJust $ solve puzzle4x4)

testSolveImpossible :: Test
testSolveImpossible = TestCase $ assertBool
  "solve: returns Nothing for impossible puzzle"
  (isNothing $ solve impossible4x4)

testSolveEmpty :: Test
testSolveEmpty = TestCase $ assertBool
  "solve: finds solution for empty 4x4 board"
  (isJust $ solve empty4x4)

testSolveComplete :: Test
testSolveComplete = TestCase $ assertEqual
  "solve: returns unchanged board if already complete"
  (Just complete4x4)
  (solve complete4x4)

testSolve9x9 :: Test
testSolve9x9 = TestCase $ assertBool
  "solve: finds solution for 9x9 puzzle"
  (isJust $ solve puzzle9x9)

testSolveNoEmpties :: Test
testSolveNoEmpties = TestCase $ assertBool
  "solve: solution contains no empty cells"
  (case solve puzzle4x4 of
    Nothing  -> False
    Just sol -> all (/= 0) (concat sol))

prop_solveNoZeros :: Bool
prop_solveNoZeros =
  case solve puzzle9x9 of
    Nothing  -> False
    Just sol -> all (/= 0) (concat sol)


prop_solveSameSize :: Bool
prop_solveSameSize =
  case solve puzzle4x4 of
    Nothing  -> True
    Just sol -> length sol == 4 && all (\r -> length r == 4) sol


testsValid :: Test
testsValid = TestList
  [ TestLabel "valid - row ok"         testValidRowOk
  , TestLabel "valid - row fail"       testValidRowFail
  , TestLabel "valid - column fail"    testValidColFail
  , TestLabel "valid - sub-grid fail"  testValidBoxFail
  ]

testsFindEmpty :: Test
testsFindEmpty = TestList
  [ TestLabel "findEmpty - empty exists"    testFindEmptyExists
  , TestLabel "findEmpty - full board"   testFindEmptyNone
  , TestLabel "findEmpty - empty board"   testFindEmptyFirst
  ]

testsSolve :: Test
testsSolve = TestList
  [ TestLabel "solve - 4x4 valid"       testSolveValid4x4
  , TestLabel "solve - impossible"       testSolveImpossible
  , TestLabel "solve - empty"           testSolveEmpty
  , TestLabel "solve - complete"        testSolveComplete
  , TestLabel "solve - 9x9"            testSolve9x9
  , TestLabel "solve - no zeros"    testSolveNoEmpties
  ]

allTests :: Test
allTests = TestList
  [ TestLabel "=== valid ==="      testsValid
  , TestLabel "=== findEmpty ===" testsFindEmpty
  , TestLabel "=== solve ==="     testsSolve
  ]


main = do
  putStrLn "\n=== HUnit Tests ===\n"
  _ <- runTestTT allTests
  putStrLn "\n=== QuickCheck Tests ===\n"
  quickCheck prop_solveNoZeros
  quickCheck prop_solveSameSize