-- TableViewSectionLabel.lua
-- label view for table view section
-- ------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
--local Label = require 'Label'

-- ======
-- CLASS
-- ======
--local TableViewSectionLabel = Label:subclass('TableViewSectionLabel')
local TableViewSectionLabel = View:subclass('TableViewSectionLabel')

function TableViewSectionLabel:initialize(opt)
  opt.width = opt.width or 200
  opt.height = opt.height or 40
  View.initialize(self, opt)
  local bounds = self.bounds  
  local rectWidth, rectHeight = self.background.contentWidth, self.background.contentHeight  
  local startColor, endColor = {144, 158, 171}, {185, 193, 201}
  local gradient = graphics.newGradient(startColor, endColor, "down")
  local rect = display.newRect( bounds, 0, 0, rectWidth, rectHeight )
  rect:setFillColor(gradient)
  rect.alpha = 1
  local shadow = display.newLine( bounds, 0, rect.contentHeight - 1, rect.contentWidth, rect.contentHeight - 1)
  shadow.width = 1
  shadow.setColor({153, 158, 165})
  
  local text = display.newText("  " .. opt.text, 0, 0, native.systemFont, 24)
  text:setReferencePoint(display.CenterReferencePoint)
  bounds:insert(text)
  text.x, text.y = text.contentWidth*.5, rectHeight*.5
  self.textView = text
end

function TableViewSectionLabel:setText(text)
  -- change text property
  -- reposition it
end

function TableViewSectionLabel:setFontStyle(font, size)
end

return TableViewSectionLabel