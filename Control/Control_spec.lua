-----------------------------------------------------------------------------------------
--
-- Control_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

ts.desc("#Instance constructor")
ts.regist(1, function()
    print("initialize")
end, "display a fullscreen view")

return ts