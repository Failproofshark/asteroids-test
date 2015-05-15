(in-package :cl-user)

(defpackage :asteroids.helpers
  (:use :cl)
  (:export :degrees-to-radians
           :radians-to-degrees))

(in-package :asteroids.helpers)

(defun degrees-to-radians (degrees)
  (* degrees (/ pi 180)))

(defun radians-to-degrees (radians)
  (* radians (/ 180 pi)))
