(in-package :asteroids.entities)

(require :sdl2-mixer)

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
   (velocity
    :documentation "A math-vector representing the asteroid's velocity"
    :initarg :velocity
    :accessor velocity)
   (explosion-sound-effect
    :initform (sdl2-mixer:load-wav (asdf:system-relative-pathname 'asteroids "250712__aiwha__explosion.ogg"))
    :accessor explosion-sound-effect)))

(defgeneric split-asteroid (asteroid)
  (:documentation "Splits the asteroid into two asteroids IF it's hit points are in the positive. Returns two values, a boolean representing whether or not the asteroid split and a new asteroid with hit-points one less than the one passed in and a velocity vector going in the different direction. As a side effect the asteroid passed in will have it's hp reduced by one and the direction of it's velocity changed"))

(defgeneric initialize-asteroid (asteroid)
  (:documentation "Sets the size of the asteroid according to it's HP"))

(defgeneric is-dead (asteroid)
  (:documentation "A predicate to tell if an asteroid should be removed or not"))

(defmethod initialize-asteroid ((asteroid asteroid))
  (with-accessors ((hit-points hit-points) (sprite-x sprite-x) (sprite-y sprite-y) (sprite-width sprite-width) (sprite-height sprite-height) (box-width box-width) (box-height box-height) (box-x box-x) (box-y box-y)) asteroid
    (ecase hit-points
      (0 (setf sprite-width 15)
         (setf sprite-height 15))
      (1 (setf sprite-width 25)
         (setf sprite-height 25))
      (2 (setf sprite-width 40)
         (setf sprite-height 40))
      (3 (setf sprite-width 70)
         (setf sprite-height 70))
      (t (setf sprite-width 0)
         (setf sprite-height 0)))
    (setf box-width (- sprite-width 10))
    (setf box-height (- sprite-height 10))
    (setf box-x sprite-x)
    (setf box-y sprite-y)))

(defmethod is-dead ((asteroid asteroid))
  (< (hit-points asteroid) 0))

(defmethod split-asteroid ((asteroid asteroid))
  (with-accessors ((hit-points hit-points) (velocity velocity) (sprite-x sprite-x) (sprite-y sprite-y) (explosion-sound-effect explosion-sound-effect)) asteroid
    (when (= 0 (sdl2-mixer:playing (getf channel-enum :asteroid-explosion)))
      (sdl2-mixer:play-channel (getf channel-enum :asteroid-explosion) explosion-sound-effect 0))
    (let ((new-direction (+ (/ (direction velocity) 2) 10)))
      (decf hit-points)
      (when (> hit-points -1)
            (initialize-asteroid asteroid)
            (setf (direction velocity) new-direction)
            (make-instance 'asteroid
                           :sprite-x sprite-x
                           :sprite-y sprite-y
                           :hit-points hit-points
                           :velocity (make-instance 'math-vector
                                                    :magnitude (+ (magnitude velocity) 1)
                                                    :direction (* -1 new-direction)))))))

;;The reason why we don't do the random initialization here is because random parameters are only set between each stages. In other words, we don't want random values when we create split asteroids after they are hit
(defmethod initialize-instance :after ((asteroid asteroid) &key)
  (initialize-asteroid asteroid))

(defmethod update ((asteroid asteroid))
  (with-accessors ((velocity velocity) (rotation-angle rotation-angle) (box-x box-x) (box-y box-y) (sprite-x sprite-x) (sprite-y sprite-y)) asteroid
    (setf rotation-angle (1+ rotation-angle))
    (incf sprite-x (get-x-component velocity))
    (incf sprite-y (get-y-component velocity))
    (setf box-x sprite-x)
    (setf box-y sprite-y)))

(defmethod draw ((asteroid asteroid))
  (with-accessors ((rotation-angle rotation-angle) (box-x box-x) (box-y box-y) (box-width box-width) (box-height box-height) (sprite-x sprite-x) (sprite-y sprite-y)) asteroid
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
