-----------------------------------------------
-- @class: BarBarButtonItemItem
-- @file BarBarButtonItemItem.lua - v0.0.2 (2013-09)
-----------------------------------------------
-- created at: 2013-11-11 10:50:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local Control = require 'Control'

-- ======
-- CLASS
-- ======
local BarButtonItem = Control:subclass('BarButtonItem')

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
BarButtonItem.static.State = {
  Normal = "normal",
  Highlighted = "highlighted",
  Disabled = "disabled",
  Selected = "selected"
}

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a BarButtonItem Control
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function BarButtonItem:initialize(api)
  -- button type
  self.buttonType = api.buttonType or "default"

  -- class custom api:
  api.backgroundColor = {255, 255, 255, 0} -- hide background rect
  self.tintColor = api.tintColor or {0, 122, 255, 255}
  api.height = api.height or 20
  api.width = api.width or api.height*1.618

  -- instantiation
  --View.initialize(self, api)
  Control.initialize(self, api)
  local bounds = self.bounds
  local background = self.background

  -- rect with border
  local buttonWidth = self.background.contentWidth
  local buttonHeight = self.background.contentHeight

  api.cornerRadius = api.cornerRadius or 0
  api.strokeWidth = api.strokeWidth or 0

  -- switch background rect
  background:removeSelf()
  local rect = display.newRoundedRect(bounds, 0, 0, buttonWidth, buttonHeight, api.cornerRadius)
  rect.strokeWidth = api.strokeWidth
  --rect:setStrokeColor(unpack(self.tintColor))
  self.background = rect

  -- image
  local imageLabel = api.image

  bounds:insert(imageLabel)
  imageLabel.x = imageLabel.width*.5
  imageLabel.y = imageLabel.height*.5
  -- text label
  self.titleLabel = imageLabel

  -- button state
  self.states = {
    normal = {
      title = api.title or "BarButtonItem",
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
 
end

function BarButtonItem:setState(state)
  if (not state) or state == self.status then return end
  if state ~= "disabled" and not self.enabled then return end
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
  --titleLabel.text = self.currentTitle
  titleLabel:setFillColor(unpack(self.currentTitleColor))
  -- set rect stroke
  self.background:setStrokeColor(unpack(self.currentBorderColor))
  -- set backgroundColor
  self:setBackgroundColor(self.currentTitleShadowColor)
  self.status = state
end

-- ------
-- Tracking Touches and Redrawing Controls
-- ------

function BarButtonItem:willSendEvent(event)
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

return BarButtonItem