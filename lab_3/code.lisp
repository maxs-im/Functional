; package loader
(load "~/quicklisp/setup.lisp")
(ql:quickload "ltk")

(require "ltk")
; use gui library
(in-package #:ltk)

;(make-instance 'toplevel)
;(wm-title *tk* 'KEK)
;(on-close *tk* (lambda () (progn (format t "CLOSE") (destroy *tk*))))


(defun hello-2()
  (with-ltk ()
   (let* ((f (make-instance 'frame))
          (varl (list 1 2 3))
          (b1 (make-instance 'button
                             :master f
                             :text "Button 1"
                             :command (lambda () (format t "Button1~&"))))
          (b2 (make-instance 'button
                             :master f
                             :text "Button 2"
                             :command (lambda () (format t "Button2~&"))))
          (l1 (make-instance 'listbox
                            :master f
                            :listvariable '()
                            :command (lambda (x) (print x))
                           
                            ))                
          )
     (pack f)
     (pack b1 :side :left)
     (pack b2 :side :left)
     (pack l1 :side :left)
     ;(set l)('ant bee cicada')
     (configure f :borderwidth 3)
     (configure f :relief :sunken)
     )))
     
(hello-2)
