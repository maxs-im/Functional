; package loader
(load "~/quicklisp/setup.lisp")
(ql:quickload "ltk")
(require "ltk")
; use gui library
(in-package #:ltk)

; load my theme classes
(load (concatenate 'string (directory-namestring *load-pathname*) "classes.lisp"))

; init data
(read-data-from-file)

(defun gui ()
    (with-ltk ()
        (let* ((f (make-instance 'frame))
            ; radio select
            (fradio (make-instance 'frame :master f))
            (ltoys (make-instance 'label :master fradio :text "Toys: "))
            (r1 (make-instance 'radio-button :master fradio :text "Ball" :value 'Ball :variable "toy"))
            (r2 (make-instance 'radio-button :master fradio :text "Machine" :value 'Machine :variable "toy"))
            (r3 (make-instance 'radio-button :master fradio :text "Constructor" :value 'Construct :variable "toy"))
            (r4 (make-instance 'radio-button :master fradio :text "Doll" :value 'Doll :variable "toy"))
        
            ; menu for save  
            (mb (make-menubar))
            (mfile (make-menu mb "File" ))
            (mf-load (make-menubutton mfile "Load" (lambda ()
                                (read-data-from-file))
                        :underline 1))
            (mf-save (make-menubutton mfile "Save" (lambda ()
                                (save-data-to-file))
                        :underline 1))
            (sepm (add-separator mfile))   
            (mf-exit (make-menubutton mfile "Exit" (lambda () (setf *exit-mainloop* t))
                        :underline 1
                        :accelerator "Ctrl Q"))
        )
        (declare (ignore mf-exit mf-save mf-load sepm))
        ; exit key combination
        ; TODO: fix for Windows
        (bind *tk* "<Control-q>" (lambda (event) (declare (ignore event)) (setf *exit-mainloop* t)))
        (wm-title *tk* "Game room")

        (pack fradio :side :top :fill :x)
        (pack (list ltoys r1 r2 r3 r4) :side :left)
        ; set deafult value for toy-type
        (setf (value r1) "ball")

        (pack f)
        (configure f :borderwidth 3)
        (configure f :relief :sunken)
     
    )))

(gui)