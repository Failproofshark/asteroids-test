(in-package :asteroids.entities)

(defclass Box ()
  ((box-x :initarg :box-x
      :accessor box-x)
   (box-y :initarg :box-y
      :accessor box-y)
   (box-width :initarg :box-width
          :accessor box-width)
   (box-height :initarg :box-height
           :accessor box-height)))

(defgeneric top (Box)
  (:documentation "Returns a box-y coordinate point representing the top of the box"))
(defgeneric bottom (Box)
  (:documentation "Returns a box-y coordinate point representing the bottom of the box"))
(defgeneric left (Box)
  (:documentation "Returns an box-x coordinate point representing the left side of the box"))
(defgeneric right (Box)
  (:documentation "Returns an box-x coordinate point representing the right side of the box"))
(defgeneric detect-collision (Box-1 Box-2)
  (:documentation "Detects a collision between two box objects"))

(defmethod top (Box)
  (+ (box-y Box) (/ (box-height Box) 2)))
(defmethod bottom (Box)
  (- (box-y Box) (/ (box-height Box) 2)))
(defmethod left (Box)
  (- (box-x Box) (/ (box-width Box) 2)))
(defmethod right (Box)
  (+ (box-x Box) (/ (box-width Box) 2)))
(defmethod detect-collision ((box-1 box) (box-2 box))
  (not (or (< (top box-2) (bottom box-1))
           (> (bottom box-2) (top box-1))
           (< (right box-2) (left box-1))
           (> (left box-2) (right box-1)))))
