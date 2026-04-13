module Sudoku where

import Data.List (transpose)
import Data.Maybe (listToMaybe)

type Board = [[Int]]
type BoxSize = Int

exampleBoard4x4 :: Board
exampleBoard4x4 =
  [ [1, 0, 3, 0]
  , [0, 2, 0, 4]
  , [0, 0, 2, 0]
  , [4, 0, 0, 3]
  ]

emptyBoard4x4 :: Board
emptyBoard4x4 = replicate 4 (replicate 4 0)

exampleBoard9x9 :: Board
exampleBoard9x9 =
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

boardSize :: Board -> Int
boardSize = length

getBoxSize :: Board -> BoxSize
getBoxSize board
  | boardSize board == 4 = 2
  | boardSize board == 9 = 3
  | otherwise            = floor . sqrt . fromIntegral . boardSize $ board

setValue :: Board -> Int -> Int -> Int -> Board
setValue board row col val =
  [ [ if r == row && c == col then val else board !! r !! c
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]
  where
    rows = boardSize board
    cols = boardSize board

validRow :: Board -> Int -> Int -> Bool
validRow board row val =
  val `notElem` filter (/= 0) (board !! row)

validCol :: Board -> Int -> Int -> Bool
validCol board col val =
  val `notElem` filter (/= 0) (map (!! col) board)

validBox :: Board -> Int -> Int -> Int -> Bool
validBox board row col val =
  val `notElem` filter (/= 0) boxValues
  where
    bSize     = getBoxSize board
    boxRow    = (row `div` bSize) * bSize
    boxCol    = (col `div` bSize) * bSize
    boxValues =
      [ board !! r !! c
      | r <- [boxRow .. boxRow + bSize - 1]
      , c <- [boxCol .. boxCol + bSize - 1]
      ]

valid :: Board -> Int -> Int -> Int -> Bool
valid board row col val =
  validRow board row val &&
  validCol board col val &&
  validBox board row col val

findEmpty :: Board -> Maybe (Int, Int)
findEmpty board =
  listToMaybe
    [ (r, c)
    | r <- [0 .. boardSize board - 1]
    , c <- [0 .. boardSize board - 1]
    , board !! r !! c == 0
    ]

printBoard :: Board -> IO ()
printBoard board = mapM_ printRow (zip [0..] board)
  where
    bSize     = getBoxSize board
    size      = boardSize board
    separator = concat
      [ replicate (bSize * 2 + 1) '-'
        ++ if i < (size `div` bSize) - 1 then "+" else ""
      | i <- [0 .. (size `div` bSize) - 1]
      ]

    printRow (r, row) = do
      if r > 0 && r `mod` bSize == 0
        then putStrLn separator
        else return ()
      putStrLn (formatRow row bSize)

    formatRow row bs =
      unwords
        [ (if c > 0 && c `mod` bs == 0 then "| " else "") ++
          (if row !! c == 0 then "." else show (row !! c))
        | c <- [0 .. length row - 1]
        ]

-- MANUAL TESTS 
-- findEmpty exampleBoard4x4      --> Just (0,1)
-- valid exampleBoard4x4 0 1 4    --> True
-- valid exampleBoard4x4 0 1 1    --> False  (1 already on row 0)
-- valid exampleBoard4x4 0 1 3    --> False  (3 already on row 0)
-- printBoard exampleBoard4x4