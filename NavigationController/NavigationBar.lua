-----------------------------------------------
-- @class: NavigationBar
-- @file NavigationBar.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local NavigationBar = View:subclass("NavigationBar")

NavigationBar.static._tweenTime = 400 -- time for pushing and popping animation
NavigationBar.static._tweenDelta = display.contentCenterX -- time for pushing and popping animation
NavigationBar.static.hideShowBarDuration = 400 -- time for pushing and popping animation

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
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
-- @param opt Intent table for construct new instance.
function NavigationBar:initialize(opt)
  opt.x, opt.y = SOX, SOY
  opt.width = CW
  opt.name = opt.name or "navigator"
  opt.height = display.topStatusBarContentHeight + 50
  opt.backgroundColor = opt.backgroundColor or {255, 255, 255} -- display white background by default
  if opt.translucent==false then opt.backgroundColor[4] = 255 else opt.backgroundColor[4] = 240 end -- translucent setting
  opt.yOffset = display.topStatusBarContentHeight
  View.initialize(self, opt)

  local frame = self.frame
  local shadow = display.newRect( frame, 0, frame.contentHeight - 1, frame.contentWidth, 1 )
  shadow:setFillColor(153, 158, 165)
  self.shadow = shadow

  self.items = {} -- navigation item stack
  self.topItem, self.backItem = nil
  self.tween = nil
  self.offsetTotitle = 0
  self.frame.yInitial = self.frame.y
  self.isHideen = false
end

-- @param item NavigationItem instance to push.
-- @param animated True if the navigation bar should be animated; otherwise, false.
function NavigationBar:pushItem(item, animated)
  --if not item isInstanceOf NavigationItem then return end
  local items = self.items
  table.insert(items, item)
  self.backItem = self.topItem
  self.topItem = item
  local frame = item.frame
  frame.isVisible = false
  
  -- position items
  self:addSubview(item)
  frame.y = self.offsetTotitle  
  local backItem = self.backItem
  if backItem then
    backItem.frame.x = - self.class._tweenDelta
    backItem.frame.alpha = 0
  end

  -- fade in and fade out if it's necessary
  frame.isVisible = true
  if animated == true then
    if self.tween then transition.cancel(self.tween) end
    if backItem then transition.from(backItem.frame, {time = self.class._tweenTime, alpha = 1, x = 0}) end
    self.tween = transition.from(frame, {time = self.class._tweenTime, alpha = 0, x = self.class._tweenDelta})
  end
end

function NavigationBar:popItem(animated)
  local items = self.items
  if #items < 2 then print("WARNING: popping the last navigation item.") end
  local item = table.remove(items) -- retain popped item
  self.topItem = self.backItem
  if #items > 1 then self.backItem = items[#items-1] end -- at least two item
  local frame = item.frame
  
  -- position item
  frame.x = self.class._tweenDelta
  frame.alpha = 0
  local backItem = self.backItem
  if backItem then
    backItem.frame.x = 0
    backItem.frame.alpha = 1
  end

  -- fade in and fade out if it's necessary
  frame.isVisible = true
  if animated == true then
    if self.tween then transition.cancel(self.tween) end
    if backItem then transition.from(backItem.frame, {time = self.class._tweenTime, alpha = 0, x = - self.class._tweenDelta}) end
    self.tween = transition.from(frame, {time = self.class._tweenTime, alpha = 1, x = 0})
  end
end

function NavigationBar:setHidden(hidden, animated)
  local frame = self.frame
  local transDelta = frame.contentHeight
  local originPos = frame.y
  if hidden == true then
    if self.isHideen then return print("WARNING: navigator is already hidden.") end
    frame.y = frame.yInitial - transDelta
    print(frame.y)
  elseif self.isHideen then    
    frame.y = frame.yInitial
  else
    print("WARNING: navigator is already display.")
  end
  self.isHideen = hidden or false
  if animated then
    if self.tween then transition.cancel(self.tween) end
    self.tween = transition.from(frame, {time = self.class.hideShowBarDuration, y = originPos, transition = easing.inOutQuad})
  end
end


return NavigationBar