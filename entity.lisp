(in-package :asteroids.entities)
(defclass Entity (Sprite) nil)
(defgeneric update (Entity))
