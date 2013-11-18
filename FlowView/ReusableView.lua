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
  self.frame.x = layout.x
  self.frame.y = layout.y
end

function ReusableView:willTransitionTo( ... )
  -- body
end

return ReusableView