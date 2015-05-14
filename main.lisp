(in-package :cl-user)

(defpackage :asteroids
  (:use :cl
        :sdl2
        ;;Unsure if box and sprite will really be needed
        :asteroids.entities.box
        :asteroids.entities.sprite
        :asteroids.entities.ship))

(in-package :asteroids)

(require :cl-opengl)
;;IDEA
(defun rungame ()
  (let ((player (make-instance 'Ship :x 400 :y 300)))
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
          (format t "Doing something")
          (with-event-loop (:method :poll)
            (:keydown
             (:keysym keysym)
             (let ((scancode (scancode-value keysym)))
               (handle-keydown-input player scancode)))
            (:idle ()
                   (gl:clear :color-buffer)
                   (gl:load-identity)
                   (gl:translate (center-x player) (center-y player) 0)
                   (draw player)
                   (gl:flush)
                   (gl-swap-window my-window))
            (:quit () t)))))))
