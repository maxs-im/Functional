
(defun print-list (list)
    "Print list of objects"
    (dolist (item list)
        (print-object item))
)

(defclass _Symbol ()
    ((s
        :initarg :s)
    )
)

#|
(defmethod print-object ((obj _Symbol) out)
    (write-char (s obj)))
|#
(defmethod print-object ((obj _Symbol) out)
    (print-unreadable-object (obj out :type t)
        (format out "~C" (s obj))))

(defclass _Word ()
    ((wsl 
        :initform '()
        :accessor wsl)
    )
)
(defmethod print-object ((obj _Word) out)
    (print-unreadable-object (obj out :type t)
        (print-list(wsl obj))))

(defclass _Delimiter (_Word)
    ()
)

(defclass _Punctuation (_Word)
    ()
)

(defclass _Sentence ()
    ((swl 
        :initform '()
        :accessor swl)
    )
)
(defmethod print-object ((obj _Sentence) out)
    (print-unreadable-object (obj out :type t)
        (print-list(swl obj))))
(defmethod get-words ((obj _Sentence))
    (remove-if-not (lambda (sw) (eq (typeof sw) '_Word)) (swl obj)))

(defclass _Text ()
    ((tsl
        :initform '()
        :accessor tsl)
    )
)
(defmethod print-object ((obj _Text) out)
    (format out "\t\tTEXT\n")
    (print-unreadable-object (obj out :type t)
        (print-list(tsl obj)))
    (format out "\t\tTHE END\n"))
(defmethod get-words ((obj _Text))
    (merge 
        (map 
            (remove-if-not (lambda (_s) (eq (typeof _s) '_Sentence)) (_s obj))  
            (lambda (_s _Sentence) (get-words _s))))
)


(defun read-character()
    (write-line "Enter a character to sort: ")
    ; (terpri)
    (read-char)
)

(defun parse-file(&optional path)
    "Parsing file by its path character by character"
    ; default value for path
    (when (null path) (setf path "lab_4/test.txt"))
    ; (write sb-ext:*posix-argv*)

    ;(defvar text (make-array 0))
    ;(defparameter storage (make-array 0))

    (with-open-file (stream path :direction :input)
        (loop for symbol = (read-char stream nil)
            while symbol do
                (cond 
                    ((find symbol ",;-:")
                        (write-line "Punctuation"))
                    ((find symbol ".!?")
                        (write-line "New sentence"))
                    (t (write-line "New word"))
                )
        )
    )
)

#|
(defun run-app()
    "Main function that started application"
    (let ((mychar (read-character)))
        (parse-file())
        (write mychar)
    )
)

; Entrance
(run-app)
|#

; (read-character)
;(parse-file())



; (write (sort '(2 4 7 3 9 1 5 4 6 3 8) '<))