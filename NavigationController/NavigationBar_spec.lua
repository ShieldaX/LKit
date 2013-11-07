-----------------------------------------------------------------------------------------
--
-- NavigationBar_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local NavigationBar = require 'NavigationBar'
local NavigationItem = require 'NavigationItem'

--local VCW = display.viewableContentWidth
--local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    navigator = NavigationBar {tintColor = {0, 122, 255}}
    local topItem = NavigationItem {name = "top", title = "PixPlus"}
    navigator:pushItem(topItem)
    ts.nav = navigator
end, "create a new navigation bar instance")

ts.desc("#config appearance")
ts.regist(0, function()
end, "translucent and tint colors")

ts.desc("#manage navigation items")
ts.regist(2, function()
    local second = NavigationItem {name = "clip", title = "Animals"}
    navigator:pushItem(second, true)
end, "push item")

ts.regist(2, function()
    ts.nav:popItem(true)
end, "pop item")

ts.regist(1, function()
    ts.nav:setHidden(true, true)
end)

ts.regist(1, function()
    ts.nav:setHidden(false, true)
end)

return ts