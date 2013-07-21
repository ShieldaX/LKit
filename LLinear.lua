-- LLinear.lua
-- Linear layout component, absolute view container.
-- Switch between 2 directions: horizontal & vertical.
--
-- ========================================

local LView = require("LView")

local LLinear = LView:new()

LLinear.LayoutParams = { Directions = { Horizontal = 0, Vertical = 1 }}

function LLinear:init(opt)
  LView.init(self, opt)
  self.direction = 1
end

local function arrange(bounds)
  for i = 2, bounds.numChildren do
    bounds[i].y = bounds[i-1].y + bounds[i-1].contentHeight
  end
end

function LLinear:addView(view, zIndex)
  LView.addView(self, view, zIndex) -- super call
  local bounds = self.bounds
  if self.direction == LLinear.LayoutParams.Directions.Vertical then
    print("vertical")
    arrange(bounds)
    
  else -- default
    print("horizontal")  
  end
end

return LLinear