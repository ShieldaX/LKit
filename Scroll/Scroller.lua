-- Scroller.lua
-- Enable scrolling module

local function getVelocity(view)

end

local Scroller = {}

function Scroller:touch()

end

function Scroller:enterFrame()

end

function Scroller:included()
  self.contentView:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

return Scroller