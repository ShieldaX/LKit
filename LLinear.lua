---- Linear.lua ----

-- ------
-- LIBRARIES
-- ------

local LView = require("LView")

-- ------
-- CLASS
-- ------

local LLinear = LView:subclass("LLinear")

-- ------
-- CONSTANTS
-- ------

LLinear.LayoutParams = { Directions = { HORIZONTAL = "horizontal", VERTICAL = "vertical" }}

-- ------
-- VARIABLES
-- ------

-- ------
-- FUNCTIONS
-- ------

--TODO: Be a Render function
local function arrange(bounds)
  for i = 2, bounds.numChildren do
    bounds[i].y = bounds[i-1].y + bounds[i-1].contentHeight
  end
end

-- ------
-- ONTOLOGY FUNCTIONS
-- ------

function LLinear:initialize(opt)
  LView.initialize(self, opt)
  self.direction = opt.direction or "horizontal"
end

function LLinear:addView(view, zIndex)
  LView.addView(self, view, zIndex) -- super call
  local bounds = self.bounds
  if self.direction == LLinear.LayoutParams.Directions.VERTICAL then
    --print("vertical")
    arrange(bounds)
  else -- default
    --print("horizontal")  
  end
end

return LLinear