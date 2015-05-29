(in-package :asteroids.entities)

(require :cl-opengl)

(defclass Ship (entity reset-behavior)
  ((color
    :initform '(0.3 0.5 0.2 1.0))
   (sprite-width
    :initform 30)
   (sprite-height
    :initform 30)
   (box-width
    :initform 20)
   (box-height
    :initform 20)
   (velocity
    :initform (make-instance 'math-vector)
    :accessor velocity)
   (acceleration
    :initform (make-instance 'math-vector)
    :accessor acceleration)
   ;;Facing up
   (rotation-angle
    :initform 90.0
    :accessor rotation-angle)
   ;;Technically speaking we could make a bullet pool for unlimited bullets but for now this will do.
   (bullets
    :initform (loop for i from 0 upto 19 collect
                   (make-instance 'bullet))
    :accessor bullets)))

(defgeneric handle-keydown-input (Ship scancode)
  (:documentation "Handle keydown events from the user"))

(defgeneric handle-keyup-input (Ship scancode)
  (:documentation "Handle keyup events from the user"))

(defgeneric get-launched-bullets (Ship)
  (:documentation "Filter for launched bullets"))

(defmethod intialize-instance :after ((ship ship) &key)
  (with-accessors ((box-x box-x) (box-y box-y) (sprite-x sprite-x) (sprite-y sprite-y)) ship
    (setf box-x sprite-x)
    (setf box-y sprite-y)))

(defmethod handle-keydown-input ((ship ship) scancode)
  (with-accessors ((rotation-angle rotation-angle) (acceleration acceleration) (bullets bullets) (box-x box-x) (box-y box-y)) ship
    (flet ((shoot-bullet ()
             (let ((ammo (remove nil
                                 (map 'list
                                      #'(lambda (bullet)
                                          (when (off-screen bullet)
                                            bullet))
                                      bullets))))
               (when ammo
                 (shoot (car ammo) box-x box-y 5 rotation-angle)))))
      (cond
        ((scancode= scancode :scancode-left) (incf rotation-angle 5))
        ((scancode= scancode :scancode-right) (decf rotation-angle 5))
        ((scancode= scancode :scancode-up) (progn (setf (direction acceleration) rotation-angle)
                                                  (incf (magnitude acceleration) 0.005)))
        ((scancode= scancode :scancode-space) (shoot-bullet))))))

(defmethod handle-keyup-input ((ship ship) scancode)
  (with-accessors ((acceleration acceleration) (rotation-angle rotation-angle)) ship
    (cond
      ((scancode= scancode :scancode-up) (setf (magnitude acceleration) 0)))))

(defmethod update ((ship ship))
  (with-accessors ((sprite-x sprite-x) (sprite-y sprite-y) (box-x box-x) (box-y box-y) (rotation-angle rotation-angle) (acceleration acceleration) (velocity velocity)) ship
    (multiple-value-bind (resultant-x resultant-y resultant-magnitude resultant-angle) (vector+ velocity acceleration)
      (setf (magnitude velocity) resultant-magnitude)
      (setf (direction velocity) resultant-angle)
      (incf sprite-x resultant-x)
      (incf sprite-y resultant-y)
      (setf box-x sprite-x)
      (setf box-y sprite-y))))

(defmethod draw ((ship ship))
  (with-accessors ((rotation-angle rotation-angle) (sprite-x sprite-x) (sprite-y sprite-y) (box-x box-x) (box-y box-y) (box-width box-width) (box-height box-height)) ship
    ;;The following few lines is mainly for debuggin this will be removed
    (gl:load-identity)
    (gl:translate box-x box-y 0)
    (gl:color 1.0 .8 .2)
    (gl:begin :quads)
    (gl:vertex (* -1 (/ box-width 2)) (/ box-height 2))
    (gl:vertex (/ box-width 2) (/ box-height 2))
    (gl:vertex (/ box-width 2) (* -1 (/ box-height 2)))
    (gl:vertex (* -1 (/ box-width 2)) (* -1 (/ box-height 2)))    
    (gl:end)
    (gl:load-identity)
    (gl:translate sprite-x sprite-y 0)
    (gl:rotate rotation-angle 0 0 1))
  (call-next-method))

(defmethod get-launched-bullets ((ship ship))
  (remove nil
          (map 'list
               #'(lambda (bullet)
                   (unless (off-screen bullet)
                     bullet))
               (bullets ship))))
