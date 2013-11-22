-----------------------------------------------
-- @class: Control
-- @file Control.lua - v0.0.1 (2013-09)
-- Abstract class for control classes, Button, Slider, etc.
-----------------------------------------------
-- created at: 2013-11-08 10:43:52

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Control = View:subclass('Control')

-- ======
-- CONSTANTS
-- ======

Control.State = {
  Normal = 1,
  Highlighted = 2,
  Disabled = 3,
  Selected = 4
}

-- ======
-- VARIABLES
-- ======

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Control Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Control:initialize(opt)
  View.initialize(self, opt)
end

return Control