-- LView.lua
-- Key component in GUI system.
--
-- ========================================

local LView = {}
local LViewMT = {__index = LView}

-- Class public values
local _id = 0  -- ID for vie

--- Class constructor method
function LView.new()
    local instance = 
        {
            _id = _id + 1,
            _subViews = {},
            --_superView = nil,
            --_layer = nil,
            
        }
--

    return setmetatable( instance, LViewMT )
end
--

-- Manage subViews in self.
function LView:addView(view, zIndex)
    -- assert.isA(LView)
    -- zIndex should be a nil or integer value
end
--

function LView:removeView(atIndex)
    --
end
--


return LView