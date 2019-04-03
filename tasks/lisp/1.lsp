(defvar *n*)
(defvar *m*)
(defvar *matrix*)

(defun read-numbers (&optional path)
    "Read Input"
    (when (null path) (setf path "tasks/lisp/1.txt"))
        (with-open-file (stream path :direction :input)
            (loop for n = (read stream nil nil)
                while (numberp n)
                    collect n)))

(defun set-variables (numbers)
    "Set variables from Input numbers"
    (if (< (list-length numbers) 2)
        (error "No n/m in input"))
    (multiple-value-setq (*n* *m*) (values (nth 0 numbers) (nth 1 numbers)))
    
    (if (/= (* *n* *m*) (- (list-length numbers) 2))
        (error "Incorrect matrix"))
    (setq *matrix* (cdr (cdr numbers))))

(defun get-cell (steps)
    (let ((x 0) (y 0))
        (dolist (s steps)
            (case s
                (1 (setf (values x y) (values (+ x 1) y)))
                (2 (setf (values x y) (values x (+ y 1))))
                (3 (setf (values x y) (values (+ x 1) (+ y 1))))
                (t (error "Incorrect step"))))
            (if (and (< x *n*) (< y *m*))
                (nth (+ (* *n* y) x) *matrix*)
                nil)))

; 1 -> right; 2 -> down; 3 -> right-down
(defun do-step (seq)
    (if (not seq)
        (return-from do-step nil))

    (let ((cell (get-cell (cdr seq))))
        ; Check if is valid value (in borders) (i.e. recursion exit)
        (if cell
            ; Replace score
            (setf (car seq) (+ cell (car seq)))
            (return-from do-step nil))
        
        (let ((d1 (do-step (append seq (list 1))))
            (d2 (do-step (append seq (list 2))))
            (d3 (do-step (append seq (list 3)))))
            (let ((win nil))
                (dolist (d (list d1 d2 d3))
                    (if d
                        (if win
                            (if (> (car d) (car win))
                                (setq win d))
                            (setq win d))))
                (if win
                    win
                    ; Finish
                    seq)))))

(defun print-step (arrow x y) 
    (format t "Step: (~D; ~D) ~A ~&" x y arrow))

(defun find-path ()
    (let ((seq (do-step (list 0)))
            (x 0) (y 0))
        (format t "Maximum score is ~D~&" (car seq))
        (dolist (s (cdr seq))
            (case s
                (1 (progn
                    (print-step "'right'" x y)
                    (setf (values x y) (values (+ x 1) y))))
                (2 (progn
                    (print-step "'down'" x y)
                    (setf (values x y) (values x (+ y 1)))))
                (3 (progn
                    (print-step "'right+down'" x y)
                    (setf (values x y) (values (+ x 1) (+ y 1)))))
            ))
        (print-step "" x y)))

(defun start ()
    (set-variables (read-numbers))
    (find-path))

; Entrance
(start)