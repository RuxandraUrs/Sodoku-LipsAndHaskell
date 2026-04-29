# Sodoku Solver
A solution implemented for Sudoku game using two functional languages: Lisp and Haskell.



---
Used versions: 
* Haskell: GHC - version 9.6.7


* Common Lisp: SBCL - version 2.6.3


---
## Problem and Solution
**Problem**: 

Sudoku is a logic-based puzzle where the objective is to fill a $4 \times 4$/ $9 \times 9$ grid with digits from 1 to 4/9. The rule is that each column, each row, and each of the $2 \times 2$/ $3 \times 3$ subgrids that compose the main grid must also contain all of the digits from 1 to 4/9.

**Key Challenges**:
* **Constraint Satisfaction**: every move must simultaneously satisfy row, column, and box constraints.
* **Backtracking**: the algorithm must  navigate a tree of possibilities in an efficient way, undoing choices that lead to a dead end.
* **State management**: maintaining an immutable or efficiently updated board state throughout the recursion.

----

**Solution**: 

The project implements a **recursive backtracking algorithm** in two different styles:

* Haskell implementation
   - **lazy evaluation**: utilizes Haskell's laziness to explore only the necessary branches of the search tree
  
    - **data structures**: boards are typically represented as flattened lists or Array types for constant-time lookups
  
    - **monadic approach**: often uses the Maybe monad to handle failed paths or the List monad to find all possible solutions

* Lisp implementation
    - **recursion**: extensive use of tail-recursive functions to iterate through empty cells
    
    - **higher-order functions**: employs mapcar, every and remove-if-not to validate constraints across the grid
    
    - **dynamic typing**: offers flexibility in representing the board as nested lists while maintaining high performance

## How does it work?
The solver uses a Backtracking algorithm combined with Constraint Propagation.
  * **Search**: the algorithm identifies the next empty cell (usually the one with the fewest possibilities to optimize the search)
  * **Validation**: for each digit, it checks if the placement is valid according to Sudoku rules (row, column and subgrid)
  * **Recursion**: if a valid number is found, it is placed on the board and the function calls itself for the next cell
  * **Backtrack**: if no number can be placed, the algorithm "backtracks" to the previous cell and tries the next possible candidate
    

## Running the solvers - user input
* **Haskell** solver displays a random generated board and solves it.
  - you should open the terminal in the project directory and start the interactive environment using:

        stack ghci

  - once in the `ghci>` prompt, you can run the solver. Display the initial board (4x4 puzzle):

        printBoard exampleBoard4x4

  - solve and display the solution (4x4):

        solveAndPrint exampleBoard4x4

  - solve and display the solution (9x9 - classic Sudoku puzzle):

        solveAndPrint exampleBoard9x9

  - show the BACKTRACKING steps (example for 4x4 board):

        solveVerboseLimited 10 exampleBoard4x4

* **Testing** the Haskell implementation:
  - inside the interactive environment, load the tests module and run it:

        :l Tests
        main

      
* **Lisp** solver that displays an random generated grid(both $9 \times 9$ and $4 \times 4$ grids) and solves it
   - you should open the terminal in the project directory
   - and run the solver
   
          sbcl --load main.lisp

   
## Example of system output(Lisp)
<img width="516" height="474" alt="image" src="https://github.com/user-attachments/assets/0ddb6380-012b-461c-8854-a7324856a19f" />
## Example of system output(Huskel)
<img width="383" height="325" alt="image" src="https://github.com/user-attachments/assets/7f1b5a66-d196-4d90-982a-1a41b22858e7" />


### Members:
* **Hurubă Adriana (10LF331)**
* **Urs Ruxandra-Mihaela (10LF333)**
* **Vaida Raluca Maria (10LF333)**
* **Vîlcu Andreea (10LF333)**
  
[Access Project Documentation](https://github.com/RuxandraUrs/Sodoku-LipsAndHaskell/blob/main/Sudoku.pdf)
