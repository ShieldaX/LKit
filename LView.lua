-- LView.lua
-- Base component in GUI system.
--
-- ========================================

local LView = {}
local LViewMT = {__index = LView}

-- Class public values
local _id = 0  -- ID for vie

--- Class constructor method
-- @frame Init view with frame.
function LView.new(frame)
    --assert frame is a display rect
    local width, height = frame.width or 100, frame.height or 100
    -- background is used for stretching frame( group object ).
    local background = display.newRect(0, 0, width, height)
    background:setFillColor(255, 255, 255, 255)
    local instance = 
        {
            _id = _id + 1,
            --_subViews = {},
            --_superView = nil,
            _bg = background,
            _frame = display.newGroup(),
            _bounds = display.newGroup(),
        }
    instance._frame:insert(background) -- puts BG in bottom layer and
    instance._frame:insert(instance._bounds) -- bounds above BG.
--

    return setmetatable( instance, LViewMT )
end
--

-- Manage subViews in self.
-- Insert view as new subview.
function LView:addView(view, zIndex)
    local layer = self._layer
    -- assert.isA(LView)
    -- zIndex should be a nil or integer value。
    layer:insert(zIndex, view)
    self[view.name] = view
end
--

-- Remove subView from self.
-- @subView Name or zIndex of subView to remove.
function LView:removeView(subView)
    local layer= self._layer
    object = layer[subView] or self[subView]
    if not object then return false end
    layer:remove(object)
    return true
end
--

-- Move subView to new Index
function LView:moveViewToIndex(subView, zIndex)
    local layer = self._layer
    if zIndex < 1 then zIndex = 1 elseif zIndex > layer.numChildren then zIndex = layer.numChildren end
    object = layer[subView] or self[subView]
    layer:insert(zIndex, object)
end
--

--

return LView
