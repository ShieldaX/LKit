-- LButton.lua
-- Button maintainer
--

-- ------
-- LIBRARIES
-- ------

local LView = require("LView")

-- ------
-- CLASS
-- ------

local LButton = LView:subclass("LButton")

-- ------
-- CONSTANTS
-- ------

-- ------
-- VARIABLES
-- ------

-- ------
-- FUNCTIONS
-- ------

-- ------
-- ONTOLOGY FUNCTIONS
-- ------

function LButton:initialize(opt)
  LView.initialize(self, opt)
  local roundedRect = display.newRoundedRect(self.bounds, 0, 0, 160, 60, 12)
  roundedRect.strokeWidth = 2
  roundedRect:setFillColor(255, 255, 255)
  roundedRect:setStrokeColor(0, 122, 255)
  local label = display.newText(self.bounds, "Label", 0, 0, native.systemFont, 30)
  label:setTextColor(0, 122, 255)
  label.x = roundedRect.x
  label.y = roundedRect.y
  self.bounds:addEventListener("touch", self)
end

function LButton:touch(event)
  -- touched
  if event.phase == "ended" then print("touchUp") end
end

function LButton:setLabel()
end

return LButton