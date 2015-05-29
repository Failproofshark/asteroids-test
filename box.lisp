(in-package :asteroids.entities)

(defclass Box ()
  ((x :initarg :x
      :accessor x)
   (y :initarg :y
      :accessor y)
   (width :initarg :width
          :accessor width)
   (height :initarg :height
           :accessor height)))

(defgeneric top (Box)
  (:documentation "Returns a y coordinate point representing the top of the box"))
(defgeneric bottom (Box)
  (:documentation "Returns a y coordinate point representing the bottom of the box"))
(defgeneric left (Box)
  (:documentation "Returns an x coordinate point representing the left side of the box"))
(defgeneric right (Box)
  (:documentation "Returns an x coordinate point representing the right side of the box"))
(defgeneric detect-collision (Box-1 Box-2)
  (:documentation "Detects a collision between two box objects"))

(defmethod top (Box)
  (+ (y Box) (/ (height Box) 2)))
(defmethod bottom (Box)
  (- (y Box) (/ (height Box) 2)))
(defmethod left (Box)
  (- (x Box) (/ (width Box) 2)))
(defmethod right (Box)
  (+ (x Box) (/ (width Box) 2)))
(defmethod detect-collision ((box-1 box) (box-2 box))
  (not (or (< (top box-2) (bottom box-1))
           (> (bottom box-2) (top box-1))
           (< (right box-2) (left box-1))
           (> (left box-2) (right box-1)))))
