-----------------------------------------------
-- @class: View
-- @file View.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local class = require 'middleclass'

-- ======
-- CLASS
-- ======
local View = class 'View'

-- ======
-- CONSTANTS
-- ======

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
  local dimen = opt.bounds
  --assert(type(dimen) == "table" and table.getn(dimen) == 4, "invalid bounds parameter")
  local originX, originY, width, height = dimen[1] or 0, dimen[2] or 0, dimen[3] or 100, dimen[4] or 100
  -- The bounds group, which describes the view¡¯s location and size in its own coordinate system.
  self.bounds = display.newGroup()
  -- background rect is used for event handling.
  -- background is still used for compute frame's dimension.
  self.background = display.newRect(self.bounds, originX, originY, width, height) -- insert background rect in bounds group
  self.backgroundColor = opt.backgroundColor or {255, 255, 255, 0}  -- color table, default is transparent  
  self.background:setFillColor(unpack(self.backgroundColor))
  
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