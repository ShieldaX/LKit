-----------------------------------------------------------------------------------------
--
-- Scroll_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local Scroll = require 'Scroll'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight
local imagePath = "Tulip.jpg"
local imageSize = {320, 1024}

ts.desc("#Instance constructor")
ts.regist(0, function()
  ts.scroll = Scroll {
      name = "scroller",
      backgroundColor = {255, 255, 255},
      yOffset = 20,
    }
  local image = display.newImageRect(ts.scroll.bounds, imagePath, unpack(imageSize))
  image.y = image.y + image.contentHeight*.5
  image.x = image.x + image.contentWidth*.5
end, "create a fullscreen scroll view")

return ts