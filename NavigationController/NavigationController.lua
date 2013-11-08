-----------------------------------------------
-- @class: NavigationBar
-- @file NavigationBar.lua - v0.0.1 (2013-09)
-- Container view controller with a controller stack.
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local NavigationBar = require 'NavigationBar'
local NavigationItem = require 'NavigationItem'

-- ======
-- CLASS
-- ======
local NavigationController = class("NavigationController")

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

NavigationController.static.pushPopDistance = CW
NavigationController.static.pushPopDuration = 400 -- time for pushing and popping animation

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Object
-- ------

--- Instance constructor
function NavigationController:initialize(opt)

end

-- @param item NavigationItem instance to push.
-- @param animated True if the navigation bar should be animated; otherwise, false.
function NavigationBar:pushItem(item, animated)
  local Object = class.Object
  assert(Object.isInstanceOf(item, NavigationItem), "ERROR: item is not a valid NavigationItem instance")
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

  -- back button
  local backButton
  if not item.hidesBackButton then
    if not self.backButton.isVisible then
      if backItem and not backItem.hidesBackButton then
        -- prev button
        print("should hides backItem backButton")
      end
      backButton = item.backButton or self.backButton
      backButton.isVisible = true
    elseif item.backButton then
      pint("hides bar backButton first")
      backButton = item.backButton
      backButton.isVisible = true
    end
  else
    if backItem and not backItem.hidesBackButton then
      -- prev button
      local prevBackButton = item.backButton or self.backButton      
      print("should hides backItem backButton")
      transition.to(prevBackButton, {time = time, alpha = 0})
    end
  end

  -- fade in and fade out if it's necessary
  frame.isVisible = true  
  if animated == true then
    local time = self.class._tweenTime
    if self.tween then transition.cancel(self.tween) end
    self.tween = transition.from(frame, {time = time, alpha = 0, x = self.class._tweenDelta})
    if backItem then
      --TODO: manage transition, make it cancellable
      transition.from(backItem.frame, {time = time, alpha = 1, x = 0})
      if backButton and backButton.alpha == 1 then
        transition.from(backButton, {time = time, alpha = 0})
      end
    end  
  end
end

function NavigationBar:popItem(animated)  
  local items = self.items
  if #items < 2 then return print("WARNING: popping the last navigation item.") end
  --if #items < 2 then print("WARNING: popping the last navigation item.") end
  local item = table.remove(items) -- retain the popped item
  
  self.topItem = items[#items]
  -- backItem exists when there are at least two items on stack.
  if #items > 1 then
    self.backItem = items[#items-1]
  else
    self.backItem = nil
  end
  
  -- position item
  local frame = item.frame
  frame.x = self.class._tweenDelta
  frame.alpha = 0
  -- current top item
  local topItem = self.topItem
  if topItem then
    topItem.frame.x = 0
    topItem.frame.alpha = 1
  end

  -- back button
  local backButton
  if topItem.hidesBackButton then
    backButton = topItem.backButton or self.backButton
    if backButton.isVisible then
      backButton.alpha = 0
    end
  else
    if topItem and not topItem.hidesBackButton then
      -- prev button
      curBackButton = topItem.backButton or self.backButton      
      print("should show backItem backButton")
      transition.to(curBackButton, {time = time, alpha = 1})
    end
  end

  -- fade in and fade out if it's necessary
  frame.isVisible = true
  if animated == true then
    local time = self.class._tweenTime
    if self.tween then transition.cancel(self.tween) end
    if topItem then
      transition.from(topItem.frame, {time = time, alpha = 0, x = - self.class._tweenDelta})
      if backButton and backButton.alpha == 0 then
        transition.from(backButton, {time = time, alpha = 1})
      end
    end
    self.tween = transition.from(frame, {time = time, alpha = 1, x = 0})
  end

  return item
end

function NavigationBar:setItems(items, animated)
  -- set navigation items stack directly
end

function NavigationBar:setBarHidden(hidden, animated)
  local frame = self.frame
  local transDelta = frame.contentHeight
  local originPos = frame.y
  if hidden == true then
    --if self.isHideen then return print("WARNING: navigator is already hidden.") end
    frame.y = frame.yInitial - transDelta
  elseif self.isHideen then    
    frame.y = frame.yInitial
  else
    --return print("WARNING: navigator is already display.")
  end
  self.isHideen = hidden or false
  if animated then
    if self.tween then transition.cancel(self.tween) end
    self.tween = transition.from(frame, {time = self.class.hideShowBarDuration, y = originPos, transition = easing.inOutQuad})
  end
end

function NavigationBar:setBackgroundImage(imagePath)
  -- stretch image to fit bar's bounds
end

return NavigationBar