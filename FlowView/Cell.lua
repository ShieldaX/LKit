-- Cell.lua
-- Cell used in flow view.
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local View = require 'View'
local ReusableView = require 'ResusbleView'

-- ======
-- CLASS
-- ======
local Cell = ResusbleView:subclass('Cell')

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
function Cell:initialize(api)
  ResusbleView.initialize(self, api)
  self:addSubview(View {name = "contentView"})
end

function Cell:prepareForReuse()
end

-- ---
-- Managing Layout Changes
-- ---

function Cell:applyLayout(layout)
end

function Cell:willTransitionTo( ... )
  -- body
end

function Cell:enterFrame(event)
  -- queue reusable cell (with reuseIdentifier)

  if self.isInvalid then
    -- invalidation loop
    --self:invalid()
    self.isInvalid = false
  end
end

return Cell