; add function
(defun do_add (a b) (+ a b))

(format T "Hello from Common Lisp!~%")
(format T "a + b = ~d~%" (do_add 1 2))
