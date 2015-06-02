(in-package :asdf-user)
(defsystem "asteroids"
  :depends-on (:sdl2
               :sdl2-mixer)
  :serial t
  :components ((:file "helpers")
               (:file "entities-package")
               (:file "channel-enum")
               (:file "box")
               (:file "vector")
               (:file "sprite")
               (:file "entity")
               (:file "boundary-behaviors")
               (:file "asteroid")
               (:file "ship")
               (:file "bullet")
               (:file "main")))
