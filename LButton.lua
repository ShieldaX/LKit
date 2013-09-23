-- LButton.lua
-- Button maintainer
--

-- ------
-- LIBRARIES
-- ------

local LView = require("LView")
local enum = require 'enum'

-- ------
-- CLASS
-- ------

local LButton = LView:subclass("LButton")

-- ------
-- CONSTANTS
-- ------

LButton.controlEvent = enum.def {
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

-- ------
-- FUNCTIONS
-- ------

-- ------
-- ONTOLOGY FUNCTIONS
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
  self.bounds:addEventListener("touch", self)
end

function LButton:touch(event)

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
  
  return self.trackingTouch -- event handled

end

function LButton:setLabel()
end

return LButton