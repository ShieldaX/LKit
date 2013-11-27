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
local CW = display.contentHeight
local CH = display.contentHeight
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
  local x, y, width, height = opt.x or 0, opt.y or 0, opt.width or ACW, opt.height or CH
  local xOffset, yOffset = opt.xOffset or 0, opt.yOffset or 0
  
  -- frame group
  local frame = display.newGroup()
  frame.x, frame.y = x, y
  
  -- background rect is used for event handling.
  -- background is still used for compute frame's dimension.
  self.background = display.newRect(frame, 0, 0, width, height) -- insert background rect in frame group
  self.backgroundColor = opt.backgroundColor or {255, 255, 255, 0}  -- color table, default is transparent  
  self.background:setFillColor(unpack(self.backgroundColor))
  
  -- The bounds group, which describes the view¡¯s location and size in its own coordinate system.
  local bounds = display.newGroup()
  frame:insert(bounds)
  bounds.x, bounds.y = xOffset, yOffset
  self.frame = frame
  self.bounds = bounds
  
  -- View Hierarchy
  --self.subviews = {}
  self.superview = nil -- not exist yet
  self.window = nil -- not exist before insert into a window view.
  
  -- Layout
  self.clipToBounds = opt.clipToBounds or false

  self.exclusiveTouch = false -- touch focus on self
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

function View:getContentSize()
  local content = self.background
  return content.contentWidth, content.contentHeight
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
  assert(view.name and view.bounds)

  view:willMoveToSuperview(self)
  
  local bounds = self.bounds
  zIndex = zIndex or bounds.numChildren + 1
  bounds:insert(zIndex, view.frame)
  view.superview = self
  self[view.name] = view -- view reference
  --table.insert(self.subviews, view) -- add subview
  view.window = self.window --view:getWindow()

  self:didAddSubview(view)
  view:didMoveToSuperview()
end

--- Remove a subview (current view) from its parent
-- @param view Name of the parent view.
function View:removeFromSuperview(view)
  local frame = self.frame
  local superview = self.superview
  if superview then
    superview[self.name] = nil
    superview:willRemoveSubview(self)
    self.superview = nil
  end
  self.window = nil
  frame:removeSelf()
end

function View:didAddSubview(view)
end

function View:didMoveToSuperview()
end

function View:willMoveToSuperview(view)
end

function View:willRemoveSubview(view)
end

--- Move view to special index of its superview.
-- @param zIndex The target z-order to move the view to. This parameter is adopt from native group object.
function View:moveToIndex(zIndex)
  zIndex = tonumber(zIndex)
  assert(zIndex > 0, "invalid z-order param")
  stage = display.getCurrentStage()
  stage:insert(self.frame)
  self.superview.bounds:insert(zIndex, self.frame)
end

--- Check if the view is another view's descendant.
-- @param view The target view to check.
-- @return true if view is in parent chain, false if view is not found.
function View:isDescendantOfView(view)
  local super = self.superview
  local depth = 0
  while super do
    if super == view then
      super = nil
      return true, depth + 1
    else
      super = super.superview
      depth = depth + 1
    end
  end
  return false
end

function View:getWindow()
  if self.window == self then return self end
  local super = self.superview
  while super do
    if super.window == super then
      return super
    else
      super = super.superview
    end
  end
end

function View:layoutSubviews()
  local bounds = self.bounds
  local _width, _height = self:getContentSize()
  local subviews = self.subviews
  table.foreach(subviews, function(i, v)
    local w, h = v:getContentSize()
    local inset, outset = v.inset, v.ou
  end)
end

return View

--[[
local LayoutParams = {}

function LayoutParams.insetsMake(top, right, bottom, left)
  local kv = {
    top = top or 0,
    right = right or 0,
    bottom = bottom or 0,
    left = left or 0
  }

  return kv
end

-- @param force Whether force the content size be same as origin size. [boolean]
local function insetRect(rect, insets, force)
  assert(rect and insets)
  if rect.contentWidth ~= rect.width or rect.contentHeight ~= rect.height then print("WARNING: content size(screen) is different from origin size") end
  rect.width = rect.width - (insets.left + insets.right)
  rect.height = rect.height - (insets.top + insets.bottom)
  rect.x = rect.width*.5 + insets.left
  rect.y = rect.height*.5 + insets.top
end
]]