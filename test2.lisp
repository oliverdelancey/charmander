(defun stuff () (let ((mode :end))
  (ecase mode
	(:end 0)
	(:beginning 1)
	(:entire 2)
	(:entire-delete 3))))
