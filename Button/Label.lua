-----------------------------------------------
-- @class: Label
-- @file Label.lua - v0.0.1 (2013-09)
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
local Label = View:subclass('Label')

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
-- Initializing a Label Control
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Label:initialize(opt)
  -- class custom opt:
  --opt.backgroundColor = {255, 255, 255, 0} -- hide background rect
  opt.backgroundColor = {0, 0, 0, 120} -- hide background rect
  self.tintColor = opt.tintColor or {0, 0, 0, 255}

  -- instantiation
  View.initialize(self, opt)

  -- rect with border
  local insetTop, insetRight, insetBottom, insetLeft = opt.insetTop or 0, opt.insetRight or 0, opt.insetBottom or 0, opt.insetLeft or 0
  local width = self.background.contentWidth - (insetLeft + insetRight)
  local height = self.background.contentHeight - (insetTop + insetBottom)

  -- text label
  local labelText = opt.text or opt.name
  local label = display.newText {
    parent = self.bounds,
    x = width*.5, y = height*.5,
    width = width, height = height,
    text = labelText,
    font = opt.font or native.systemFontBold,
    fontSize = opt.fontSize or 30,
    align = "center"
  }
  label:setTextColor(unpack(self.tintColor))
  self.contentView = label
end

function Label:setText(text)
  local label = self.contentView
  if label then
    label.text = text
  else
    print(" no label yet ")
  end
end

return Label