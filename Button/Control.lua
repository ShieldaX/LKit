-----------------------------------------------
-- @class: Control
-- @file Control.lua - v0.0.1 (2013-09)
-- Abstract class for control classes, Control, Slider, etc.
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
--[[
local function _touchInside(bounds, point)
  return point.x => bounds.xMin and point.x <= bounds.xMax and point.y => bounds.yMin and point.y <= bounds.yMax
end
]]
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
  self.touchBounds = self.frame
  self.enabled = false
  self.highlighted = false
  self.selected = false
  self.status = Control.State.Normal
  self.tracking = false
  self:setEnabled(true)
end

function Control:setEnabled(enable)
  assert(type(enable) == "boolean", "ERROR: Invalid type of enable, should be boolean.")
  if self.enabled == enable then return end
  if enable == true then
    self.touchBounds:addEventListener("touch", self)
  elseif enable == false then
    self.touchBounds:removeEventListener("touch", self)
  end
  self.enabled = enable
end

-- @subclass
-- @return boolean
function Control:beginTracking(event)
  return true
end

-- @subclass
-- @return boolean
function Control:continueTracking(event)
  return true
end

-- @return boolean True if the point user touched is inside the special bounds, fasle for not inside.
local function isTouchInside(bounds, point)
  return (point.x >= bounds.xMin) and (point.x <= bounds.xMax) and (point.y >= bounds.yMin) and (point.y <= bounds.yMax)
end

function Control:touch(event)
  if self.enabled then
    local target = event.target
    local phase = event.phase
    local touchInside = isTouchInside(self.touchBounds.contentBounds, event)

    if phase == "began" then
      display.getCurrentStage():setFocus(target, event.id)
      self.tracking = self:beginTracking(event)
      self.touchInside = true
      self.highlighted = true
      
      self:sendEvent("touchDown")
    elseif self.tracking then

      if phase == "moved" then
        if touchInside then
          self.highlighted = true
          self.tracking = self:continueTracking(event)
          if not self.touchInside then
            self:sendEvent("touchDragEnter")
            self.touchInside = true
          end
          self:sendEvent("touchDragInside")
        else
          self.highlighted = false
          if self.touchInside then
            self:sendEvent("touchDragExit")
            self.touchInside = false
          end
          self:sendEvent("touchDragOutside")
        end        
      else -- "ended" or "cancelled"
        if touchInside then
          self:sendEvent("touchUpInside")
        else
          self:sendEvent("touchUpOutside")
        end
        self.highlighted = false -- user lift finger
        self.tracking = false
        display.getCurrentStage():setFocus(target, nil)
        return true
      end

    end

    return self.tracking
  else
    return false
  end
end

-- ------
-- Preparing and Sending Action Messages
-- ------

function Control:sendEvent(event)
  if type(event) == "string" then
    --print(event)
    event = {name = event}
  end
  assert(event and type(event.name) == "string", "ERROR: Try to send invalid event.")
  self:willSendEvent(event.name)
  event.sender = self.name
  self.touchBounds:dispatchEvent(event)
end

function Control:willSendEvent(event)
  if event == "touchDown" then
    self:setState("highlighted")
  elseif event == "touchDragExit" then
    self:setState("normal")
  elseif event == "touchDragEnter" then
    self:setState("highlighted")
  elseif event == "touchUpInside" then
    self:setState("normal")
  end
end

function Control:addTarget(obj, action)
  self.touchBounds:addEventListener(action, obj)
  print("responses to", action)
end

function Control:removeTarget(obj, action)
  self.frame:removeEventListener(action, obj)
end

function Control:finalize()
  self:setEnabled(false)
  View.finalize(self)
end

return Control