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
  --frame is, a group object, used for define position and size in superview.
  self._frame = display.newGroup()
  --bounds is, also a display group, used for define self content position and size in frame.
  self._bounds = display.newGroup()
  -- background is, a rect, used for touch handle
  self.background = display.newRect(self._frame, 0, 0, width, height) -- make background **rect** as frame skeleton and
  self.backgroundColor = opt.backgroundColor or {255, 255, 255, 255} -- color table
  self.background:setFillColor(unpack(backgroundColor))
  
  self.subviews = {}
  self.gestureRecognizers = {}
  
  self._frame:insert(self._bounds) -- lay bounds **group** above background.
end

--[[
-- Insert view as new a subview.
-- @param view Subview to be insert.
-- @param *zIndex Display order of new subview.
]]
function LView:addView(view, zIndex)
    --assert(view and isView(view), "Subview must be a LView")
    --assert(type(view.name) == "string", "")
    assert(view.superview ~= self, "subview already exists, use 'moveViewToIndex' to change display order")
    assert(getmetatable(view._frame) == getmetatable(display.getCurrentStage()), "try to insert an invalid view")
    assert(string.find(view.name, "_", 1) ~= 1, "can't resolve '_' prefixed subview." )
    -- ensure view name doesn't contain "-", or it will hurt nested reference.
    assert(not string.find(view.name, "-", 1), "can't resolve '-' contained subview." )
    local bounds = self._bounds
    bounds:insert(zIndex or bounds.numChildren + 1, view._frame)
    view.superview = self
    if type(view.name) == "string" then
      self.subviews[view.name] = view
      self[view.name] = view
    end
end
--

--[[
-- Remove subView from self.
-- @param subview Name or zIndex of subView to remove.
]]
function LView:removeView(subview)
    local bounds= self._bounds
    local object = self.subviews[subview]
    if not object then
        object = bounds[subview]
        subview = self:nameOfView(subview)
    else
        object = object._frame
    end
    if object then
        local ref = self.subviews[subview]
        ref.superview = nil
        self.subviews[subview] = nil
        object:removeSelf()
        object = nil
        --print_r(ref)
    end
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
    local bounds = self._bounds
    if toIndex < 1 then toIndex = 1 elseif toIndex > bounds.numChildren then toIndex = bounds.numChildren end
    local object = self.subviews[subview]
    if not object then
        object = bounds[subview]
    else
        object = object._frame
    end
    display.getCurrentStage():insert(object) -- take object out to shared stage
    bounds:insert(toIndex, object) -- re-insert object at new index
end
--

-- ------
-- REFERENCE FUNCTIONS
-- ------

--[[
-- Retrive reference of a subview
-- @param name The name of the subview.
-- @return The subview reference or nil if none found.
]]
function LView:findViewByName( name )
  local founded = self.subviews[name]
  return nil
end

--[[
-- Get view's name at the index.
-- @param index Subview's index.
]]
function LView:nameOfView(index)
    local object = self._bounds[index]
    if object then    
        for name, view in pairs(self.subviews) do
            if object == view._frame then return name end
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
-- @param targetView The view to check.
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
-- @param colorTable Table of color to set to.
-- @param transparent:boolean Keep background be transparent or not.
]]
function LView:setBackgroundColor(colorTable, transparent)
    --local ori_color = self._bgc
    self._background:setFillColor(unpack(colorTable))
    if not transparent then self._background.alpha = 1 end
    self._backgroundColor = colorTable
end
--

return LView
