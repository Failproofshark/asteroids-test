(in-package :asteroids.entities)

(require :cl-opengl)

(defclass sprite ()
  ((sprite-x
    :initarg :sprite-x
    :accessor sprite-x)
   (sprite-y
    :initarg :sprite-y
    :accessor sprite-y)
   (sprite-width
    :initarg :sprite-width
    :accessor sprite-width)
   (sprite-height
    :initarg :sprite-height
    :accessor sprite-height)
   (color
    :initarg :color
    :accessor color)))

(defgeneric draw (Sprite)
    (:documentation "How to draw the sprite to the screen"))

(defmethod draw ((sprite sprite))
  (with-accessors ((color color) (sprite-width sprite-width) (sprite-height sprite-height)) sprite
      (gl:begin :lines)
      (apply #'gl:color color)
      (gl:vertex (* -1 (/ sprite-width 2)) (/ sprite-height 2))
      (gl:vertex (/ sprite-width 2) (/ sprite-height 2))
      
      (gl:vertex (/ sprite-width 2) (/ sprite-height 2))
      (gl:vertex (/ sprite-width 2) (* -1 (/ sprite-height 2)))
      
      (gl:vertex (/ sprite-width 2) (* -1 (/ sprite-height 2)))
      (gl:vertex (* -1 (/ sprite-width 2)) (* -1 (/ sprite-height 2)))

      (gl:vertex (* -1 (/ sprite-width 2)) (* -1 (/ sprite-height 2)))
      (gl:vertex (* -1 (/ sprite-width 2)) (/ sprite-height 2))
      (gl:end)
      (gl:begin :lines)
      (gl:color 1.0 0.0 0.0)
      (gl:vertex 0 0)
      (gl:vertex sprite-width 0)
      (gl:end)))
