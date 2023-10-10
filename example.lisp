(load "charmander.asd")
(ql:quickload :charmander :silent t)

; should output Jello and a newline
(format t "Hello")
(charmander:save-cursor-position)
(charmander:cursor-back 5)
(format t "J")
(charmander:restore-cursor-position)
(format t "~%")
(force-output)
; should show dogs for 2 seconds, then change to cats
(format t "dogs")
(force-output)
(sleep 2)
(charmander:erase-line 2)
(charmander:carriage-return)
(format t "cats~%")
(exit)
