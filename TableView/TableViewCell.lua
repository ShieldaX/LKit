-- TableViewCell.lua
-- cell view for table view section
-- ------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
--local TableViewSectionLabel = CellView:subclass('TableViewSectionLabel')
local TableViewCell = View:subclass('TableViewCell')

-- ======
-- VARIABLES
-- ======

TableViewCell.static.defaultRowHeight = 40

-- ======
-- FUNCTIONS
-- ======

function TableViewCell:initalize(opt)
  opt.height = opt.height or TableViewCell.defaultRowHeight
  View.initialize(self, opt)
  local bounds = self.bounds
  self:setBackgroundColor({255, 255, 255, 255})
  
  local rect = self.background
  -- each table cell should has a separator
  local separator = display.newLine( bounds, 0, rect.contentHeight - 1, rect.contentWidth, rect.contentHeight - 1)
  separator.width = 1
  separator.setColor({153, 158, 165})
  -- main text object
  local text = display.newText("  " .. opt.text, 0, 0, native.systemFont, 24)
  text:setReferencePoint(display.CenterReferencePoint)
  bounds:insert(text)
  text.x, text.y = text.contentWidth*.5, rectHeight*.5
  self.textView = text
end

function TableViewCell:prepareForReuse()
end

return TableViewCell