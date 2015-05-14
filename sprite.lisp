(in-package :cl-user)
(defpackage :asteroids.entities.sprite
  (:use :cl
        :asteroids.entities.box)
  (:export :sprite
           :color
           :draw))

(in-package :asteroids.entities.sprite)

(require :cl-opengl)

(defclass sprite (Box)
  ((color
    :initarg :color
    :accessor color)))

(defgeneric draw (Sprite)
    (:documentation "How to draw the sprite to the screen"))

(defmethod draw (Sprite)
  (with-accessors ((color color)) Sprite
    (gl:begin :quads)
    (apply #'gl:color color)
    (gl:vertex (left Sprite) (top Sprite))
    (gl:vertex (right Sprite) (top Sprite))
    (gl:vertex (right Sprite) (bottom Sprite))
    (gl:vertex (left Sprite) (bottom Sprite))
    (gl:end)))
