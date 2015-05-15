(in-package :asdf-user)
(defsystem "asteroids"
  :depends-on (:sdl2)
  :components ((:file "box")
               (:file "helpers")
               (:file "vector" :depends-on ("helpers"))
               (:file "sprite" :depends-on ("box"))
               (:file "ship" :depends-on ("sprite" "vector"))
               (:file "main" :depends-on ("box" "sprite"))))
