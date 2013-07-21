-- LView.lua
-- Base component in GUI system.
--
-- ========================================

local LView = {}
local LViewMT = {__index = LView}

-- Class public values
local _id = 0  -- ID for each view.

--- Class constructor method.
-- @frame Init view with frame.
function LView.new(opt)
    assert(type(opt) == "table", "option must be a table")
    _id = _id + 1
    local width, height = opt.width or 100, opt.height or 100
    -- background is used for stretching frame( group object ).
    local background = display.newRect(0, 0, width, height)
    local backgroundColor = opt.backgroundColor or {255, 255, 255, 255}
    background:setFillColor(unpack(backgroundColor))
    if not DEBUG then background.alpha = 0 end
    local instance = 
        {
            name = opt.name,
            _id = _id,
            subviews = {},
            --superview = nil,
            _background = background,
            _backgroundColor = backgroundColor,
            frame = display.newGroup(),
            bounds = display.newGroup(),
            _gestureRecognizers = {},
        }
    --instance.frame._backgroundColor = {255, 255, 255}
    instance.frame:insert(background) -- make background **rect** as frame skeleton and
    instance.frame:insert(instance.bounds) -- lay bounds **group** above background.

    return setmetatable( instance, LViewMT )
end
--

-- ---
-- Manage subViews in self.
--
-- Insert view as new subview.
-- @view Subview to be insert.
-- *zIndex Display order of new subview.
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

-- Remove subView from self.
-- @subview Name or zIndex of subView to remove.
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

-- Move subView to new Index.
-- @
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
-- ---

-- Set background color
-- @colorTable Table of color to set to.
-- @transparent:boolean Keep background be transparent or not.
function LView:setBackgroundColor(colorTable, transparent)
    --local ori_color = self._bgc
    self._background:setFillColor(unpack(colorTable))
    if not transparent then self._background.alpha = 1 end
    self._backgroundColor = colorTable
end
--

-- Get view's name at the index.
-- @index Subview's index.
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

-- Get current view's root view -- window.
function LView:getWindow()
    local view = self
    while view.superview do -- if view has super view,
       view = view.superview -- then try its superview alternatively,
    end
    -- until view doesn't have superview.
    return view
end
--

-- Check if the view's descendant.
-- @targetView The view to check.
function LView:isDescendantOfView(targetView)
    local view = self
    while view.superview do -- if view has super view,
        view = view.superview
        if view == targetView then return true end
    end
    return false
end    
--

return LView
