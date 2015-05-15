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
  (with-accessors ((color color) (x x) (y y) (width width) (height height)) Sprite
    (gl:begin :quads)
    (apply #'gl:color color)
    (gl:vertex (* -1 (/ width 2)) (/ height 2))
    (gl:vertex (/ width 2) (/ height 2))
    (gl:vertex (/ width 2) (* -1 (/ height 2)))
    (gl:vertex (* -1 (/ width 2)) (* -1 (/ height 2)))
    (gl:end)
    (gl:begin :lines)
    (gl:color 1.0 0.0 0.0)
    (gl:vertex 0 0)
    (gl:vertex width 0)
    (gl:end)))
