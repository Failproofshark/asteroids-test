(in-package :cl-user)

(defpackage :asteroids
  (:use :cl
        :sdl2
        :asteroids.entities.box
        :asteroids.entities.sprite))

(in-package :asteroids)

(require :cl-opengl)
;;IDEA
(defun rungame ()
  (let ((ship (make-instance 'sprite
                             :x 20
                             :y 20
                             :width 20
                             :height 20
                             :color '(0.3 0.5 0.2 1.0))))
    (with-init (:everything)
      (with-window (my-window :title "My Test" :flags '(:shown :opengl))
        (with-gl-context (gl-context my-window)
          (gl-make-current my-window gl-context)
          (gl:viewport 0 0 800 600)
          (gl:matrix-mode :projection)
          (gl:ortho 0 800 600 0 -10 10)
          (gl:matrix-mode :modelview)
          (gl:load-identity)
          (gl:clear-color 1.0 1.0 1.0 1.0)
          (gl:clear :color-buffer)
          (with-event-loop (:method :poll)
            (:idle ()
                   (gl:clear :color-buffer)
                   (draw ship)
                   (gl:flush)
                   (gl-swap-window my-window))
            (:quit () t)))))))
