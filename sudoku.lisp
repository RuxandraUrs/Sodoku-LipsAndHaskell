
(defparameter *example-board-4x4*
  '((1 0 3 0)
    (0 2 0 4)
    (0 0 2 0)
    (4 0 0 3))) ;; example of invalid table

(defparameter *empty-board-4x4*
  (loop repeat 4 collect (loop repeat 4 collect 0)))

(defparameter *example-board-9x9*
  '((5 3 0 0 7 0 0 0 0)
    (6 0 0 1 9 5 0 0 0)
    (0 9 8 0 0 0 0 6 0)
    (8 0 0 0 6 0 0 0 3)
    (4 0 0 8 0 3 0 0 1)
    (7 0 0 0 2 0 0 0 6)
    (0 6 0 0 0 0 2 8 0)
    (0 0 0 4 1 9 0 0 5)
    (0 0 0 0 8 0 0 7 9))) ;; example of valid table

(defun board-size (board)
  (length board))

(defun get-box-size (board)
  (isqrt (board-size board)))

(defun set-value (board row col val)
  (loop for r from 0 for row-list in board
        collect (if (= r row)
                    (loop for c from 0 for cell in row-list
                          collect (if (= c col) val cell))
                    row-list)))


(defun valid-row? (board row val)
  (not (member val (nth row board) :test #'=)))

(defun get-column (board col)
  (mapcar (lambda (row-list) (nth col row-list)) board))

(defun valid-col? (board col val)
  (not (member val (get-column board col) :test #'=)))

(defun get-box-values (board row col)
  (let* ((b-size (get-box-size board))
         (box-row (* (floor row b-size) b-size))
         (box-col (* (floor col b-size) b-size)))
    (loop for r from box-row below (+ box-row b-size)
          append (loop for c from box-col below (+ box-col b-size)
                       collect (nth c (nth r board))))))

(defun valid-box? (board row col val)
  (not (member val (get-box-values board row col) :test #'=)))

(defun valid? (board row col val)
  (and (valid-row? board row val)
       (valid-col? board col val)
       (valid-box? board row col val)))


(defun find-empty (board)
  (let ((size (board-size board)))
    (loop for r from 0 below size do
          (loop for c from 0 below size do
                (when (= 0 (nth c (nth r board)))
                  (return-from find-empty (cons r c))))) 
    nil))


(defun print-board (board)
  (dolist (row board)
    (format t "~A~%" row))
  (format t "~%"))


;; Tests- to do: put in a another file
;; 0.1
(format t "First empty cell: ~A~%" (find-empty *example-board-4x4*))

;; T
(format t "Is 4 valid at (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 4))

;; NIL
(format t "Is 1 valid at (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 1))

;; NIL
(format t "Is 3 valid at (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 3))


;; Solving logic using backtracking
(defun solve (board)
  (let ((empty-cell (find-empty board)))
    (if (not empty-cell)
        board ;; found a solution
        (let ((row (car empty-cell)) (col (cdr empty-cell)) (size (board-size board)))
          (loop for val from 1 to size
                do (when (valid? board row col val)
                     (let ((result (solve (set-value board row col val))))
                       (when result
                         (return-from solve result))))
                finally (return nil)))))) ;; no solution

;; Print board in a readable format
(defun print-sudoku (board)
  (let* ((size (length board))
         (box-size (isqrt size)))
    (terpri)
    (loop for row in board for r-idx from 1 do
      (loop for cell in row for c-idx from 1 do
        (format t "~A " (if (= cell 0) "." cell))
        (when (and (zerop (mod c-idx box-size)) (< c-idx size))
          (format t "| ")))
      (terpri)
      (when (and (zerop (mod r-idx box-size)) (< r-idx size))
        (loop repeat (+ (* 2 size) (* 2 (1- box-size))) do (format t "-"))
        (terpri)))))

(format t "~%Initial board:")
(print-sudoku *example-board-9x9*)

;; Main execution
(format t "~%Solving sudoku...~%")
(let ((solutie (solve *example-board-9x9*)))
  (if (null solutie)
      (format t "Failure: incorrect initial board or sudoku has no solution!~%")
      (progn
        (format t "~%Solution:")
        (print-sudoku solutie))))