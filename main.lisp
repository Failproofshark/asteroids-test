(in-package :cl-user)

(defpackage :asteroids
  (:use :cl
        :sdl2
        :asteroids.entities))

(in-package :asteroids)

(require :cl-opengl)
;;IDEA
(defun rungame ()
  (let ((player (make-instance 'Ship :x 400 :y 300))
        (asteroids `(,(make-instance 'Asteroid :hit-points 3))))
    (with-init (:everything)
      (with-window (my-window :title "Asteroids" :flags '(:shown :opengl))
        (with-gl-context (gl-context my-window)
          (gl-make-current my-window gl-context)
          (gl:viewport 0 0 800 600)
          (gl:matrix-mode :projection)
          (gl:ortho 0 800 0 600 -10 10)
          (gl:matrix-mode :modelview)
          (gl:load-identity)
          (gl:clear-color 1.0 1.0 1.0 1.0)
          (gl:clear :color-buffer)
          (with-event-loop (:method :poll)
            (:keydown
             (:keysym keysym)
             (let ((scancode (scancode-value keysym)))
               (handle-keydown-input player scancode)))
            (:keyup
             (:keysym keysym)
             (let ((scancode (scancode-value keysym)))
               (handle-keyup-input player scancode)))
            (:idle ()
                   (map 'list
                        #'(lambda (entity)
                            (update entity)
                            (boundary-check entity 800 600))
                        (append `(,player)
                                asteroids))
                   (gl:clear :color-buffer)
                   (gl:load-identity)
                   (gl:translate (center-x player) (center-y player) 0)
                   (map 'list
                        #'(lambda (entity)
                            (draw entity))
                        (append `(,player)
                                asteroids))
                   (gl:flush)
                   (gl-swap-window my-window))
            (:quit () t)))))))
