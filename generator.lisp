(load "sudoku.lisp")
(setf *random-state* (make-random-state t))

(defun shuffle-list (lst)
  (let ((vec (coerce lst 'vector)))
    (loop for i from (1- (length vec)) downto 1
          for j = (random (1+ i))
          do (rotatef (aref vec i) (aref vec j)))
    (coerce vec 'list)))

(defun create-empty-board (size)
  (loop repeat size collect (loop repeat size collect 0)))

(defun fill-random (size)
  (let* ((empty-board (create-empty-board size))
         (values (loop for i from 1 to size collect i))
         (shuffled-values (shuffle-list values))
         (board-with-first-row
          (loop for row in empty-board
                for idx from 0
                collect (if (= idx 0)
                            shuffled-values
                            row))))
    (solve board-with-first-row)))

(defun generate-solution (size)
  (loop for sol = (fill-random size)
        when sol return sol))

(defun remove-cells (board positions)
  (reduce (lambda (b pos)
            (set-value b (car pos) (cdr pos) 0))
          positions
          :initial-value board))

(defun generate-puzzle (num-to-remove solution)
  (let* ((size (board-size solution))
         (all-positions (loop for r from 0 below size
                              append (loop for c from 0 below size
                                           collect (cons r c))))
         (shuffled-positions (shuffle-list all-positions))
         (to-remove (subseq shuffled-positions 0 num-to-remove)))
    (remove-cells solution to-remove)))

(defun generate-4x4 (num-empty)
  (let* ((solution (generate-solution 4))
         (puzzle (generate-puzzle num-empty solution)))
    (values puzzle solution))) 

(defun generate-9x9 (num-empty)
  (let* ((solution (generate-solution 9))
         (puzzle (generate-puzzle num-empty solution)))
    (values puzzle solution)))



(defun run-demo ()
  "Whole logic: generating puzzle, steps for solving through backtracking and printing results"

  ;; 4x4 demo
  (format t "~%=== Generating 4x4 puzzle (8 empty cells) ===")
  (multiple-value-bind (puzzle _) (generate-4x4 8)
    (declare (ignore _))
    (format t "~%Generated puzzle:")
    (print-sudoku puzzle)

    (let ((solution4x4 (solve puzzle t)))
      (format t "~%Complete solution:")
      (print-sudoku solution4x4)))

  ;; 9x9 demo
  (format t "~%=== Generating 9x9 puzzle ===")
  (multiple-value-bind (puzzle _) (generate-9x9 40)
    (declare (ignore _))
    (format t "~%Generated puzzle:")
    (print-sudoku puzzle)

    (let ((solution9x9 (solve puzzle t)))
      (format t "~%Complete solution:")
      (print-sudoku solution9x9))))
