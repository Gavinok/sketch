;;;; utils.lisp

(in-package #:sketch)

;;;  _   _ _____ ___ _     ____
;;; | | | |_   _|_ _| |   / ___|
;;; | | | | | |  | || |   \___ \
;;; | |_| | | |  | || |___ ___) |
;;;  \___/  |_| |___|_____|____/

(defun pad-list (list pad length)
  (if (>= (length list) length)
      list
      (append (make-list (- length (length list)) :initial-element pad)
	      list)))

(defun group (list &optional (group-length 2))
  (flet ((split-n (list n)
	   (when (>= (length list) n)
	       (loop with acc = '()
		  for i below n
		  do (setf acc (cons (car list) acc)
			   list (cdr list))
		  finally (return (cons (nreverse acc) list))))))
    (loop with acc = '()
       while (or (not acc) (cdr list))
       do (let ((split (split-n list group-length)))
	    (when (car split)
	      (setf acc (cons (car split) acc)))
	    (setf list (cdr split)))
       finally (return (nreverse acc)))))

(defun group-bits (x &optional (bits 8))
  (let ((bit-fill (1- (expt 2 bits))))
    (do* ((x x (ash x (- bits)))
	  (acc `(,(boole boole-and x bit-fill))
	       (cons (boole boole-and x bit-fill) acc)))
	 ((zerop x) (cdr acc)))))

(declaim (inline order-list))
(defun order-list (order list)
  (loop for o in order
     collect (nth o list)))

(declaim (inline mix-lists))
(defun mix-lists (&rest lists)
  (apply #'append (apply #'mapcar #'list lists)))

(declaim (inline div2-inexact))
(defun div2-inexact (a)
  (multiple-value-bind (x y)
      (ceiling a 2)
    (values x (+ x y))))

(declaim (inline lerp-list))
(defun lerp-lists (v list-a list-b)
  (mapcar (lambda (a b) (alexandria:lerp v a b)) list-a list-b))
