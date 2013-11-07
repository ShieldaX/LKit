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
    local navigator = NavigationBar {tintColor = {0, 122, 255}}
    local topItem = NavigationItem {
      name = "pixplus", title = "PixPlus",
      hidesBackButton = true,
    }
    navigator:pushItem(topItem)
    print("pushing", topItem.name)
    ts.nav = navigator
end, "create a new navigation bar instance")

ts.desc("#config appearance")
ts.regist(0, function()
end, "translucent and tint colors")

ts.desc("#manage navigation items")
ts.regist(2, function()
    print("top:", ts.nav.topItem.name)
    assert(not ts.nav.backItem)
    local second = NavigationItem {
      name = "clip", title = "Animals",
      hidesBackButton = false,
    }
    ts.nav:pushItem(second, true)
    print("pushing", second.name)
    print("top:", ts.nav.topItem.name)
    print("back:", ts.nav.backItem.name)
end, "push item")

ts.regist(2, function()
    ts.nav:popItem(true)
    print("top:", ts.nav.topItem.name)
    assert(not ts.nav.backItem)
end, "pop item")

ts.regist(1, function()
    ts.nav:setBarHidden(true, true)
    timer.performWithDelay( 200, function(event)
      ts.nav:setBarHidden(false, true)
    end)
    timer.performWithDelay( 600, function(event)
      ts.nav:setBarHidden(true, true)
    end)
    timer.performWithDelay( 800, function(event)
      ts.nav:setBarHidden(false, true)
    end)
    timer.performWithDelay( 1600, function(event)
      ts.nav:setBarHidden(true, true)
    end)
end)

ts.regist(4, function()
    ts.nav:setBarHidden(false, true)
end)

return ts