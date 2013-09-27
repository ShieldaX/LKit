-----------------------------------------------------------------------------------------
--
-- spec_View.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    print("initialize")
    local blue = {90, 200, 255}
    ts.window = View {
      name = "fullscreened",
      bounds = {0, 20, VCW, VCH-20},
      backgroundColor = blue,
      --cornerRadius = 10,
      --backgroundFilter = "filter.blur",
    }
    local window = ts.window
    assert(window and window.name == "fullscreened", "incorrect name")
    assert(window.backgroundColor and window.backgroundColor == blue, "incorrect color")
    assert(window.bounds and window.bounds.width == VCW and window.bounds.height == VCH-20, "incorrect dimension")
end, "display a fullscreen view")

ts.desc("#Configuring a View's Visual Appearance")
ts.regist(2, function()
    local window = ts.window
    local white = {255, 255, 255, 255}
    window:setBackgroundColor(white)
    assert(window.backgroundColor == white, "incorrect color")
    util.print_r(window.backgroundColor)
end, "change background's color to white")

ts.desc("#Managing the View Hierarchy")
ts.regist(1, function()
    print("create a new view")
    local grayColor = {142, 142, 147, 255}
    local bar = View {
      name = "bar",
      bounds = {0, 0, VCW, 40},
      backgroundColor = grayColor,
    }
    ts.window:addSubview(bar)
    assert(ts.window.bar)
end, "display a bar view at the top")

ts.regist(1, function() end, "add a icon subview to bar view")

ts.regist(2, function() end, "remove icon subview from its superview")

ts.desc("#Animations")
ts.regist(2, function() end, "create/modify/commit animation")

return ts