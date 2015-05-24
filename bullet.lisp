(in-package :asteroids.entities)

(defclass Bullet (entity kill-behavior)
  ((color
    :initform '(1.0 0.0 0.0 1.0))
   (x
    :initform 9999)
   (width
    :initform 3)
   (height
    :initform 3)
   (velocity
    :initform (make-instance 'math-vector)
    :accessor velocity)
   (off-screen
    :initform t
    :accessor off-screen)))

(defgeneric shoot (bullet x y speed direction))

(defmethod shoot ((bullet bullet) x-position y-position speed direction)
  (with-accessors ((x x) (y y) (velocity velocity) (off-screen off-screen)) bullet
    (setf x x-position)
    (setf y y-position)
    (setf (magnitude velocity) speed)
    (setf (direction velocity) direction)
    (setf off-screen nil)))

(defmethod update ((bullet bullet))
  (with-accessors ((velocity velocity) (x x) (y y)) bullet
    (incf x (get-x-component velocity))
    (incf y (get-y-component velocity))))

(defmethod draw ((bullet bullet))
  (gl:load-identity)
  (gl:translate (center-x bullet) (center-y bullet) 0)
  (call-next-method))
