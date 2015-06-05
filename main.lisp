(in-package :cl-user)

(defpackage :asteroids
  (:use :cl
        :sdl2
        :asteroids.entities))

(in-package :asteroids)

(require :sdl2-mixer)
(require :cl-opengl)

;;IDEA
(defun rungame ()
  ;;The need for split random range is so that we don't spawn an asteroid on, or unbelievably close to a ship when the level begins
  (labels ((coin-toss ()
             (> (random 1.0) .49))
           (random-range (min max)
             (+ min (random (- max min))))
           (split-random-range (range-1 range-2)
             (if (coin-toss)
                 (random-range (car range-1) (cadr range-1))
                 (random-range (car range-2) (cadr range-2))))
           (generate-asteroids (number-of-asteroids)
             (loop for i from 1 upto number-of-asteroids collect
                  (make-instance 'asteroid
                                 :sprite-x (split-random-range '(5 200) '(600 750))
                                 :sprite-y (split-random-range '(5 100) '(400 550))
                                 :hit-points 3
                                 :velocity (make-instance 'math-vector
                                                          :magnitude (if (coin-toss)
                                                                         1.5
                                                                         -1.5)
                                                          :direction (random-range 30 85)))))
           (player-killed (asteroids player)
             (flet ((asteroid-player-collision (asteroid)
                      (detect-collision player asteroid)))
               (remove nil
                       (map 'list
                            #'asteroid-player-collision
                            asteroids))))
           (split-hit-asteroids (asteroids bullets)
             (let ((hit-asteroids nil))
               (loop for bullet in bullets do
                    (loop for asteroid in asteroids when (detect-collision asteroid bullet) do
                         (reload-bullet bullet)
                         (pushnew asteroid hit-asteroids)
                         (return)))
               (when hit-asteroids
                 (values t
                         (let ((new-asteroids (remove nil
                                                      (map 'list
                                                           #'(lambda (asteroid)
                                                               (split-asteroid asteroid))
                                                           hit-asteroids))))
                           (append (remove-if #'is-dead asteroids) new-asteroids)))))))
    (with-init (:everything)
      ;; SDL2-Mixer stuff
      (sdl2-mixer:init :ogg)
      (sdl2-mixer:open-audio 22050 :s16sys 2 1024)
      (sdl2-mixer:allocate-channels 3)
      (let ((player (make-instance 'Ship :sprite-x 400 :sprite-y 300))
            (asteroids (generate-asteroids 4))
            (game-over nil))
        (with-window (my-window :title "Asteroids" :flags '(:shown :opengl))
          (with-gl-context (gl-context my-window)
            (gl-make-current my-window gl-context)
            (gl:viewport 0 0 800 600)
            (gl:matrix-mode :projection)
            (gl:ortho 0 800 0 600 -10 10)
            (gl:matrix-mode :modelview)
            (gl:load-identity)
            (gl:clear-color 0.0 0.0 0.0 0.0)
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
                     (unless game-over
                       (map 'list
                            #'(lambda (entity)
                                (update entity)
                                (boundary-check entity 800 600))
                            (append `(,player)
                                    (get-launched-bullets player)
                                    asteroids))
                       (when (player-killed asteroids player)
                         (format t "killed")
                         (kill-ship player)
                         (setf game-over t))
                       (multiple-value-bind (found-hits new-asteroid-list) (split-hit-asteroids asteroids (get-launched-bullets player))
                         (when found-hits
                           (setf asteroids new-asteroid-list)))
                       (gl:clear :color-buffer)
                       (gl:load-identity)
                       (map 'list
                            #'(lambda (entity)
                                (draw entity))
                            (append `(,player)
                                    (get-launched-bullets player)
                                    asteroids))
                       (gl:flush)
                       (gl-swap-window my-window)))
              (:quit ()
                     (sdl2-mixer:halt-channel -1)
                     (sdl2-mixer:close-audio)
                     (sdl2-mixer:quit)
                     t))))))))
