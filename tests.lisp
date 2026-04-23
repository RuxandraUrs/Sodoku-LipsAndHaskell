(load "sudoku.lisp")
(load "generator.lisp")

(defparameter *empty-board-4x4*
  (loop repeat 4 collect (loop repeat 4 collect 0))) 

(defparameter *valid-board-4x4*
  '((1 0 0 0)
    (0 0 2 0)
    (0 3 0 0)
    (0 0 0 4))) ;; example of valid table

(defparameter *invalid-board-4x4*
  '((1 0 3 0)
    (0 2 0 4)
    (0 0 2 0)
    (4 0 0 3))) ;; example of invalid table

(defparameter *valid-board-9x9*
  '((5 3 0 0 7 0 0 0 0) 
    (6 0 0 1 9 5 0 0 0)
    (0 9 8 0 0 0 0 6 0)
    (8 0 0 0 6 0 0 0 3)
    (4 0 0 8 0 3 0 0 1)
    (7 0 0 0 2 0 0 0 6)
    (0 6 0 0 0 0 2 8 0) 
    (0 0 0 4 1 9 0 0 5) 
    (0 0 0 0 8 0 0 7 9))) ;; example of valid table

(defparameter *invalid-board-9x9*
  '((5 5 0 0 7 0 0 0 0)
    (6 0 0 1 9 5 0 0 0)
    (0 9 8 0 0 0 0 6 0)
    (8 0 0 0 6 0 0 0 3)
    (4 0 0 8 0 3 0 0 1)
    (7 0 0 0 2 0 0 0 6)
    (0 6 0 0 0 0 2 8 0)
    (0 0 0 4 1 9 0 0 5)
    (0 0 0 0 8 0 0 7 9))) ;; example of invalid table


(defun run-all-tests ()
    (format t "~% --- UNIT TESTS ---~%")
  
    ;;Test 1: Full table - should return the same table as solution
    (let* ((full '((1 2 3 4) (3 4 1 2) (2 1 4 3) (4 3 2 1)))
        (res (solve full)))
        (format t "Test 1- Full table: ~A~%" 
        (if (equal res full) "PASSED" "FAILED")))

    ;;Test 2: Empty table - should return a solution, not nil
    (let ((res (solve *empty-board-4x4*)))
        (format t "Test 2 - Empty table for 4x4: ~A~%" (if res "PASSED" "FAILED")))

    ;;Test 3: Valid table - should return a solution, not nil
    (let ((res(solve *valid-board-4x4*)))
        (format t "Test 3 - Valid board for 4x4: ~A~%" (if res "PASSED" "FAILED")))

    ;;Test 4: Invalid table - should return nil
    (let ((res(solve *invalid-board-4x4*)))
        (format t "Test 4 - Invalid board for 4x4: ~A~%" (if (null res) "PASSED" "FAILED")))  
    
    ;;Test 5: Valid table - should return a solution, not nil
    (let ((res(solve *valid-board-9x9*)))
        (format t "Test 5 - Valid board for 9x9: ~A~%" (if res "PASSED" "FAILED")))
    
    ;;Test 6: Invalid table - should return nil
    (let ((res(solve *invalid-board-9x9*)))
        (format t "Test 6 - Invalid board for 9x9: ~A~%" (if (null res) "PASSED" "FAILED")))
    
    ;;Tests for validating values for a specific cell
    (let ((board '((1 2 3 4) (3 4 1 2) (2 1 4 3) (4 3 0 0))))
        (format t "Test 7 - Valid value on row? ~A~%" (if (valid? board 3 2 2) "PASSED" "FAILED"))
        (format t "Test 8 - Duplicate on row? ~A~%" (if (not (valid? board 0 1 2)) "PASSED" "FAILED"))
        (format t "Test 9 - Duplicate on column? ~A~%" (if (not (valid? board 0 2 1)) "PASSED" "FAILED"))
        (format t "Test 10 - Duplicate in box? ~A~%" (if (not (valid? board 0 0 4)) "PASSED" "FAILED")))
)

(defun run-generator-tests ()
  (format t "~% --- GENERATOR TESTS ---~%")
  
  (multiple-value-bind (puzzle solution) (generate-4x4 6)
    (let ((solved-puzzle (solve puzzle)))
      (format t "Test 1 - Generated 4x4 is solvable: ~A~%" 
              (if solved-puzzle "PASSED" "FAILED"))
      (format t "Test 2 - Solution matches original: ~A~%" 
              (if (equal solved-puzzle solution) "PASSED" "FAILED"))))

  (multiple-value-bind (puzzle _) (generate-4x4 8)
    (declare (ignore _))
    (let ((empty-count (loop for row in puzzle 
                             sum (count 0 row))))
      (format t "Test 3 - Correct number of empty cells (8): ~A~%" 
              (if (= empty-count 8) "PASSED" "FAILED")))))

(defun run-performance-tests ()
  (format t "~% --- PERFORMANCE TESTS - EXECUTION TIME ---~%")
  
  (format t "Performance for sudoku 4x4 (empty table):~%")
  (time (solve *empty-board-4x4*))
  
  (format t "~%Performance for sudoku 9x9 (standard table):~%")
  (time (solve *valid-board-9x9*)))

(run-all-tests)
(run-generator-tests)
(run-performance-tests)