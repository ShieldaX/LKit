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
      --yOffset = 20,
      --yInset = 44,
      --yScrollBarInset = 44,
    }
  local image = display.newImageRect(ts.scroll.bounds, imagePath, unpack(imageSize))
  image.y = image.y + image.contentHeight*.5
  image.x = image.x + image.contentWidth*.5
end, "create a fullscreen scroll view")

ts.regist(1, function()
  local view = ts.scroll.bounds
  local first = view[1]
  local image = display.newImageRect(view, imagePath, unpack(imageSize))
  image.y = first.y + first.height*.5 + image.contentHeight*.5 + 20
  image.x = image.x + image.contentWidth*.5
end, "insert another pic")

ts.desc("#Set content offset")
ts.regist(2, function()
  ts.scroll:scrollToPosition(200, true)
  --ts.scroll:touch()
end, "scroll to sepecial position")

return ts