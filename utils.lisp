;;;;
;;;; UTILS.LISP
;;;;
;;;; Oliver Delancey
;;;;
;;;; This file is a component of Project Charmander.
;;;; See LICENSE for usage permissions, limitations, and conditions.
;;;;


(in-package #:charmander)

;;; Custom DEFUN macro that also EXPORTs the function.
(defmacro defun-ex (name (&rest params) &body body)
  `(progn (defun ,name (,@params)
			,@body)
		  (export ',name)))
