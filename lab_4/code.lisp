
(defun print-list (list)
    "Print each element one by one."
    (loop for item in list do
        (write item)))

(defclass _Symbol ()
    ((s
        :type :character
        :accessor s
        :initarg :s)
    )
)
(defmethod print-object ((obj _Symbol) out)
    (write-char (s obj)))

(defclass _Delimiter (_Symbol)
    ()
)
(defclass _Punctuation (_Symbol)
    ()
)
(defclass _PunctuationEnd (_Symbol)
    ()
)
(defclass _Word ()
    ((wsl
        :initform '()
        :type :list
        :initarg :wsl
        :accessor wsl)
    )
)
(defmethod print-object ((obj _Word) out)
    (print-list(wsl obj)))

(defclass _Sentence ()
    ((swl 
        :initform '()
        :type :list
        :initarg :swl
        :accessor swl)
    )
)

(defmethod print-object ((obj _Sentence) out)
    (format out "~C~CSentence~C" #\newline #\tab #\newline)
    (print-list(swl obj)))

(defmethod get-words ((obj _Sentence))
    (remove-if-not (lambda (sw) (eq (type-of sw) '_Word)) (swl obj)))

(defclass _Text ()
    ((tsl
        :initform '()
        :type :list
        :initarg :tsl
        :accessor tsl)
    )
)

(defmethod print-object ((obj _Text) out)
    (format out "~C~CTEXT" #\tab #\tab)
    (print-list(tsl obj))
    (format out "~C~CTHE END" #\tab #\tab))

(defmethod get-words ((obj _Text))
    (delete nil
        (concatenate  
            (map 'list
                (remove-if-not (lambda (_s) (eq (type-of _s) '_Sentence)) (_s obj))  
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
        ((is-letter sym)
            (make-instance '_Symbol :s sym))
        (t 
            (make-instance '_Delimiter :s sym))
    )
)

(defun parse-storage (storage)
    (setf storage (append storage (list (make-instance '_PunctuationEnd :s #\newline) (make-instance '_Symbol :s #\.))))
    (let ((prev (type-of (car storage)))
            (tbuf '())
            (sbuf '())
            (buf '()))
        (loop for item in storage do    
            (if (eq prev (type-of item))
                (setf buf (append buf (list item)))
                (progn
                    (case prev        
                        ('_Symbol
                            (setf sbuf (append sbuf (list (make-instance '_Word :wsl buf)))))
                        ('_PunctuationEnd
                            (setf tbuf (append tbuf (list (make-instance '_Sentence :swl (append sbuf buf)))))
                            (setf sbuf '())
                        )
                        ; Delimeter + Punctuation
                        (t 
                            (setf sbuf (append sbuf buf)))
                    )
                    (setf buf (list item))
                )
            )
            (setf prev (type-of item))
        )
        (return-from parse-storage (make-instance '_Text :tsl tbuf))
    )
)

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
                    (setf storage (append storage (list (convert-s symbol))))
            )
            ; TODO: parse storage
            (return-from parse-file storage)
        )
    )
)


(defun run-app()
    "Main function that started application"
    (let (;(mychar (read-character))
            (text (parse-storage (parse-file))))
        (print text)
        ;(format t "~CFILTER CHARACTER: ~C~C" #\newline mychar #\newline)
        ;(get-words text)
    )
)

; Entrance
(run-app)


; (read-character)

; (write (sort '(2 4 7 3 9 1 5 4 6 3 8) '<))