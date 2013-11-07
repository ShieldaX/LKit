-----------------------------------------------------------------------------------------
--
-- NavigationItem_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local NavigationItem = require 'NavigationItem'

--local VCW = display.viewableContentWidth
--local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    local item1 = NavigationItem {
      name = "follow",
      title = "My Follow",
    }
end, "create a new navigation bar instance")

ts.desc("#config appearance")
ts.regist(1, function()
    -- body
end, "translucent and tint colors")

ts.desc("#manage navigation items")
ts.regist(1, function()
    -- body
end, "left item")

ts.regist(2, function()
    -- body
end, "middle item")

ts.regist(2, function()
    -- body
end, "right item")

return ts