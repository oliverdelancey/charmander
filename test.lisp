(load "~/quicklisp/setup.lisp")

(ql:quickload "cl-interpol" :silent t)

(interpol:enable-interpol-syntax)

(format t #?"\e[?1049h")
(format t #?"\e[1;1HHello World")

(sleep 2)

(format t #?"\e[?1049l")

(format t "real world")
