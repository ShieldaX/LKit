-----------------------------------------------------------------------------------------
--
-- Controller_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'
local Controller = require 'Controller'

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

ts.desc("#Test Pilot")
ts.regist(0, function()
    print("actual:", ACW, ACH)
    print("content:", CW, CH)
    print("origin:", SOX, SOY)
end, "output device info")

ts.regist(0, function()
    ctrl = Controller {name = "follow", title = "My Follow"}
    ctrl:view()
    ts.ctrl = ctrl
end, "create instance")

return ts