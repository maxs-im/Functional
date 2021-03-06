
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
(defmethod count-c ((mychar character) (obj _Word))
    (count mychar (wsl obj) :test (lambda (c _s) (char-equal c (s _s)))))

(defclass _Sentence ()
    ((swl 
        :initform '()
        :type :list
        :initarg :swl
        :accessor swl)
    )
)

(defmethod print-object ((obj _Sentence) out)
    (format out "~&~CSentence~&" #\tab)
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
        (mapcan (lambda (_s) (get-words _s))
            (tsl obj)))    
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

(defun show-answer (words)
    (loop for i from 1 to (list-length words) do
        (format t "~D: ~a~&" i (nth (- i 1) words))))

(defun compare-symbolsl (l1 l2)
    (let ((ll1 (list-length l1))
            (ll2 (list-length l2)))
        (loop for i from 0 to (- (min ll1 ll2) 1) do
            (let ((s1 (s (nth i l1)))
                    (s2 (s (nth i l2))))
                (if (char-not-equal s1 s2)
                    (return-from compare-symbolsl (char-lessp s1 s2)))
            ))
        (return-from compare-symbolsl (<= ll1 ll2)))
)

(defun compare-words (w1 w2 mychar)
    (let ((w1c (count-c mychar w1))
        (w2c (count-c mychar w2)))
        (if (= w1c w2c)
            (compare-symbolsl (wsl w1) (wsl w2))
            (> w1c w2c)
        )
    )   
)

(defun run-app()
    "Main function that started application"
    (let ((mychar (read-character))
            (text (parse-storage (parse-file))))
        ; show parsed input
        (print text)
        ; show selected filter
        (format t "~&FILTER CHARACTER: ~C~&" mychar)
        (let* ((words (get-words text))
            (sortedwords (sort words (lambda (w1 w2) (compare-words w1 w2 mychar)))))
            ; show words in right order
            (show-answer 
                (remove-if-not (lambda (w) (/= (count-c mychar w) 0)) sortedwords))
        )
    )
)

; Entrance
(run-app)