
(defun print-list (list)
    "Print list of objects"
    (dolist (item list)
        (print-object item))
)

(defclass _Symbol ()
    ((s
        :type :character
        :initarg :s)
    )
)

#|
(defmethod print-object ((obj _Symbol) out)
    (write-char (s obj)))
|#
(defmethod print-object ((obj _Symbol) out)
    (format out "~C" (s obj)))

(defclass _Delimiter (_Symbol)
    ()
)
(defmethod print-object ((obj _Delimiter) out)
    (format out "~C" (s obj)))

(defclass _Punctuation (_Symbol)
    ()
)
(defmethod print-object ((obj _Punctuation) out)
    (format out "~C" (s obj)))

(defclass _PunctuationEnd (_Symbol)
    ()
)
(defmethod print-object ((obj _PunctuationEnd) out)
    (format out "~C" (s obj)))

(defclass _Word ()
    ((wsl 
        :initform '()
        :accessor wsl)
    )
)
(defmethod print-object ((obj _Word) out)
    (print-unreadable-object (obj out :type t)
        (print-list(wsl obj))))

(defclass _Sentence ()
    ((swl 
        :initform '()
        :type :list
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
        :type :list
        :initarg :tsl
        :accessor tsl)
    )
)
(defmethod print-object ((obj _Text) out)
    (format out "\t\tTEXT\n")
    (print-unreadable-object (obj out :type t)
        (print-list(tsl obj)))
    (format out "\t\tTHE END\n"))
(defmethod get-words ((obj _Text))
    (delete nil
        (concatenate  
            (map 'list
                (remove-if-not (lambda (_s) (eq (typeof _s) '_Sentence)) (_s obj))  
                (lambda (_s _Sentence) (get-words _s)))))    
)


(defun read-character()
    (write-line "Enter a character to sort: ")
    ; (terpri)
    (read-char)
)

(defun is-letter(sym)
    (or
        (and (char-not-greaterp sym #\z) (char-not-lessp sym #\a))
        (and (char-not-greaterp sym #\9) (char-not-lessp sym #\0)))
)

(defun convert-s(sym)
    (cond 
        ((find sym ",;-:")
            (make-instance '_Punctuation :s sym))
        ((find sym ".!?")
            (make-instance '_PunctuationEnd :s sym))
        ((is-letter(sym))
            (make-instance '_Symbol :s sym))
        (t 
            (make-instance '_Delimiter :s sym))
    )
)

(defun print-elements-of-list (list)
       "Print each element of LIST on a line of its own."
       (loop for item in list do
         (print item)))

(defun parse-file(&optional path)
    "Parsing file by its path character by character"
    ; default value for path
    (when (null path) (setf path "lab_4/test.txt"))
    ; (write sb-ext:*posix-argv*)

    ;(prog ((storage_sym (make-array 0)) (text_result (make-instance '_Text :tsl (make-instance '_Delimiter))))
    (with-open-file (stream path :direction :input)
        (let ((storage '()))
            (loop for symbol = (read-char stream nil)
                while symbol do 
                    (setq storage (append storage (list (convert-s symbol))))
            )
            (print-elements-of-list storage)  
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
(parse-file())



; (write (sort '(2 4 7 3 9 1 5 4 6 3 8) '<))