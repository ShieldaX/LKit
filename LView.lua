---- View.lua ----

-- ------
-- LIBRARIES
-- ------

require 'middleclass'

-- ------
-- CLASS
-- ------

--TODO: _G['LView'] = LView
local LView = class "LView"

-- ------
-- CONSTANTS
-- ------

-- ------
-- VARIABLES
-- ------

local id = 0 -- view id

-- ------
-- FUNCTIONS
-- ------

-- ------
-- ONTOLOGY FUNCTIONS
-- ------

function LView:initialize(opt)
  id = id + 1
  self.id = id
  self.name = opt.name or tostring(id)
  
  local width, height = opt.width or 100, opt.height or 100
  -- background is used for stretching frame( group object ).
  local background = display.newRect(0, 0, width, height)
  local backgroundColor = opt.backgroundColor or {255, 255, 255, 255}
  background:setFillColor(unpack(backgroundColor))
  
  self.subviews = {}
  self.background = background
  self.backgroundColor = backgroundColor
  self.frame = display.newGroup()
  self.bounds = display.newGroup()
  --self._gestureRecognizers = {}
  
  self.frame:insert(background) -- make background **rect** as frame skeleton and
  self.frame:insert(self.bounds) -- lay bounds **group** above background.
end

--[[
-- Insert view as new subview.
-- @view Subview to be insert.
-- *zIndex Display order of new subview.
]]
function LView:addView(view, zIndex)
    --assert(view and isView(view), "Subview must be a LView")
    --assert(type(view.name) == "string", "")
    assert(view.superview ~= self, "subview already exists, use 'moveViewToIndex' to change display order")
    assert(getmetatable(view.frame) == getmetatable(display.getCurrentStage()), "try to insert an invalid view")
    
    local bounds = self.bounds
    bounds:insert(zIndex or bounds.numChildren + 1, view.frame)
    view.superview = self
    if type(view.name) == "string" then self.subviews[view.name] = view end
end
--

--[[
-- Remove subView from self.
-- @subview Name or zIndex of subView to remove.
]]
function LView:removeView(subview)
    local bounds= self.bounds
    local object = self.subviews[subview]
    if not object then
        object = bounds[subview]
        subview = self:nameOfView(subview)
    else
        object = object.frame
    end
    if object then
        local ref = self.subviews[subview]
        ref.superview = nil
        self.subviews[subview] = nil
        object:removeSelf()
        object = nil
        --print_r(ref)
    end
    return false
end
--

--[[
-- Clear all subviews in this view.
]]
function LView:clear()
  local subviews = self.subviews
end
--

--[[
-- Move subView to new Index.
-- @
]]
function LView:moveViewToIndex(subview, toIndex)
    local bounds = self.bounds
    if toIndex < 1 then toIndex = 1 elseif toIndex > bounds.numChildren then toIndex = bounds.numChildren end
    local object = self.subviews[subview]
    if not object then
        object = bounds[subview]
    else
        object = object.frame
    end
    display.getCurrentStage():insert(object) -- take object out to shared stage
    bounds:insert(toIndex, object) -- re-insert object at new index
end
--

-- ------
-- REFERENCE FUNCTIONS
-- ------

--[[
-- Get view's name at the index.
-- @index Subview's index.
]]
function LView:nameOfView(index)
    local object = self.bounds[index]
    if object then    
        for name, view in pairs(self.subviews) do
            if object == view.frame then return name end
        end
    end
    return false
end
--

--[[
-- Get current view's root view -- window.
]]
function LView:getWindow()
    local view = self
    while view.superview do -- if view has super view,
       view = view.superview -- then try its superview alternatively,
    end
    -- until view doesn't have superview.
    return view
    --return self.superview:getWindow()
end
--

--[[
-- Check if the view's descendant.
-- @targetView The view to check.
]]
function LView:isDescendantOfView(targetView)
    local view = self
    while view.superview do -- if view has super view,
        view = view.superview
        if view == targetView then return true end
    end
    return false
end
--

-- ------
-- LAYOUT FUNCTIONS
-- ------

-- ------
-- CUSTOM FUNCTIONS
-- ------

--[[
-- Set background color
-- @colorTable Table of color to set to.
-- @transparent:boolean Keep background be transparent or not.
]]
function LView:setBackgroundColor(colorTable, transparent)
    --local ori_color = self._bgc
    self.background:setFillColor(unpack(colorTable))
    if not transparent then self.background.alpha = 1 end
    self.backgroundColor = colorTable
end
--

return LView