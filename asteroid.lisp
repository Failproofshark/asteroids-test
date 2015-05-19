(in-package :asteroids.entities)

(defclass Asteroid (Sprite)
  ((hit-points
    :documentation "Initially a number between 0-3. Essentially this determines the number of times this thing can be split as well as it's initial size"
    :initarg :hit-points
    :accessor hit-points)
   (color
    :initform '(0.0 0.0 1.0))
   (rotation-angle
    :initform 0
    :accessor rotation-angle)
   (width
    :initform 0)
   (height
    :initform 0)
   (x
    :initform 20)
   (y
    :initform 20)
   (velocity
    :initform (make-instance 'math-vector :direction 30 :magnitude 2)
    :accessor velocity)))

(defmethod initialize-instance :after ((asteroid asteroid) &key)
  (with-accessors ((hit-points hit-points) (width width) (height height)) asteroid
    (ecase hit-points
      (0 (setf width 10)
         (setf height 10))
      (1 (setf width 25)
         (setf height 25))
      (2 (setf width 40)
         (setf height 40))
      (3 (setf width 70)
         (setf height 70)))))

(defmethod update ((asteroid asteroid))
  (with-accessors ((velocity velocity) (rotation-angle rotation-angle) (x x) (y y)) asteroid
    (setf rotation-angle (1+ rotation-angle))
    (incf x (get-x-component velocity))
    (incf y (get-y-component velocity))))

(defmethod draw ((asteroid asteroid))
  (with-accessors ((rotation-angle rotation-angle)) asteroid
    (gl:load-identity)
    (gl:translate (center-x asteroid) (center-y asteroid) 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))
