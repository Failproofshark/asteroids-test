(in-package :cl-user)
(defpackage :asteroids.entities.math-vector
  (:documentation "A small helper library for vectors *should only be used for 2d maths*")
  (:use :cl
        :asteroids.helpers)
  (:export :math-vector
           :direction
           :magnitude
           :get-x-component
           :get-y-component
           :get-vector-components
           :vector+))
(in-package :asteroids.entities.math-vector)
;; Named to distinguish itself from the vector data structure
(defclass Math-Vector ()
  ;; IN DEGREES!
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
(defgeneric vector+ (math-vector math-vector)
  (:documentation "Perform vector addition"))
(defgeneric dot-product (math-vector math-vector)
  (:documentation "Find the dot product between two vectors"))

(defmethod get-x-component ((math-vector math-vector))
  (* (magnitude math-vector) (cos (degrees-to-radians (direction math-vector)))))

(defmethod get-y-component ((math-vector math-vector))
  (* (magnitude math-vector) (sin (degrees-to-radians (direction math-vector)))))

(defmethod get-math-vector-components ((math-vector math-vector))
  `(,(get-x-component math-vector) ,(get-y-component math-vector)))

(defmethod vector+ ((math-vector-1 math-vector) (math-vector-2 math-vector))
  "Usually vector addition gives a new veector, however since we're going to need the x and y components of the resultant vector we give report along with the resultant vector"
  (let* ((vector-1-x (get-x-component math-vector-1))
         (vector-1-y (get-y-component math-vector-1))
         (vector-2-x (get-x-component math-vector-2))
         (vector-2-y (get-y-component math-vector-2))
         (resultant-vector-x-component (+ vector-1-x vector-2-x))
         (resultant-vector-y-component (+ vector-1-y vector-2-y))
         (resultant-magnitude (sqrt (+ (expt resultant-vector-x-component 2) (expt resultant-vector-y-component 2))))
         (resultant-angle (radians-to-degrees (atan resultant-vector-y-component resultant-vector-x-component))))
    (values resultant-vector-x-component
            resultant-vector-y-component
            resultant-magnitude
            resultant-angle)))
