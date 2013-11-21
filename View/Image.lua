-----------------------------------------------
-- @class: Image
-- @file Image.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Image = View:subclass 'Image'

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentHeight
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

-- ======
-- VARIABLES
-- ======

-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Image Object
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Image:initialize(api)
  
  
  View.initialize(self, api)
end



return Image