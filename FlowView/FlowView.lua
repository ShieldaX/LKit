-- FlowView.lua
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local FlowView = View:subclass('FlowView')

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
-- @param api Intent table for construct new instance.
function FlowView:initialize(api)
  View.initialize(self, api)
  self.direction = api.direction -- scroll direction
end

function FlowView:dequeueReusableCellForIndexPath(reuseIdentifier, indexPath)
end

function FlowView:enterFrame(event)
  -- queue reusable cell (with reuseIdentifier)

  if self.isInvalid then
    -- invalidation loop
    self:invalidate()
    self.isInvalid = false
  end
end

function FlowView:invalidate()
  self:prepareLayout()
end

function FlowView._prepareLayout(instance)
  instance:prepareLayout()
end

return FlowView