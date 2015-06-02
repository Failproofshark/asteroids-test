(in-package :cl-user)
(defpackage :asteroids.entities
  (:use :cl
        :sdl2
        :asteroids.helpers)
  (:export :Box
           :box-x
           :box-y
           :box-width
           :box-height
           :top
           :bottom
           :left
           :right
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
           :split-asteroid
           :is-dead
           :bullet
           :reload-bullet
           :shoot
           :sprite
           :sprite-x
           :sprite-y
           :sprite-width
           :sprite-height
           :color
           :draw
           :handle-keydown-input
           :handle-keyup-input
           :channel-enum))
