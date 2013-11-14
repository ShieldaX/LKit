-- Cell.lua
-- Cell used in flow view.
-- The layout and presentation of cells is managed by the collection view and its corresponding layout object.
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
  local self.view
  self:addSubview(View {name = "contentView"})
  self.selected = false
  self.highlighted = false
  self.backgroundView = nil
  self.selectedBackgroundView = nil
end

-- special config before reusing
function Cell:prepareForReuse()
  -- reset state
  self.selected = false
  self.highlighted = false
end

function Cell:setSeleted(selected)
  -- change appearance on selection changes
end

return Cell