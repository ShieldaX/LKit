-----------------------------------------------
-- @class: Button
-- @file Button.lua - v0.0.1 (2013-09)
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

Button.static.State = {
  Normal = 1,
  Focused = 2,
  Pressed = 3,
  Release = 4
}

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Button Control
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Button:initialize(opt)
  -- class custom opt:
  opt.backgroundColor = {255, 255, 255, 0} -- hide background rect
  self.tintColor = opt.tintColor or {0, 122, 255, 255}
  self.buttonTintColor = opt.buttonTintColor or {255, 255, 255, 255}

  -- instantiation
  View.initialize(self, opt)

  -- rect with border
  local insetTop, insetRight, insetBottom, insetLeft = opt.insetTop or 0, opt.insetRight or 0, opt.insetBottom or 0, opt.insetLeft or 0
  local buttonWidth = self.background.contentWidth - (insetLeft + insetRight)
  local buttonHeight = self.background.contentHeight - (insetTop + insetBottom)
  local rectNormal = display.newRoundedRect(self.bounds, 0, 0, buttonWidth, buttonHeight, 6)
  rectNormal.strokeWidth = 2
  rectNormal:setStrokeColor(unpack(self.tintColor))
  self.rectNormal = rectNormal

  -- text label
  local labelText = opt.labelText or opt.name
  local label = display.newText {
    parent = self.bounds,
    x = rectNormal.contentWidth*.5, y = rectNormal.contentHeight*.5,
    text = labelText,
    font = native.systemFontBold,
    fontSize = 20,
    align = "center"
  }
  self.textLabel = label

  -- or --

  -- image label
  -- TODO

  -- button state
  self.status = Button.State.Normal
  self:setStateNormal()

  -- response to touch
  self.enabled = opt.enabled or true
  self.touchBounds = self.rectNormal.contentBounds

  if self.enabled then
    self.frame:addEventListener("touch", self)
  end
  
end

function Button:setStatePressed()
  local highlightedColor = self.tintColor
  self.rectNormal:setFillColor(unpack(highlightedColor))
  self.textLabel:setTextColor(unpack(self.buttonTintColor))
end

function Button:setStateNormal()
  local normalColor = self.buttonTintColor
  self.rectNormal:setFillColor(unpack(normalColor))
  self.textLabel:setTextColor(unpack(self.tintColor))
end

function Button:touch(event)
  print("Event Name:", event.name)
  local phase = event.phase
  if phase == "began" then
    self:setStatePressed()
  elseif phase == "ended" then
    local action = {
      name = "release",
      target = self,
      time = os.time()
    }
    self.frame:dispatchEvent(action)
    self:setStateNormal()
  end
end

function Button:addTarget(obj, action)
  self.frame:addEventListener(action, obj)
  print("responses to", action)
end

return Button