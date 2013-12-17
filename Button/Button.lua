-----------------------------------------------
-- @class: Button
-- @file Button.lua - v0.0.2 (2013-09)
-- Most used control widget class, stateful
-----------------------------------------------
-- created at: 2013-11-11 10:50:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Button = View:subclass('Button')

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

-- Control state
Button.static.State = {
  Normal = "normal",
  Highlighted = "highlighted",
  Disabled = "disabled",
  Selected = "selected"
}

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Button Control
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Button:initialize(api)
  -- button type
  self.buttonType = api.buttonType or "default"

  -- class custom api:
  api.backgroundColor = {255, 255, 255, 0} -- hide background rect
  self.tintColor = api.tintColor or {0, 122, 255, 255}
  api.height = api.height or 20
  api.width = api.width or api.height*1.618

  -- instantiation
  View.initialize(self, api)
  local bounds = self.bounds
  local background = self.background

  -- rect with border
  local buttonWidth = self.background.contentWidth
  local buttonHeight = self.background.contentHeight

  api.cornerRadius = api.cornerRadius or buttonHeight*.2
  api.strokeWidth = api.strokeWidth or 2

  -- switch background rect
  background:removeSelf()
  local rect = display.newRoundedRect(bounds, 0, 0, buttonWidth, buttonHeight, api.cornerRadius)
  rect.strokeWidth = api.strokeWidth
  --rect:setStrokeColor(unpack(self.tintColor))
  self.background = rect

  -- text label
  local labelText = api.labelText or api.name
  local label = display.newText {
    parent = bounds,
    x = rect.contentWidth*.5, y = rect.contentHeight*.5,
    text = labelText,
    font = native.systemFontBold,
    fontSize = 20,
    align = "center"
  }
  self.titleLabel = label

  -- button state
  self.states = {
    normal = {
      title = api.title or "Button",
      titleColor = self.tintColor,
      titleShadowColor = api.shadowColor or {0, 122, 255, 0}, -- fill the background
      image = api.image,
      strokeColor = self.tintColor,
    },
    highlighted = {
      titleColor = self.tintColor,
    },
    disabled = {
      titleColor = {142, 142, 147},
      strokeColor = {142, 142, 147},
      titleShadowColor = {142, 142, 147, 128},
    },
  }

  -- response to touch
  self.enabled = not (api.enabled == false)

  if self.enabled then
    self:setState(Button.State.Normal)
    self.frame:addEventListener("touch", self)
  else
    self:setState(Button.State.Disabled)
  end

  self.touchBounds = self.background.contentBounds
  self.highlighted = false -- button sets and clears this state automatically when a touch enters and exits during tracking and when there is a touch up.
  self.tracking = false -- is tracking a touch event
  self.touchInside = false -- is there a touch event happen in touchBounds  
end

function Button:setState(state)
  if (not state) or state == self.status then return end
  local status = self.states[state]
  local default = self.states.normal
  -- map state config
  self.currentTitle = status.title or default.title
  self.currentTitleColor = status.titleColor or default.titleColor
  self.currentTitleShadowColor = status.titleShadowColor or default.titleShadowColor
  self.currentBorderColor = status.strokeColor or default.strokeColor

  -- apply config
  -- set title
  local titleLabel = self.titleLabel
  titleLabel.text = self.currentTitle
  titleLabel:setTextColor(unpack(self.currentTitleColor))
  -- set rect stroke
  self.background:setStrokeColor(unpack(self.currentBorderColor))
  -- set backgroundColor
  self:setBackgroundColor(self.currentTitleShadowColor)
  self.status = state
end

local function touchInside(bounds, point)
  return (point.x >= bounds.xMin) and (point.x <= bounds.xMax) and (point.y >= bounds.yMin) and (point.y <= bounds.yMax)
end

-- ------
-- Tracking Touches and Redrawing Controls
-- ------

function Button:touch(event)
  if self.status ~= Button.State.Disabled then
    self.touchInside = touchInside(self.touchBounds, event)
    local target = event.target
    local phase = event.phase
    if phase == "began" then
      self:setState(Button.State.Highlighted)

      display.getCurrentStage():setFocus(target, event.id)
      self.tracking = true
    elseif self.tracking then
      if phase == "moved" then

      elseif phase == "ended" or phase == "cancelled" then
        display.getCurrentStage():setFocus(target, nil)
      end
    elseif phase == "ended" or phase == "cancelled" then
      self:setState(Button.State.Normal)
      self.tracking = false
    end
  end
end

function Button:shouldBeginTracking(event)
end

-- ...

-- ------
-- Preparing and Sending Action Messages
-- ------

function Button:sendAction(action)
  assert(action and type(action.name) == "string", "ERROR: Try to send invalid action.")
  action.sender = self.name
  self.frame:dispatchEvent(action)
end

function Button:addTarget(obj, action)
  self.frame:addEventListener(action, obj)
  print("responses to", action)
end

function Button:removeTarget(obj, action)
  self.frame:removeEventListener(action, obj)
end

return Button