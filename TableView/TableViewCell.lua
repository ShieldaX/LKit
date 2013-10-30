-- TableViewCell.lua
-- cell view for table view section
-- ------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- cg stretcher
local stretch = {}
function stretch.heightTo(displayObject, height)
  --TODO: stretch content height to target
  displayObject.height = height or displayObject.height
  -- object always expand or shrink the object from the center, so caculate the offset to set
  displayObject.y = displayObject.contentHeight*.5
end

--[[
local imageRectForImageView
function replaceImageWith(view, imagePath)
  local width, height = view.contentWidth, view.contentHeight
  display.newImageRect(view.parent, imagePath, view.x - width*.5, view.y - height*.5, width, height)
  view.isVisible = false
end
]]

-- ======
-- CLASS
-- ======
--local TableViewSectionLabel = CellView:subclass('TableViewSectionLabel')
local TableViewCell = View:subclass('TableViewCell')

-- ======
-- VARIABLES
-- ======

TableViewCell.static.defaultRowHeight = 43

-- ======
-- FUNCTIONS
-- ======

function TableViewCell:initialize(opt)
  opt.height = opt.height or TableViewCell.defaultRowHeight  
  View.initialize(self, opt)
  self.highlightedColor = opt.hightlightedColor or {142, 142, 147, 255}
  local bounds = self.bounds
  self:setBackgroundColor({255, 255, 255, 255})
  
  -- Frame dimensions
  local rect = self.frame
  local contentHeight, contentWidth = rect.contentHeight, rect.contentWidth
  
  -- highlighted background
  local highlighted = display.newRect(bounds, 0, 0, contentWidth, contentHeight)
  highlighted:setFillColor(unpack(self.highlightedColor))
  highlighted.isVisible = false
  self.highlightedBackground = highlighted
  
  -- main text label
  local text = display.newText("  " .. opt.text, 0, 0, native.systemFont, 17)
  text:setReferencePoint(display.CenterReferencePoint)
  text:setTextColor({255, 255, 255})
  bounds:insert(text)
  text.x, text.y = text.contentWidth*.5, contentHeight*.5 -- position in content bounds
  self.textLabel = text
  
  -- each table cell should has a separator
  -- Note: Use native display line object always cause a dimension problem( double bigger 
  -- than expected ), so use rect with 1px in height instead.
  --local separator = display.newLine( bounds, 0, contentHeight-1, contentWidth, contentHeight-1 )
  local separator = display.newRect( bounds, 0, contentHeight - 1, contentWidth, 1 )
  separator:setFillColor(153, 158, 165)
  self.separator = separator
  
  -- selection state
  self.selected = false
  self.highlighted = false
  self.identifier = opt.identifier --reusble identifier
end

function TableViewCell:setLabelText(text)
  text = text or ""
  if self.textLabel then
    local textLabel = self.textLabel
    textLabel.text = "  " .. text
    textLabel.x = textLabel.contentWidth*.5
  else
    print("WARNING: no main textLabel found")
  end
end

function TableViewCell:setHeight(height) 
  local delta = height - self.background.height
  print("stretching height by", delta)
  stretch.heightTo(self.background, height)
  stretch.heightTo(self.highlightedBackground, height)
  local contentHeight = self.background.contentHeight
  self.separator.y = contentHeight - self.separator.contentHeight*.5
  self.textLabel.y = contentHeight*.5
end

-- ---
-- Manage seletion state
-- ---

-- set cell's highlighted status
function TableViewCell:setHighlighted()
  self.highlightedBackground.isVisible = self.highlighted
end

function TableViewCell:updateSelectionState()
end

function TableViewCell:prepareForReuse()
  self:updateSelectionState()
  print("I am ready to reuse now!")
end

function TableViewCell:removeFromSuperview()
  -- remove self holding components
  self.highlightedBackground, self.highlightedColor, self.separator, self.textLabel, self.identifier = nil

  View.removeFromSuperview(self)
end

return TableViewCell