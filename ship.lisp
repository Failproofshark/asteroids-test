(in-package :asteroids.entities)

(require :cl-opengl)

(defclass Ship (sprite)
  ((color
    :initform '(0.3 0.5 0.2 1.0))
   (width
    :initform 30)
   (height
    :initform 30)
   (velocity
    :initform (make-instance 'math-vector)
    :accessor velocity)
   ;;Yes technically acceleration is a vector but for our purposes simply knowing the magnitude is ok.
   (acceleration
    :initform (make-instance 'math-vector)
    :accessor acceleration)
   ;;Facing up
   (rotation-angle
    :initform 90.0
    :accessor rotation-angle)))

(defgeneric handle-keydown-input (Ship scancode)
  (:documentation "Handle keydown events from the user"))

(defgeneric handle-keyup-input (Ship scancode)
  (:documentation "Handle keyup events from the user"))

(defmethod handle-keydown-input ((ship ship) scancode)
  (with-accessors ((rotation-angle rotation-angle) (acceleration acceleration) (x x) (y y)) ship
    (cond
      ((scancode= scancode :scancode-left) (incf rotation-angle 2))
      ((scancode= scancode :scancode-right) (decf rotation-angle 2))
      ((scancode= scancode :scancode-up) (progn (setf (direction acceleration) rotation-angle)
                                                (incf (magnitude acceleration) 0.005))))))

(defmethod handle-keyup-input ((ship ship) scancode)
  (with-accessors ((acceleration acceleration)) ship
    (cond
      ((scancode= scancode :scancode-up) (setf (magnitude acceleration) 0)))))

(defmethod update ((ship ship))
  (with-accessors ((x x) (y y) (rotation-angle rotation-angle) (acceleration acceleration) (velocity velocity)) ship
    (multiple-value-bind (resultant-x resultant-y resultant-magnitude resultant-angle) (vector+ velocity acceleration)
      (setf (magnitude velocity) resultant-magnitude)
      (setf (direction velocity) resultant-angle)
      (incf x resultant-x)
      (incf y resultant-y))))

(defmethod draw ((ship ship))
  (with-accessors ((rotation-angle rotation-angle)) ship
    (gl:load-identity)
    (gl:translate (center-x ship) (center-y ship) 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))
