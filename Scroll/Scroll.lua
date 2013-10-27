-----------------------------------------------
-- @class: Scroll
-- @file Scroll.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local scroller = require 'scroller'

-- ======
-- CLASS
-- ======
local Scroll = View:subclass('Scroll')

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

Scroll.static.friction = 0.94
Scroll.static.scrollStopThreshold = 250
-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Scroll Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Scroll:initialize(opt)
  View.initialize(self, opt)
  self.class:include(scroller)
  self.frame:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

function Scroll:scrollToPosition(offset, animated)
  if not offset then return end
  local view = self.bounds
  local targetY = offset or 0
  -- close tracking and dragging listener
  view._updateRuntime = false
  view._trackVelocity = false
  -- Reset velocity back to 0
  view._velocity = 0
  if animated then
    transition.to( view, { y = targetY, time = 400, transition = easing.inOutQuad} )
  end
end

function Scroll:scrollBy(offsetY)
  local view = self.bounds
  view.y = view.y + offsetY
end

function Scroll:removeFromSuperView()
  -- remove event listeners if any.
  Runtime:removeEventListener("enterFrame", self)
  self.frame:removeEventListener("touch", self)
  View.removeFromSuperView(self)
end

return Scroll