;(finish-output *stream*)\
#|
(defclass Symbol ()
    (
        (s :accessor s)
    )
)

(defclass Punctuation (Symbol)
    (
        (ps :accessor ps)
    )
)

(defclass Word ()
    (
        (ws :accessor ws)
    )
)

(defclass Sentence ()
    (
        (sw :accessor sw)
    )
)
|#

(defvar mychar nil)
(setf mychar (read-char))
(write mychar)


; (write sb-ext:*posix-argv*)
(write-line "Commet")

#|
(split-sequence:split-sequence-if
            (lambda (item)
              (position item " -+"))
            "aa bb  ccc  dddd--eee++++ffff"
            :remove-empty-subseqs t)
|#

(defvar text (make-array 0))
(defparameter storage (make-array 0))
(with-open-file (stream "lab_4/test.txt" :direction :input)
    (loop for symbol = (read-char stream nil)
        while symbol do
            (cond ()
            )
            (write-char symbol)
    )
)


(write (sort '(2 4 7 3 9 1 5 4 6 3 8) '<))