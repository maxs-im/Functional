;(finish-output *stream*)\

(defclass _Symbol ()
    ((s :accessor s)
    )
)

(defclass _Punctuation (_Symbol)
    ((ps :accessor ps)
    )
)

(defclass _Word ()
    ((ws :accessor ws)
    )
)

(defclass _Sentence ()
    ((sw :accessor sw)
    )
)

(defclass _Text ()
    ((ts :accessor ts)
    )
)

(defun read-character()
    (write-line "Enter a character to sort: ")
    ; (terpri)
    (read-char)
)

#|
(split-sequence:split-sequence-if
            (lambda (item)
              (position item " -+"))
            "aa bb  ccc  dddd--eee++++ffff!"
            :remove-empty-subseqs t)
|#

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
    "Main function that starts application"
    (let ((mychar (read-character)))
        (parse-file())
        (write mychar)
    )
)

; Entrance
(run-app)
|#

;(parse-file())



; (write (sort '(2 4 7 3 9 1 5 4 6 3 8) '<))