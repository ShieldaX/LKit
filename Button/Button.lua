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
  Highlighted = 2,
  Disabled = 3,
  Selected = 4
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
  --self.tintColor = opt.tintColor or {0, 122, 255, 255}
  --self.buttonTintColor = opt.buttonTintColor or {255, 255, 255, 255}
  self.tintColor = opt.tintColor or {255, 255, 255, 255}
  self.buttonTintColor = opt.buttonTintColor or {0, 122, 255, 255}

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
  self.enabled = true
  if opt.enabled == false then self.enabled = false end
  self.touchBounds = self.rectNormal.contentBounds

  self.highlighted = false -- button sets and clears this state automatically when a touch enters and exits during tracking and when there is a touch up.
  self.tracking = false -- is tracking a touch event
  self.touchInside = false -- is there a touch event happen in touchBounds

  if self.enabled then
    self.frame:addEventListener("touch", self)
  else
    self:setStateDisabled()
  end
  
end

function Button:setLabelForState(state)
  local status = Button.State
  state = state or status.Normal
  if state == status.Normal then
    print("set label for state normal")
  elseif state == status.Highlighted then
  elseif state == status.Disabled then
  elseif state == status.Selected then
  end
end

function Button:setStatePressed() -- setHighlighted(highlighted)
  local highlightedColor = self.tintColor
  self.rectNormal:setFillColor(unpack(highlightedColor))
  self.textLabel:setTextColor(unpack(self.buttonTintColor))
  self.status = Button.State.Highlighted
end

function Button:setStateNormal()
  local normalColor = self.buttonTintColor
  self.rectNormal:setFillColor(unpack(normalColor))
  self.textLabel:setTextColor(unpack(self.tintColor))
  if self.status == Button.State.Disabled then self.rectNormal:setStrokeColor(unpack(normalColor)) end
  self.status = Button.State.Normal
end

function Button:setStateDisabled()
  local disabledColor = {142, 142, 147, 255}
  self.rectNormal:setFillColor(unpack(disabledColor))
  self.textLabel:setTextColor(unpack(self.tintColor))
  self.rectNormal:setStrokeColor(unpack(disabledColor))
  self.status = Button.State.Disabled
end

function Button:touch(event)
  if self.status ~= Button.State.Disabled then
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
end

function Button:addTarget(obj, action)
  self.frame:addEventListener(action, obj)
  print("responses to", action)
end

function Button:removeTarget(obj, action)
  self.frame:removeEventListener(action, obj)
end

return Button