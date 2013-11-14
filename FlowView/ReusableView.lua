-- ReusableView.lua
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local ReusableView = View:subclass('ReusableView')

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
function ReusableView:initialize(api)
  View.initialize(self, api)
  self.reuseIdentifier = api.reuseIdentifier
end

function ReusableView:prepareForReuse()
end

-- ---
-- Managing Layout Changes
-- ---

function ReusableView:applyLayout(layout)
end

function ReusableView:willTransitionTo( ... )
  -- body
end

function ReusableView:enterFrame(event)
  -- queue reusable cell (with reuseIdentifier)

  if self.isInvalid then
    -- invalidation loop
    --self:invalid()
    self.isInvalid = false
  end
end

return ReusableView