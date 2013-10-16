-- Scroller.lua
-- Enable scrolling module

-- private var
local upperLimit, bottomLimit -- dynamic scroll limitation

-- private func
local function updateLimit()
end

local function getVelocity()
end

local Scroller = {}

function Scroller:createScrollBar()

end

function Scroller:touch()
end

function Scroller:enterFrame()
end

function Scroller:included()
  self.contentView:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

return Scroller