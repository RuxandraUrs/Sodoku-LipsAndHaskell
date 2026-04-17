
(defparameter *example-board-4x4*
  '((1 0 3 0)
    (0 2 0 4)
    (0 0 2 0)
    (4 0 0 3)))

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
    (0 0 0 0 8 0 0 7 9)))

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


(defun gaseste-gol (board)
  (let ((size (board-size board)))
    (loop for r from 0 below size do
          (loop for c from 0 below size do
                (when (= 0 (nth c (nth r board)))
                  (return-from gaseste-gol (cons r c))))) 
    nil))


(defun print-board (board)
  (dolist (row board)
    (format t "~A~%" row))
  (format t "~%"))


;; 0.1
(format t "Prima celula goala: ~A~%" (gaseste-gol *example-board-4x4*))

;; T
(format t "Este valid 4 la (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 4))

;; NIL
(format t "Este valid 1 la (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 1))

;; NIL
(format t "Este valid 3 la (0,1)? ~A~%" (valid? *example-board-4x4* 0 1 3))