-- Cell.lua
-- Cell used in flow view.
-- The layout and presentation of cells is managed by the collection view and its corresponding layout object.
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local View = require 'View'
local ReusableView = require 'ReusableView'

-- ======
-- CLASS
-- ======
local Cell = ReusableView:subclass('Cell')

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
function Cell:initialize(api)
  api.backgroundColor = {142, 142, 147}

  ReusableView.initialize(self, api)
  --self:addSubview(View {name = "contentView"})
  self.selected = false
  self.highlighted = false
end

-- special config before reusing
function Cell:prepareForReuse()
  -- reset state
  self.selected = false
  self.highlighted = false
end

function Cell:applyLayout(layout)
  ReusableView.applyLayout(self, layout)
  self.background.width = layout.width - 2
  self.background.height = layout.height - 2
  self.background.y = self.background.height * .5
  self.background.x = self.background.width * .5
  local imageView = display.newImageRect( self.bounds, self.image, self.background.width, self.background.height )
  imageView.x = imageView.contentWidth * .5
  imageView.y = imageView.contentHeight * .5
  self.imageView = imageView
end

function Cell:setSeleted(selected)
  -- change appearance on selection changes
end

return Cell