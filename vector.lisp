(in-package :cl-user)
(defpackage :asteroids.entities.math-vector
  (:use :cl
        :asteroids.helpers)
  (:export :math-vector
           :direction
           :magnitude
           :get-x-component
           :get-y-component
           :get-vector-components))
(in-package :asteroids.entities.math-vector)
;; Named to distinguish itself from the vector data structure
(defclass Math-Vector ()
  ((direction
    :initarg :direction
    :initform 0
    :accessor direction)
   (magnitude
    :initarg :magnitude
    :initform 0
    :accessor magnitude)))
(defgeneric get-x-component (math-vector)
  (:documentation "Returns the x vector component"))
(defgeneric get-y-component (math-vector)
  (:documentation "Returns the y vector component"))
(defgeneric get-vector-components (math-vector)
  (:documentation "Returns the x and y vector components of the vector as a list"))

(defmethod get-x-component ((math-vector math-vector))
  (* (magnitude math-vector) (cos (degrees-to-radians (direction math-vector)))))

(defmethod get-y-component ((math-vector math-vector))
  (* (magnitude math-vector) (sin (degrees-to-radians (direction math-vector)))))

(defmethod get-math-vector-components ((math-vector math-vector))
  `(,(get-x-component math-vector) ,(get-y-component math-vector)))
