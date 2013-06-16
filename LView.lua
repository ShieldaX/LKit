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
    assert(view.superview ~= self, "Subview already exists, use 'moveViewToIndex' to change display order")
    
    local bounds = self.bounds
    bounds:insert(zIndex or bounds.numChildren + 1, view.frame)
    view.superview = self
    if type(view.name) == "string" then self.subviews[view.name] = view end
end
--

-- Remove subView from self.
-- @subview Name or zIndex of subView to remove.
function LView:removeView(subview)
    local bounds= self._bounds
    object = bounds[subView] or self.subviews[subview]
    if not object then return false end
    bounds:remove(object)
    return true
end
--

-- Move subView to new Index.
-- @
function LView:moveViewToIndex(subview, toIndex)
    local bounds = self._bounds
    if toIndex < 1 then toIndex = 1 elseif toIndex > bounds.numChildren then toIndex = bounds.numChildren end
    object = bounds[subview] or self[subview]
    bounds:insert(toIndex, object)
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
    self._bounds.backgroundColor = colorTable
end
--

-- Get current view's root view -- window.
function LView:getWindow()
    local view = self
    while view._superview do -- if view has super view,
       view = view._superview -- then try its superview alternatively,
    end
    -- until view doesn't have superview.
    return view
end
--

-- Check if the view's descendant.
-- @view The view to check.
function LView:isDescendantOfView(view)
end    
--

return LView
