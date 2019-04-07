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
        (wm-title *tk* "Game room")
        ; exit key combination
        (bind *tk* "<Control-w>" (lambda (event)
                (declare (ignore event))
                (setf *exit-mainloop* t)))
        (let* ((f (make-instance 'frame))
            ; input
            (fparams (make-instance 'frame :master f))

            ; radio toy-type select
            (fradio (make-instance 'frame :master fparams))
            (ltoys (make-instance 'label
                        :master fradio
                        :text "Type: "))
            (r1 (make-instance 'radio-button
                        :master fradio
                        :text "Ball"
                        :value 'Ball :variable "toy"))
            (r2 (make-instance 'radio-button
                        :master fradio
                        :text "Machine"
                        :value 'Machine :variable "toy"))
            (r3 (make-instance 'radio-button
                        :master fradio 
                        :text "Constructor" 
                        :value 'Construct :variable "toy"))
            (r4 (make-instance 'radio-button 
                        :master fradio 
                        :text "Doll" 
                        :value 'Doll :variable "toy"))
        
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
            (mf-exit (make-menubutton mfile "Exit" (lambda () 
                                (setf *exit-mainloop* t))
                        :underline 1
                        :accelerator "Ctrl W"))
        
            ; Toy name
            (fname (make-instance 'frame :master fparams))
            (lname (make-instance 'label
                        :master fname
                        :text "Toy name: "))
            (i-n (make-instance 'entry 
                        :master fname
                        :text "name"))
            ; Toy price borders
            (fprice (make-instance 'frame :master fparams))
            (lprice (make-instance 'label
                        :master fprice
                        :text "For price (from -> to): "))
            (i-pf (make-instance 'entry 
                        :master fprice
                        :text 0
                        :validate :key))
            (i-pt (make-instance 'entry
                        :master fprice
	                    :text 0
	                    :validate :key))
            ; Toy age borders
            (fage (make-instance 'frame :master fparams))
            (lage (make-instance 'label
                        :master fage
                        :text "For age (from -> to):   "))
            (i-af (make-instance 'entry 
                        :master fage
                        :text 0
                        :validate :key))
            (i-at (make-instance 'entry
                        :master fage
	                    :text 0
	                    :validate :key))

            ; Budget
            (fbudget (make-instance 'frame :master fparams))
            (lbudget (make-instance 'label
                        :master fbudget
                        :text "Update budget: "))
            (i-b (make-instance 'entry 
                        :master fbudget
                        :text *budget*
                        :validate :key))
            (b-b (make-instance 'button
                        :master fbudget
                        :text "UPDATE"
                        :command (lambda () 
                            (format t "update budget~&"))))
            
        )
        (declare (ignore mf-exit mf-save mf-load sepm))
        
        (pack fparams :side :top :pady 10)
        (configure fparams :borderwidth 5)
        (configure fparams :relief :sunken)
        
            (pack fradio :side :top :fill :x)
            (pack (list ltoys r1 r2 r3 r4) :side :left)
            ; set deafult value for toy-type
            (setf (value r1) "ball")

           
            (pack fname :side :top :fill :x)
            (pack (list lname i-n) :side :left)
            (pack fprice :side :top :fill :x)
            (pack (list lprice i-pf i-pt) :side :left)
            (pack fage :side :top :fill :x)
            (pack (list lage i-af i-at) :side :left)

            (pack fbudget :side :top :fill :x)
            (configure fbudget :borderwidth 5)
            (configure fbudget :relief :sunken)
            (pack (list lbudget i-b b-b) :side :left)
        
            ; validate each integer input
            (format-wish "~A configure -validatecommand {string is int %P}"
                (widget-path i-pf))
            (format-wish "~A configure -validatecommand {string is int %P}"
                (widget-path i-pt))
            (format-wish "~A configure -validatecommand {string is int %P}"
                (widget-path i-af))
            (format-wish "~A configure -validatecommand {string is int %P}"
                (widget-path i-at))
            (format-wish "~A configure -validatecommand {string is int %P}"
                (widget-path i-b))
    
        
        
        
        (pack f)
        (configure f :borderwidth 3)
        (configure f :relief :sunken)     
    )))

(gui)