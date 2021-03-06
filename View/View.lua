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

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Object
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function View:initialize(api)
  -- Identifer
  local name = api.name
  assert(type(name) == "string" or type(name) == "number", "name should be specified.")
  assert(string.find(name, "_", 1) ~= 1, "can't resolve '_' prefixed subview.")
  assert(not string.find(name, "-", 1), "can't resolve '-' contained subview.")
  self.name = name
  
  -- Visual Appearance
  -- implement paramters
  local x, y, width, height = api.x or 0, api.y or 0, api.width or ACW, api.height or CH
  --local xOffset, yOffset = api.xOffset or 0, api.yOffset or 0
  local padding = api.padding or {left = 0, right = 0, top = 0, bottom = 0}
  local xOffset, yOffset = padding.left, padding.top
  
  -- frame group
  -- The frame defines the position and dimensions of the view in the coordinate system of its superview.
  local frame = display.newGroup()
  frame.x, frame.y = x, y
  
  -- background rect is used for event handling.
  -- background is still used for compute frame's dimension.
  --local background = display.newRect(frame, 0, 0, width, height) -- insert background rect in frame group
  --self.backgroundColor = api.backgroundColor or {255, 255, 255, 0}  -- color table, default is transparent  

  local background
  self.radius = api.radius or 0
  background = display.newRoundedRect(frame, 0, 0, width, height, self.radius)
  background.strokeWidth = api.strokeWidth or 0
  self.backgroundColor = api.backgroundColor or {255, 255, 255, 0}  -- color table, default is transparent  
  background:setFillColor(unpack(self.backgroundColor))
  background:setStrokeColor(unpack(self:getTintColor()))
  self.background = background
  
  -- The bounds group, which describes the view's location and size in its own coordinate system.
  local bounds = display.newGroup()
  frame:insert(bounds)
  bounds.x, bounds.y = xOffset, yOffset

  self.frame = frame -- commonly used during layout to adjust the size or position of the view.
  frame.view = self -- back reference
  self.bounds = bounds
  
  -- View Hierarchy
  self.subviews = {}
  self.superview = nil -- not exist yet
  self.window = nil -- not exist before insert into a window view.
  
  -- Layout and Constraints
  self.clipToBounds = api.clipToBounds or false
  self._layout = {
    -- relative to super view or sibling views
    margin = { -- Specifies extra space of this view. The space are outside this view's bounds.
      left = 0, right = 0,
      leading = 0, trailing = 0,
      top = 0, bottom = 0,
    },
    alignment = {
      centerHorizontal = true,
    },
    --left = 0, right = 0,
    --top = 0, bottom = 0,
    --leading = 0, trailing = 0,
    -- defined self content
    padding = {
      left = 0, right = 0,
      leading = 0, trailing = 0,
      top = 0, bottom = 0,
    },
    width = "content", -- wrap content
    height = "parent", -- match parent
    centerX = 0, centerY = 0,
    baseline = 0,
    weight = 0,
  }

  -- Configuring the Event-Related Behavior
  self.exclusiveTouch = false -- touch focus on self
  self.interactionEnabled = true
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
  table.insert(self.subviews, view) -- add subview
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
    --superview.subviews[self.name] = nil
    superview:willRemoveSubview(self)
    self.superview = nil
  end
  self.window = nil
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
  if not self.superview then return end
  zIndex = tonumber(zIndex)
  assert(zIndex > 0, "invalid zIndex param")
  display.getCurrentStage():insert(self.frame)
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

function View:getTintColor()
  if self.tintColor then return self.tintColor end

  if self.superview then
    return self.superview:getTintColor()
  else
    return {0, 122, 255, 255} -- View.getDefault("tintColor")
  end
end

function View:finalize()
  if self.superview then
    self:removeFromSuperview()
  end
  self.name = nil
  self.frame:removeSelf()
end

function View:layoutSubviews()
  local bounds = self.bounds
  local _width, _height = self:getContentSize()
  local subviews = self.subviews
  table.foreach(subviews, function(i, v)
    local w, h = v:getContentSize()
    local inset, outset = v.inset, v.outset
  end)
end

function View:sizeThatFits()
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