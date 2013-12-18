-----------------------------------------------
-- @class Gesture
-- @file Gesture.lua - v0.0.1 (2013-09)
-- An abstract base class for concrete gesture-recognizer classes, Pan, Flick, Pinch.
-- Use FSM (inite-state machine)
-----------------------------------------------
-- created at: 2013-12-13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'

-- ======
-- CLASS
-- ======
local Gesture = class('Gesture')

-- ======
-- CONSTANTS
-- ======

Gesture.static.State = {
  "Possible" = "possible",
  "Recongnized" = "recongnized",
  "Failed" = "failed",
  "Cancelled" = "cancelled",
  -- state for continuous gestures
  "Began" = "began",
  "Changed" = "changed",
  "Ended" = "ended",
}

-- ======
-- VARIABLES
-- ======

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Gesture Recongnizer
-- ------

function Gesture:initialize(opt)
  system.activate("multitouch") -- ensure multitouch be actived

  self.state = nil
  -- control path of actions in gesture recognition

end

-- ------
-- Getting the Touches and Location of a Gesture
-- ------

function Gesture:locationInView(view)
end

function Gesture:locationOfTouchInView(touch, view)
end

function Gesture:numberOfTouches()
end

-- ------
-- Getting the Recognizer’s State and View
-- ------



return Gesture