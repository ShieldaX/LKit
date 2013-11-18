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
  ReusableView.prepareForReuse(self)
  -- reset state
  self.selected = false
  self.highlighted = false
  self:setSelected(false)
end

function Cell:applyLayout(layout)
  ReusableView.applyLayout(self, layout)

  self._bounds = {
    yMin = layout.y,
    yMax = layout.y + layout.height,
    xMin = layout.x,
    xMax = layout.x + layout.width,
  }

  self.background.width = layout.width
  self.background.height = layout.height
  self.background.y = self.background.height * .5
  self.background.x = self.background.width * .5
  if self.imageView then self.imageView:removeSelf() end
  local imageView = display.newImageRect( self.bounds, self.image, self.background.width - 2, self.background.height -2 )
  imageView.x = imageView.contentWidth * .5
  imageView.y = imageView.contentHeight * .5
  self.imageView = imageView
end

function Cell:setSelected(selected)
  -- change appearance on selection changes
  if selected then
    self:setBackgroundColor({0, 122, 255})
    self.selected = true
  else
    self:setBackgroundColor({142, 142, 147})
    self.selected = false
  end
end

return Cell