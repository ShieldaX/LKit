---- LWindow.lua ----

-- ------
-- LIBRARIES
-- ------

local LView = require("LView")

-- ------
-- CLASS
-- ------

local LWindow = LView:subclass("LWindow")

-- ------
-- CONSTANTS
-- ------
local stage = {
viewableContentWidth = display.viewableContentWidth,
viewableContentHeight = display.viewableContentHeight,
pixelWidth = display.pixelWidth,
pixelHeight = display.pixelHeight,
contentWidth = display.contentWidth,
contentHeight = display.contentHeight,
screenOriginX = display.screenOriginX,
screenOriginY = display.screenOriginY,
contentScaleX = display.contentScaleX,
contentScaleY = display.contentScaleY,
contentCenterX = display.contentCenterX,
contentCenterY = display.contentCenterY
}

--print_r(stage)

-- ------
-- VARIABLES
-- ------

-- ------
-- FUNCTIONS
-- ------

-- ------
-- ONTOLOGY FUNCTIONS
-- ------

function LWindow:initialize(opt)
  opt.width = display.viewableContentWidth
  opt.height = display.viewableContentHeight
  LView.initialize(self, opt)
  self.frame.x = display.screenOriginX
  self.frame.y = display.screenOriginY
end

function LWindow:window()
  return self
end

return LWindow