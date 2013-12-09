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
Scroll:include(scroller)

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

-- default class variable
Scroll.static.decelerationRateNormal = 0.94
Scroll.static.decelerationRateFast = 0.972
Scroll.static.scrollStopThreshold = 250

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Scroll Object
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Scroll:initialize(api)
  View.initialize(self, api)

  self.canCancelContentTouches = not (api.canCancelContentTouches == false) -- Default true
  self.delaysContentTouches = not (api.delaysContentTouches == false) -- Delays handling the touch-began until it can determine if scrolling is the intent.
  self.directionLockEnabled = not (api.directionLockEnabled == false)
  self.bounces = not (api.bounces == false)
  self.alwaysBounceVertical = api.alwaysBounceVertical == true -- Default false
  self.alwaysBounceHorizontal = api.alwaysBounceHorizontal == true -- Default false

  self.decelerationRate = api.decelerationRate or Scroll.decelerationRateNormal
  self.scrollStopThreshold = api.scrollStopThreshold or Scroll.scrollStopThreshold

  self.tracking = false -- touched but might not have yet have started dragging
  self.dragging = false -- scrolling is the intent
  self.decelerating = false -- scrolling is still occurring after dragging

  self.frame:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

function Scroll:touch(event)
  local contentView = self.bounds
  local phase = event.phase
  local time = event.time
  local target = event.target
  
  if "began" == phase then
    -- Reset values
    self._prevYPos = event.y
    self._prevY = 0
    self._delta = 0
    self.velocity = 0
    self._prevTime = 0
    self.dragging = false -- not dragging yet
    self.decelerating = false -- not lift
    self.tracking = true
    
    -- Set the limits now
    self:updateLimitation()
    
    -- Cancel any active scrollTween on the content view
    if self.scrollTween then
      transition.cancel( self.scrollTween )
      self.scrollTween = nil
    end
    
    --self:willBeginDragging()
    if type(self.willBeginDragging) == "function" then self:willBeginDragging() end
    
    -- Set focus
    --display.getCurrentStage():setFocus( event.target, event.id )
    --target.isFocus = true

  elseif self.tracking then
    if "moved" == phase then      
      self._delta = event.y - self._prevYPos
      self._prevYPos = event.y
      if Abs(self._delta) > 1 then
        self.dragging = true -- flag scrolling is the intent
        if self.canCancelContentTouches then
          -- cancel content touches
          -- self:touchesShouldCancelInContentView(viewTouched)
          --table.foreach(self:getTouchedViews(event), function(i, view)
            -- body
          --end)
        else
        end
      end
      -- If the view is more than the limits, handle overscroll
      if contentView.y < self.upperLimit or contentView.y > self.bottomLimit then
        contentView.y = contentView.y + ( self._delta * 0.5 )
      else
        contentView.y = contentView.y + self._delta
      end
      
      self:limitationReached( false )
      
      -- update the last held time
      self._timeHeld = time
      
    elseif "ended" == phase or "cancelled" == phase then
      self._lastTime = event.time
      self.dragging = false
      self.tracking = false
      self.decelerating = true
      
      -- touch held
      if event.time - self._timeHeld > self.class.scrollStopThreshold then
        self.velocity = 0
      end
      self._timeHeld = 0
      
      if self._delta > 0 and self.velocity < 0 then
        self.velocity = -self.velocity
      end
      if self._delta < 0 and self.velocity > 0 then
        self.velocity = -self.velocity
      end
      
      display.getCurrentStage():setFocus( event.target, nil )
      --target.isFocus = false
    end
  end
  
  return true
end

-- @param event Touch event
-- @param view Subview that the touches occur in.
function Scroll:touchesShouldBegin(event, view)
  -- body
end

function Scroll:touchesShouldCancelInContentView(view)
  local notAControl = not view:isInstanceOf(require("Control"))
  return notAControl
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
  self._decelerating = false
  self._dragging = false
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

function Scroll:finalize()
  -- remove event listeners if any.
  Runtime:removeEventListener("enterFrame", self)
  self.frame:removeEventListener("touch", self)
  View.finalize(self)
end

return Scroll