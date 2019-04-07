; package loader
(load "~/quicklisp/setup.lisp")
(ql:quickload "ltk")
(require "ltk")
; use gui library
(in-package #:ltk)

; load my theme classes
(load (concatenate 'string (directory-namestring *load-pathname*) "classes.lisp"))