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

-- ======
-- CLASS
-- ======
local View = class 'View'

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

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
-- @param opt Intent table for construct new instance.
function View:initialize(opt)
  -- Identifer
  local name = opt.name
  assert(type(name) == "string" or type(name) == "number", "name should be specified.")
  assert(string.find(name, "_", 1) ~= 1, "can't resolve '_' prefixed subview.")
  assert(not string.find(name, "-", 1), "can't resolve '-' contained subview.")
  self.name = name
  
  -- Visual Appearance
  -- implement paramters
  local x, y, width, height = opt.x or 0, opt.y or 0, opt.width or ACW, opt.height or ACH
  local xOffset, yOffset, xOrigin, yOrigin = opt.xOffset or 0, opt.yOffset or 0, - xOffset, - yOffset
  
  -- frame group
  local frame = display.newGroup()
  frame.x, frame.y = x, y
  
  -- The bounds group, which describes the view¡¯s location and size in its own coordinate system.
  local bounds = display.newGroup()
  bounds.x, bounds.y = xOrigin, yOrigin
  
  -- background rect is used for event handling.
  -- background is still used for compute frame's dimension.
  self.background = display.newRect(frame, 0, 0, width, height) -- insert background rect in frame group
  self.backgroundColor = opt.backgroundColor or {255, 255, 255, 0}  -- color table, default is transparent  
  self.background:setFillColor(unpack(self.backgroundColor))
    
  self.frame = frame
  self.bounds = bounds
  -- View Hierarchy
  self.subviews = {}
  self.superview = false -- not exist yet
  self.window = false -- not exist before insert into a window view.
  
  -- Layout
  self.clipToBounds = opt.clipToBounds or false
end

-- ------
-- Configuring a View's Visual Appearance
-- ------

--- Change the background color
-- @param color Table of color. TODO: use Color object.
function View:setBackgroundColor(color)
  assert(type(color) == "table", "invalid color")
  local backgroundColor = color
  self.background:setFillColor(unpack(backgroundColor))
  self.backgroundColor = backgroundColor
end

--- compute frame rect
-- @return Table with frame dimension. {x, y, width, height}
function View:getFrame()
  local contentBounds = self.background.contentBounds
end

-- ------
-- Managing the View Hierarchy
-- ------

--- Add a subview to current view
-- A view may contain zero or more subviews
-- @param view Name of subview to be added.
-- @param* zIndex Relative z-order of this subview. Default nil value will add the subview on the top of the visual list.
-- So the last added subview, with biggest zIndex value, is in most front of the list. The bottom subview is in order of 1.
function View:addSubview(view, zIndex)
  self[view.name] = view
  self.bounds:insert(view.bounds)
end

--- Remove a subview (current view) from its parent
-- @param view Name of the parent view.
function View:removeFromSuperview(view)
end

--- Move view to special index of its superview.
-- @param zIndex The target z-order to move the view to.
function View:moveToIndex(zIndex)
end

--- Check if the view is another view's descendant.
-- @param view The target view to check.
function View:isDescendantOfView(view)
end

return View