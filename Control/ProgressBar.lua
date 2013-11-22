-----------------------------------------------
-- @class: ProgressBar
-- @file ProgressBar.lua - v0.0.1 (2013-11)
-- Provide class for displaying special progress visually, like downloading, saving, refreshing, etc.
-----------------------------------------------
-- created at: 2013-11-22 16:12:18

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local ProgressBar = View:subclass('ProgressBar')

-- ======
-- CONSTANTS
-- ======

-- ======
-- VARIABLES
-- ======

ProgressBar.Style = {
  Light = 1,
  Dark = 2,
}

-- ======
-- FUNCTIONS
-- ======

local function applyStyle(styleName)
  return baseColor, barColor, strokeWidth, strokeColor
end

-- ------
-- Initializing a ProgressBar Object
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function ProgressBar:initialize(api)
  api.height = 10
  api.width = api.width or 100
  View.initialize(self, api)

  -- markers
  self.progress = 0 -- number with percentage, from 0 to 100.

  -- paint graphics
  local bounds = self.bounds
  local height = api.height

  local baseBar = display.newRoundedRect( bounds, 0, 0, api.width, height, height*.5 )
  baseBar:setFillColor(142, 142, 147)
  baseBar.strokeWidth = 2,
  baseBar:setStrokeColor(142, 142, 147)
  self.baseBar = baseBar

  local bar = display.newRoundedRect( bounds, 0, 0, height, height, height*.5 )
  bar:setFillColor(76, 217, 100, 204)
  self.bar = bar
end

function ProgressBar:update(progress)
  self:willUpdateProgress(progress)
  if self.tween then transition.cancel(self.tween) end

  -- limit progress percentage between zero to one
  if progress < 0 then
    progress = 0
  end
  if progress > 1 then
    progress = 1
  end

  local width = progress * self.background.contentWidth

  if width < self.background.contentHeight then
    width = self.background.contentHeight
  end

  local bar = self.bar
  --bar.width = width
  --bar.x = bar.width * .5

  self.tween = transition.to( bar, {time = 400, width = width, x = width * .5} )

  self:didUpdateProgress()
end

function ProgressBar:willUpdateProgress()
end

function ProgressBar:didUpdateProgress()
end

return ProgressBar