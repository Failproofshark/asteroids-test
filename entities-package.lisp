(in-package :cl-user)
(defpackage :asteroids.entities
  (:use :cl
        :sdl2
        :asteroids.helpers)
  (:export :Box
           :x
           :y
           :width
           :height
           :top
           :bottom
           :left
           :right
           :center-x
           :center-y
           :detect-collision
           :math-vector
           :direction
           :magnitude
           :get-x-component
           :get-y-component
           :get-vector-components
           :vector+
           :entity
           :update
           :reset-behavior
           :boundary-check
           :ship
           :get-launched-bullets
           :asteroid
           :bullet
           :shoot
           :sprite
           :color
           :draw
           :handle-keydown-input
           :handle-keyup-input))
