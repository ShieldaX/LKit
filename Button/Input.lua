-----------------------------------------------
-- @class: Input
-- @file Input.lua - v0.0.1 (2013-09)
-- wrapper of native input field
-- (Implement Reference)[http://www.coronalabs.com/blog/2013/12/03/tutorial-customizing-text-input]
-----------------------------------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Input = View:subclass('Input')

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

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Input Control
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Input:initialize(api)
  -- class custom api:
  api.backgroundColor = {255, 255, 255, 0} -- hide background rect
  --api.backgroundColor = {0, 0, 0, 255} -- hide background rect
  -- instantiation
  View.initialize(self, api)

  --self.tintColor = api.tintColor or {0, 0, 0, 255}
  --self.size = api.size or 30
  --self.font = api.font or native.systemFontBold
  self.defaultText = api.defaultText
  self.defaultColor = api.defaultColor or {0, 0, 0, 255}

  -- layout real text field
  local frame = self.frame
  local left = frame.contentBounds.xMin
  local top = frame.contentBounds.yMin
  local width = frame.contentWidth
  local height = frame.contentHeight
  local field = native.newTextField( left, top, width, height )
  field.text = self.defaultText
  field:setTextColor(unpack(self.defaultColor))
  field.isSecure = api.isSecure
  field.size = api.fontSize or height*.67

  self.field = field
  field:addEventListener("userInput", self)
end

function Input:transitionTo(api)
  -- set frame to target position
  local frame = self.frame

  util.print_r(self.field.contentBounds)
  util.print_r(self.frame.contentBounds)

  if api.delta == true then
    --frame:translate(api.x, api.y)
  else
    frame.x = api.x or frame.x
    frame.y = api.y or frame.y
  end
  --local bounds = frame.contentBounds
  local left = frame.contentBounds.xMin
  local top = frame.contentBounds.yMin
  local width = frame.contentWidth
  local height = frame.contentHeight
  local x, y = self.background:localToContent(0, 0)
  -- then transition native field to act real animation
  --self.field.x = x
  --self.field.y = y
  self.tween = transition.to(self.field, {x = x, y = y, transition = api.transition})
end

-- ---
-- Handle User Input
-- ---
-- Roll input text back to default or none
function Input:rollBack(clear)
  self.field.text = clear == true and  '' or self.defaultText
end

function Input:userInput(event)
  print("user inputting just happened")
end

function Input:setText(text)
  assert(type(text) == "string")
  self.field.text = text
end

return Input