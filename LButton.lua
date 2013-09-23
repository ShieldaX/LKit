-- LButton.lua
-- Button maintainer
--

-- ------
-- LIBRARIES
-- ------

local LUtil = require("LUtil")
local LView = require("LView")
local LEnum = require("LEnum")

-- ------
-- CLASS
-- ------

local LButton = LView:subclass("LButton")

-- ------
-- CONSTANTS
-- ------

LButton.controlEvent = LEnum {
    "touchDown",
    "touchDownRepeat",
    "touchDragInside",
    "touchDragOutside",
    "touchDragEnter",
    "touchDragExit",
    "touchUpInside",
    "touchUpOutside",
    "touchCancel",
    "allTouchEvents"
  }

-- ------
-- VARIABLES
-- ------

local isPointInBounds = LUtil.isPointInBounds

-- ------
-- FUNCTIONS
-- ------

-- ------
-- CLASS METHOD
-- ------

function LButton:initialize(opt)
  LView.initialize(self, opt)
  
  local roundedRect = display.newRoundedRect(self.bounds, 0, 0, 160, 60, 12)
  roundedRect.strokeWidth = 2
  roundedRect:setFillColor(255, 255, 255)
  roundedRect:setStrokeColor(0, 122, 255)
  
  local label = display.newText(self.bounds, "Label", 0, 0, native.systemFont, 30)
  label:setTextColor(0, 122, 255)
  label.x = roundedRect.x
  label.y = roundedRect.y
  
  self.targets = {}
  -- begin to tracking touch
  print("           opt", opt.trackingTouch)
  if type(opt.trackingTouch) ~= "nil" then
    self.trackingTouch = opt.trackingTouch
  else
    self.trackingTouch = true
  end
  print("           self", self.trackingTouch)
  self.bounds:addEventListener("touch", self)
end

--- the original touch handler
-- parse touch to control events
-- @param event System touch event
function LButton:touch(event)

  if not self.trackingTouch then return end

  local phase = event.phase
  local target = event.target
  local touchedInBounds = isPointInBounds({x = event.x, y = event.y}, target.contentBounds)
  local ctrl = self.controlEvent
  
  self:onControlEvent(ctrl.allTouchEvents)
  
  if phase == "began" then -- touch down
  
    display.getCurrentStage():setFocus( target ) -- retain touch
    target.isFocus = true
    target.isExit = false
    self:onControlEvent(ctrl.touchDown)    
  
  elseif target.isFocus then
  
    if phase == "moved" then -- touch drag
    
      if touchedInBounds then
        self:onControlEvent(ctrl.touchDragInside)
        if target.isExit then
          self:onControlEvent(ctrl.touchDragEnter)
          target.isExit = false -- flag
        end 
      else
        self:onControlEvent(ctrl.touchDragOutside)
        if not target.isExit then
          self:onControlEvent(ctrl.touchDragExit)
          target.isExit = true -- flag back
        end
      end

    elseif phase == "ended" or phase == "cancelled" then -- touch up or cancel

      if phase == "cancelled" then
        self:onControlEvent(ctrl.touchCancel)
      else
        self:onControlEvent(touchedInBounds and ctrl.touchUpInside or ctrl.touchUpOutside)
      end
      
      display.getCurrentStage():setFocus( nil )
      target.isFocus = false
      
    end
    
  end
  
  return self.trackingTouch -- event handled?

end

--- the original tap handler
-- response to tap control event.
-- @param event System tap event
function LButton:tap(event)
  if event.numTaps > 1 then
    self:onControlEvent(self.controlEvent.touchDownRepeat)
  end
end

--- send event to its targets
-- @param eventName String specifying the name of the event to dispatch.
function LButton:onControlEvent(eventName)
  print(eventName)
  if not self.trackingTouch then return false end
  local targets = self.targets[eventName]
  if not targets then return false end
  table.foreach(targets, function(i, tar)
    tar[1].bounds:dispatchEvent({
      name = tar[2], -- the action name
      state = eventName, -- control event
      --source = event, -- original event
      sender = self -- you may query sender to get more information about the context of the event triggering the action message
    })
  end)
  return true -- touch event handled.
end

-- ------
-- INSTANCE METHOD
-- ------

function LButton:setLabel(text)
end

return LButton