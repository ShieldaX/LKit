-----------------------------------------------
-- @class: Input
-- @file Input.lua - v0.0.1 (2013-09)
-- wrapper of native input field
-----------------------------------------------

-- ======
-- LIBRARIES
-- ======
--local util = require 'util'
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
  --api.backgroundColor = {255, 255, 255, 0} -- hide background rect
  api.backgroundColor = {0, 0, 0, 0} -- hide background rect
  -- instantiation
  View.initialize(self, api)

  self.tintColor = api.tintColor or {0, 0, 0, 255}
  self.size = api.size or 30
  self.font = api.font or native.systemFontBold
  self.defaultText = api.defaultText

  -- layout real text field
  local frame = self.frame
  local left = frame.contentBounds.xMin
  local top = frame.contentBounds.yMin
  local width = frame.contentWidth
  local height = frame.contentHeight
  local field = native.newTextField( left, top, width, height )
  --field.inputType = api.inputType
  --field.isSecure = api.isSecure

  self.field = field
  field:addEeventListener("userInput", self)
end

function Input:userInput(event)
  print("user input just happen")
end

function Input:animation(animation)
  -- set frame to target position
  -- then transition native field to act real animation
end

-- Roll input text back to default or none
function Input:rollBack(clear)
  self.field.text = clear and  '' or self.defaultText
end

function Input:setText(text)
  assert(type(text) == "string")
  self.field.text = text
end

return Input