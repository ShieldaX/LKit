-- Scroller.lua
-- Enable scrolling module

-- private var
local upperLimit, bottomLimit -- dynamic scroll limitation

-- private func
local function updateLimit()
end

local function getVelocity()
end

local Scroller = {
  scrollEnabled = true,
  dragging = false,
  tracking = false,
  decelerating  = false,
  decelerationRate = 0.92,
}

function Scroller:loseFocus()
end

function Scroller:takeFocus()
end

function Scroller:createScrollBar()

end

function Scroller:touch()
end

function Scroller:enterFrame(event)
  -- track velocity
  if self.tracking then
    -- time elapse
    local deltaTime = event.time - self._lastTime
    self._lastTime = event.time
    local calculatedVelocity = (view.y - view._lastY) / deltaTime
    
  end
  -- fling content
end

function Scroller:included()
  self.contentView:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

return Scroller