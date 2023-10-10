;;;;
;;;; CHARMANDER.ASD
;;;;
;;;; Oliver Delancey
;;;;
;;;; This file is a component of Project Charmander.
;;;; See LICENSE for usage permissions, limitations, and conditions.
;;;;

(asdf:defsystem "charmander"
		:description "Terminal control library"
		:version "0.0.0"
		:author "Oliver Delancey"
		:license "MIT"
		:depends-on ("cl-interpol")
		:serial t
		:components ((:file "package")
					 (:file "utils")
			     	 (:file "charmander")))
