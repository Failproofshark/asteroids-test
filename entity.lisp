(in-package :asteroid.entities)
(defclass Entity (Sprite) nil)
(defgeneric update (Entity))
