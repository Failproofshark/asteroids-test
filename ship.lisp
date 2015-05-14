(in-package :cl-user)
(defpackage :asteroids.entities.ship
  (:use :cl
        :sdl2
        :asteroids.entities.box
        :asteroids.entities.sprite)
  (:export :ship
           :handle-keydown-input))

(in-package :asteroids.entities.ship)

(require :cl-opengl)

(defclass Ship (sprite)
  ((color
    :initform '(0.3 0.5 0.2 1.0))
   (width
    :initform 20)
   (height
    :initform 20)
   (rotation-angle
    :initform 0.0
    :accessor rotation-angle)))

(defgeneric handle-keydown-input (Ship scancode)
  (:documentation "Handle keydown events from the user"))

(defmethod handle-keydown-input ((ship ship) scancode)
  (with-accessors ((rotation-angle rotation-angle)) ship
    (cond
      ((scancode= scancode :scancode-left) (decf rotation-angle 2))
      ((scancode= scancode :scancode-right) (incf rotation-angle 2)))))

(defmethod draw ((ship ship))
  (with-accessors ((rotation-angle rotation-angle)) ship
    (gl:load-identity)
    (gl:translate (center-x ship) (center-y ship) 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))
