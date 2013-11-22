-----------------------------------------------------------------------------------------
--
-- Control_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'
local ProgressBar = require 'ProgressBar'

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

ts.desc("#Instance constructor")
ts.regist(0, function()
    print("initialize")
    local backgroundView = View {
      name = "backed",
      width = ACW, height = ACH,
      x = SOX, y = SOY,
      backgroundColor = {255, 255, 255, 255},
    }
    ts.view = backgroundView
end, "display a fullscreen view")

ts.regist(0, function()
    ts.pr = ProgressBar {
      name = "prog",
      width = 140,
      x = 100, y = display.contentCenterY
    }
    ts.view:addSubview(ts.pr)

end, "create new progress bar")

ts.regist(1, function()
    ts.pr:update(0.8)
    timer.performWithDelay( 300, function()
      ts.pr:update(0.2)
    end)
end, "update progress")

ts.regist(1, function()
    ts.pr:update(2)
end, "update progress complete")

return ts