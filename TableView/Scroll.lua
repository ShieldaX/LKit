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

function Scroll:scrollTo(offsetOrPosition, animated)
  if not offsetOrPosition then return end
  local view = self.bounds
  local target = offsetOrPosition
  if type(target) == "string" then
    self:updateLimitation()
    target = (target == "top" and self.bottomLimit) or (target == "bottom" and self.upperLimit)
  end
  if type(target) ~= "number" then return end
  print("will scroll to " .. target)
  -- close tracking and dragging listener
  self.decelerating = false
  self.dragging = false
  -- Reset velocity back to 0
  self.velocity = 0
  if animated then
    self.tween = transition.to( view, { y = target, time = 400, transition = easing.inOutQuad} )
  end
end

-- Scroll content view to make content in special bounds be visible.
-- @param position Special position algin to scrolling bounds, currently only support "top" or "bottom".
function Scroll:scrollBoundsTo(bounds, position, animated)
  position = position or "top"
end

function Scroll:removeFromSuperView()
  -- remove event listeners if any.
  Runtime:removeEventListener("enterFrame", self)
  self.frame:removeEventListener("touch", self)
  View.removeFromSuperView(self) -- super call
end

return Scroll