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
function LView.new(frame)
    --assert frame is a display rect
    assert(type(frame) == "table", "frame should be a table.")
    local width, height = frame.width or 100, frame.height or 100
    -- background is used for stretching frame( group object ).
    local background = display.newRect(0, 0, width, height)
    background:setFillColor(255, 255, 255, 255) -- set default bg color-- white.
    if not DEBUG then background.alpha = 0 end
    local instance = 
        {
            _id = _id + 1,
            --_subViews = {},
            --_superView = nil,
            _background = background,
            _frame = display.newGroup(),
            _bounds = display.newGroup(),
        }
    instance._frame:insert(background) -- make background **rect** as frame skeleton and
    instance._frame:insert(instance._bounds) -- lay bounds **group** above background.

    return setmetatable( instance, LViewMT )
end
--

-- ---
-- Manage subViews in self.
--
-- Insert view as new subview.
function LView:addView(view, zIndex)
    local bounds = self._bounds
    -- assert.isA(LView)
    if not type(self[view.name]) == "nil" then return false end
    -- zIndex should be a nil or integer value.
    bounds:insert(zIndex, view)
    self[view.name] = view
end
--

-- Remove subView from self.
-- @subView Name or zIndex of subView to remove.
function LView:removeView(subView)
    local bounds= self._bounds
    object = bounds[subView] or self[subView]
    if not object then return false end
    bounds:remove(object)
    return true
end
--

-- Move subView to new Index.
function LView:moveViewToIndex(subView, zIndex)
    local bounds = self._bounds
    if zIndex < 1 then zIndex = 1 elseif zIndex > bounds.numChildren then zIndex = bounds.numChildren end
    object = bounds[subView] or self[subView]
    bounds:insert(zIndex, object)
end
--
-- ---

-- Set background color
-- @colorT Table of color to set to.
function LView:setBackgroundColor(colorTable, keepAlpha)
    --local ori_color = self._bgc
    self._background:setFillColor(unpack(colorTable))
    if not keepAlpha then self._background.alpha = 1 end
    --self._bgc = colorT
end
--

return LView
