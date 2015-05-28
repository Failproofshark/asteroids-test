(in-package :asteroids.entities)

(defclass Asteroid (entity reset-behavior)
  ((hit-points
    :documentation "Initially a number between 0-3. Essentially this determines the number of times this thing can be split as well as it's initial size"
    :initarg :hit-points
    :accessor hit-points)
   (color
    :initform '(0.0 0.0 1.0))
   (rotation-angle
    :initform 0
    :accessor rotation-angle)
   (x
    :initform 20)
   (y
    :initform 20)
   (velocity
    :documentation "A math-vector representing the asteroid's velocity"
    :initarg :velocity
    :accessor velocity)))

(defgeneric split-asteroid (asteroid)
  (:documentation "Splits the asteroid into two asteroids IF it's hit points are in the positive. Returns two values, a boolean representing whether or not the asteroid split and a new asteroid with hit-points one less than the one passed in and a velocity vector going in the different direction. As a side effect the asteroid passed in will have it's hp reduced by one and the direction of it's velocity changed"))

(defgeneric set-size (asteroid)
  (:documentation "Sets the size of the asteroid according to it's HP"))

(defgeneric is-dead (asteroid)
  (:documentation "A predicate to tell if an asteroid should be removed or not"))

(defmethod set-size ((asteroid asteroid))
  (with-accessors ((hit-points hit-points) (width width) (height height)) asteroid
    (ecase hit-points
      (0 (setf width 15)
         (setf height 15))
      (1 (setf width 25)
         (setf height 25))
      (2 (setf width 40)
         (setf height 40))
      (3 (setf width 70)
         (setf height 70))
      (t (setf width 0)
         (setf height 0)))))

(defmethod is-dead ((asteroid asteroid))
  (< (hit-points asteroid) 0))

(defmethod split-asteroid ((asteroid asteroid))
  (with-accessors ((hit-points hit-points) (velocity velocity) (x x) (y y)) asteroid
    (let ((new-direction (+ (/ (direction velocity) 2) 10)))
      (decf hit-points)
      (when (> hit-points -1)
            (set-size asteroid)
            (setf (direction velocity) new-direction)
            (make-instance 'asteroid
                           :x x
                           :y y
                           :hit-points hit-points
                           :velocity (make-instance 'math-vector
                                                    :magnitude (+ (magnitude velocity) 1)
                                                    :direction (* -1 new-direction)))))))

;;The reason why we don't do the random initialization here is because random parameters are only set between each stages. In other words, we don't want random values when we create split asteroids after they are hit
(defmethod initialize-instance :after ((asteroid asteroid) &key)
  (set-size asteroid))

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
