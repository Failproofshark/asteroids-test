(in-package :cl-user)
(defpackage :asteroids.entities.ship
  (:use :cl
        :sdl2
        :asteroids.entities.box
        :asteroids.entities.sprite
        :asteroids.helpers)
  (:export :ship
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
   (rotation-angle
    :initform 0.0
    :accessor rotation-angle)))

(defgeneric handle-keydown-input (Ship scancode)
  (:documentation "Handle keydown events from the user"))

(defmethod handle-keydown-input ((ship ship) scancode)
  (with-accessors ((rotation-angle rotation-angle) (x x) (y y)) ship
    (cond
      ((scancode= scancode :scancode-left) (decf rotation-angle 2))
      ((scancode= scancode :scancode-right) (incf rotation-angle 2))
      ((scancode= scancode :scancode-up) (let* ((radians (degrees-to-radians rotation-angle))
                                                (delta-x (cos radians))
                                                (delta-y (sin radians)))
                                           (incf x delta-x)
                                           (incf y delta-y))))))

(defmethod draw ((ship ship))
  (with-accessors ((rotation-angle rotation-angle)) ship
    (gl:load-identity)
    (gl:translate (center-x ship) (center-y ship) 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))
