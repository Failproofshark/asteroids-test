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
           :math-vector
           :direction
           :magnitude
           :get-x-component
           :get-y-component
           :get-vector-components
           :vector+
           :entity
           :update
           :ship
           :asteroid
           :sprite
           :color
           :draw
           :handle-keydown-input
           :handle-keyup-input))
