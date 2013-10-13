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

Scroll.static.defaultFriction = 0.98
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
  self.isDirectionClocked = false
  self.enableScroll = true
  self.scrollBar = ScrollBar {style = "default"}
  self.contentHeight
  self.contentWidth
  self.contentOffsetX, self.contentOffsetY = 0, 0
  self.direction = "vertical"
  self.isBounceEnable = true
  
  -- scroll state
  self.tracking = false
  self.dragging = false
  self.decelerating = false
  
end

function Scroll:touch(event)
  local phase = event.phase
  local target = event.target
  
  if phase = "began" then
    self.tracking = true
    self.dragging = false
    display.getCurrentStage().setFocus(target)
    self._tempTimer = timer.performWithDelay(1000, function()
      print("detect motion")
      display.getCurrentStage().setFocus(nil)
      self.tracking = false
    end)
  else--if self.tracking then
    if phase = "moved" then
      timer.cancel(self._tempTimer)
      self._tempTIimer = nil
      self.dragging = true
    elseif phase = "ended" or phase = "cancelled" then
      
      self.tracking, self.dragging = false, false
      display.getCurrentStage().setFocus(nil)
    end
  end
  
  return self.tracking
end

return Scroll