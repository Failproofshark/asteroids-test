(in-package :cl-user)
(defpackage :asteroids.entities.ship
  (:use :cl
        :sdl2
        :asteroids.entities.box
        :asteroids.entities.sprite
        :asteroids.entities.math-vector)
  (:export :ship
           :update
           :handle-keydown-input))

(in-package :asteroids.entities.ship)

(require :cl-opengl)

(defclass Ship (sprite)
  ((color
    :initform '(0.3 0.5 0.2 1.0))
   (width
    :initform 30)
   (height
    :initform 30)
   ;;Yes technically acceleration is a vector but for our purposes simply knowing the magnitude is ok.
   (acceleration
    :initform (make-instance 'math-vector)
    :accessor acceleration)
   ;;Everything is upside down
   (rotation-angle
    :initform 270.0
    :accessor rotation-angle)))

(defgeneric handle-keydown-input (Ship scancode)
  (:documentation "Handle keydown events from the user"))

(defgeneric update (ship)
  (:documentation "An update routine for any possible changes to it's position and perhaps more"))

(defmethod handle-keydown-input ((ship ship) scancode)
  (with-accessors ((rotation-angle rotation-angle) (acceleration acceleration) (x x) (y y)) ship
    (cond
      ((scancode= scancode :scancode-left) (decf rotation-angle 2))
      ((scancode= scancode :scancode-right) (incf rotation-angle 2))
      ((scancode= scancode :scancode-up) (progn (setf (direction acceleration) rotation-angle)
                                                (incf (magnitude acceleration) 0.5))))))

(defmethod update ((ship ship))
  (with-accessors ((x x) (y y) (rotation-angle rotation-angle) (acceleration acceleration)) ship
      (incf x (get-x-component acceleration))
      (incf y (get-y-component acceleration))))

(defmethod draw ((ship ship))
  (with-accessors ((rotation-angle rotation-angle)) ship
    (gl:load-identity)
    (gl:translate (center-x ship) (center-y ship) 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))
