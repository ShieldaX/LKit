-----------------------------------------------
-- @class: Label
-- @file Label.lua - v0.0.1 (2013-09)
-- Display a section of static text content.
-- Support line spacing, auto-kerning.
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

local function strimWidth(str, start, width, trimmarker)
  if string.len(str) - (start - 1) <= width then return end
  trimmarker = trimmarker or ""
  if width < trimmarker:len() then return end
  width = width - trimmarker:len() - 1

  print("String before strimWidth:", str)
  local rightstr = str:sub(start, start + width)
  local leftstr = start > 1 and str:sub(1, start - 1) or ""

  local rslt = leftstr .. rightstr .. trimmarker
  print("String after strimWidth:", rslt)
  
  return rslt
end

-- strimWidth("Hello World", 1, 10, "...")

local function stretchBounds(object, width, height)
  object.width = width
  object.height = height
  object.x = width * .5
  object.y = height * .5
end

-- ------
-- Initializing a Label Control
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Label:initialize(api)
  assert(type(api.text) == "string", "ERROR: Text is undefined on label creation")
  -- class custom api:
  --api.backgroundColor = {255, 255, 255, 0} -- hide background rect
  api.backgroundColor = {0, 0, 0, 128} -- hide background rect
  self.textColor = api.textColor or {0, 0, 0, 255} -- [default] dark black
  self.highlightedTextColor = api.hightlightedColor or {255, 255, 255, 255} -- [default] white

  -- text label
  self.font = api.font or native.systemFontBold
  self.alignment = api.alignment or "left"
  self.text = api.text
  self.fontSize = api.fontSize or 16 -- system default 16
  self.numberOfLines = api.numberOfLines or 1
  self.maxLayoutWidth = api.width
  self.maxLayoutHeight = api.height

  -- render text under special context
  local context = {
    --parent = self.bounds,
    width = self.maxLayoutWidth,
    height = self.maxLayoutHeight,
    text = self.text,
    font = self.font,
    fontSize = self.fontSize,
    align = self.align,
  }
  local label = display.newText(context)
  label:setTextColor(unpack(self.textColor))
  self.textObject = label

  -- resize view bounds
  api.width, api.height = label.width, label.height
  label.x = label.width * .5
  label.y = label.height * .5

  View.initialize(self, api)
  local bounds = self.bounds
  bounds:insert(label)

  --self.lineBreakMode = 
  self.shadowColor = api.shadowColor
  self.shadowOffset = api.shadowOffset or {x = 0, y = -1}
  if self.shadowColor then
    --context.parent = bounds
    shadow = display.newText(context)
    shadow:setTextColor(unpack(self.shadowColor))
    bounds:insert(shadow)
    shadow:toBack()
    self.shadow = shadow
    shadow.x = label.x + self.shadowOffset.x
    shadow.y = label.y + self.shadowOffset.y
  end

  self.highlighted = false

  self.userInteractionEnabled = false
end

function Label:setText(text)
  local label = self.textObject
  label.text = text
  local width, height = label.width, label.height
  label.x = label.width * .5
  label.y = label.height * .5
  if self.shadowColor then
    local shadow = self.shadow
    shadow.text = text
    shadow.x = label.x + self.shadowOffset.x
    shadow.y = label.y + self.shadowOffset.y
  end
  stretchBounds(self.background, width, height)
end

function Label:align()
  local textWidth = self.textObject.width
end

function Label:setSize(size)
  self.textObject.size = size
end

function Label:sizeFitsWidth(width)
  local rect = {contentWidth = width}
  if self.textObject then self.textObject:removeSelf() end
  self.textObject = self:drawText(rect) -- assign the new text object.
  self.bounds:insert(self.textObject)
end

function Label:drawText(rect)
  local context = {
    text = self.text,
    width = rect.contentWidth,
    font = self.font or native.systemFontBold,
    fontSize = self.fontSize or 16,
    align = self.align or "left",
  }
  local textObject = display.newText(context)
  textObject:setTextColor(unpack(self.textColor))
  return textObject
end

function Label:setHighlighted(highlighted)
  highlighted = not (highlighted == false)
  if self.highlighted == highlighted then return end
  if highlighted then
    self.textObject:setTextColor(unpack(self.highlightedTextColor))
  else
    self.textObject:setTextColor(unpack(self.textColor))
  end
  self.highlighted = highlighted
end

return Label