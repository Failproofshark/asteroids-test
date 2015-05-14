(in-package :asdf-user)
(defsystem "asteroids"
  :depends-on (:sdl2)
  :components ((:file "box")
               (:file "sprite" :depends-on ("box"))
               (:file "main" :depends-on ("box" "sprite"))))
