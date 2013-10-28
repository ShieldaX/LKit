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
local imageSize = {320, 478}

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
    ts.scroll:scrollTo(200, true)
end, "scroll to sepecial position")

ts.regist(2, function()
    ts.scroll:scrollTo("top", true)
end, "scroll to top")

ts.regist(2, function()
    ts.scroll:scrollTo("bottom", true)
end, "scroll to bottom")

ts.regist(2, function()
    local bounds = {yMin = 20, yMax = 64}
    ts.scroll:scrollBoundsTo(bounds, "top", true)
end, "scroll to view bounds")

return ts