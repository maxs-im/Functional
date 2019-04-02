; package loader
(load "~/quicklisp/setup.lisp")
(ql:quickload "ltk")
; use gui library
(in-package #:ltk)

; working test example
(defun hello-1()
  (with-ltk ()
   (let ((b (make-instance 'button 
                           :master nil
                           :text "Press Me"
                           :command (lambda ()
                                      (format t "Hello World!~&")))))
     (pack b))))

(hello-1)