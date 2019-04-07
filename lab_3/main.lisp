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
            )
        (wm-title *tk* "Game room")

        (pack f)
        (configure f :borderwidth 3)
        (configure f :relief :sunken)
     
    )))

(gui)