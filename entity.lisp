(in-package :asteroids.entities)
(defclass Entity (Sprite Box) nil)
(defgeneric update (Entity))
