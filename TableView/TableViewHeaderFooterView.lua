-- TableViewHeaderFooterView.lua
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
--local TableViewHeaderFooterView = Label:subclass('TableViewHeaderFooterView')
local TableViewHeaderFooterView = View:subclass('TableViewHeaderFooterView')

function TableViewHeaderFooterView:initialize(opt)
  opt.width = opt.width
  opt.height = opt.height or 22
  View.initialize(self, opt)
  self.reuseIdentifier = opt.reuseIdentifier
  local bounds = self.bounds
  
  local rect = self.frame
  local contentHeight, contentWidth = rect.contentHeight, rect.contentWidth
  
  local startColor, endColor = {144, 158, 171}, {185, 193, 201}
  local gradient = graphics.newGradient(startColor, endColor, "down")
  --[[
  local rectTint = display.newRect( bounds, 0, 0, contentWidth, contentHeight )
  rectTint:setFillColor(gradient)
  rectTint.alpha = 1
  ]]
  self:setBackgroundColor(gradient)
  
  local text = display.newText(bounds, "  " .. opt.text, 0, 0, native.systemFont, 17)
  --text:setReferencePoint(display.CenterReferencePoint)
  --bounds:insert(text)
  text.x, text.y = text.contentWidth*.5, contentHeight*.5
  self.textLabel = text
  
  local shadow = display.newRect( bounds, 0, contentHeight - 1, contentWidth, 1)
  shadow:setFillColor(153, 158, 165)
end

function TableViewHeaderFooterView:setText(text)
  text = text or ""
  if self.textLabel then
    local textLabel = self.textLabel
    textLabel.text = "  " .. text
    textLabel.x = textLabel.contentWidth*.5
  else
    print("WARNING: no main textLabel found")
  end
end

function TableViewHeaderFooterView:prepareForReuse()
  print("I am ready to reuse now!")
end

return TableViewHeaderFooterView