(in-package :asteroids.entities)

(defclass Bullet (entity kill-behavior)
  ((color
    :initform '(1.0 0.0 0.0 1.0))
   (sprite-x
    :initform 9999)
   (sprite-width
    :initform 3)
   (sprite-height
    :initform 3)
   (box-x
    :initform 9999)
   (box-width
    :initform 3)
   (box-height
    :initform 3)
   (velocity
    :initform (make-instance 'math-vector)
    :accessor velocity)
   (off-screen
    :initform t
    :accessor off-screen)))

(defgeneric shoot (bullet x y speed direction))

(defgeneric reload-bullet (bullet))

(defmethod reload-bullet ((bullet bullet))
  (setf (box-x bullet) 9999)
  (setf (sprite-x bullet) 9999)
  (setf (off-screen bullet) t))

(defmethod shoot ((bullet bullet) x-position y-position speed direction)
  (with-accessors ((box-x box-x) (box-y box-y) (sprite-x sprite-x) (sprite-y sprite-y) (velocity velocity) (off-screen off-screen)) bullet
    (setf box-x x-position)
    (setf box-y y-position)
    (setf sprite-x x-position)
    (setf sprite-y y-position)    
    (setf (magnitude velocity) speed)
    (setf (direction velocity) direction)
    (setf off-screen nil)))

(defmethod update ((bullet bullet))
  (with-accessors ((velocity velocity) (box-x box-x) (box-y box-y) (sprite-x sprite-x) (sprite-y sprite-y)) bullet
    (incf sprite-x (get-x-component velocity))
    (incf sprite-y (get-y-component velocity))
    (setf box-x sprite-x)
    (setf box-y sprite-y)))

(defmethod draw ((bullet bullet))
  (with-accessors ((sprite-x sprite-x) (sprite-y sprite-y)) bullet
    (gl:load-identity)
    (gl:translate sprite-x sprite-y 0)
    (call-next-method)))
