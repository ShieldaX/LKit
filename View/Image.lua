-----------------------------------------------
-- @class: Image
-- @file Image.lua - v0.0.1 (2013-11)
-- A view-based container for displaying either a single image or for animating a series of images.
-----------------------------------------------
-- created at: 2013-11-22 11:42:38

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Image = View:subclass 'Image'

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

local function rectEqualsRect()
  -- body
end

-- ------
-- Initializing a Image Object
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Image:initialize(api)
  View.initialize(self, api)
  local bounds = self.bounds
  
  self.image = api.image

  local _img = display.newImageRect(bounds, pathToImage, api.width, api.height)
  --sizeToFit(self.background.contentWidth)
  
end

function Image:setImage(image)
  if self.image then
    image:removeSelf()
  end
  local bounds = self.bounds
  self.image = display.newImageRect( bounds, filename, [baseDirectory], width, height )
end

-- adjust frame while content updating
-- update background size
local function adjustFrame()
  local background = self.background
  local frame = self.frame
  local width, height = frame.width, frame.height
  print(frame.width, frame.height, frame.contentWidth, frame.contentHeight)
  -- content size is always lte actual size
  background.width = width
  background.height = height
  background.x = width*.5
  background.y = height*.5
end

function Image:sizeThatFits()
  local bounds = self.bounds
  return bounds.contentWidth, bounds.contentHeight
end

function Image:sizeToFit()
  local width, height = self:sizeThatFits()
  local background = self.background
end

return Image