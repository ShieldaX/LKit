-----------------------------------------------
-- @class: View
-- @file View.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local Application = require 'Application'

-- ======
-- CLASS
-- ======
local Window = View:subclass('Window')

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local CCX = display.contentCenterX
local CCY = display.contentCenterY
local SOX = display.screenOriginX
local SOY = display.screenOriginY

-- ======
-- VARIABLES
-- ======

-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Object
-- ------

--- Instance constructor
-- @param api Table with customization params.
function Window:initialize(api)
  -- dimensions and coordinate
  -- window should occupy full screen
  -- TODO: screen should be another class
  local screenWidth, screenHeight = ACW, ACH
  local screenTop, screenLeft = SOY, SOX

  -- define window properties
  local opt = {name = api.name or "mainWindow"}
  opt.x, opt.y = screenLeft, screenTop -- left & top
  opt.xOffset, opt.yOffset = 0, 0 -- global offset, currently both set to 0
  opt.width, opt.height = screenWidth, screenHeight -- full screen size
  opt.backgroundColor = api.backgroundColor or {255, 255, 255, 255}
  
  View.initialize(self, opt)
  self.frame.isVisible = false -- new window is invisible

  -- View Hierarchy
  --self.subviews = {}
  self.superview = nil -- root view
  self.window = self

  -- root controller
  self.rootController = api.rootController
end

function Window:makeKeyAndVisible()
  self.frame.isVisible = true
  Application.sharedApplication().mainWindow = self
end

-- ------
-- Managing the View Hierarchy
-- ------

--- Remove a subview (current view) from its parent
-- @param view Name of the parent view.
function Window:removeFromSuperview(view)
end

--- Move view to special index of its superview.
-- @param zIndex The target z-order to move the view to. This parameter is adopt from native group object.
function Window:moveToIndex(zIndex)
end

--- Check if the view is another view's descendant.
-- @param view The target view to check.
-- @return true if view is in parent chain, false if view is not found.
function Window:isDescendantOfView(view)
  return false
end

return Window