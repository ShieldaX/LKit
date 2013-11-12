-----------------------------------------------
-- @class: NavigationItem
-- @file NavigationItem.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local NavigationItem = View:subclass("NavigationItem")

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

-- ======
-- VARIABLES
-- ======

if system.getInfo("platformName") == "Android" then
  NavigationItem.static.font = "Droid Sans"
  NavigationItem.static.fontBold = "Droid Sans Bold"
  NavigationItem.static.fontItalic = "Droid Sans"
  NavigationItem.static.fontBoldItalic = "Droid Sans Bold"
else
  NavigationItem.static.font = "HelveticaNeue-Light"
  NavigationItem.static.fontBold = "HelveticaNeue"
  NavigationItem.static.fontItalic = "HelveticaNeue-LightItalic"
  NavigationItem.static.fontBoldItalic = "Helvetica-BoldItalic"
end

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function NavigationItem:initialize(opt)
  --assert(type(opt.title) == "string", "Title is undefined")
  opt.width = CW
  opt.height = 50
  opt.backgroundColor = {255, 255, 255, 0} -- force display transparent background
  View.initialize(self, opt)
  local bounds = self.bounds
  
  -- title
  local text = opt.title or opt.name
  local title = display.newText {
    parent = bounds,
    x = display.contentCenterX, y = self.background.contentHeight*.5,
    text = text,
    font = self.class.font,
    fontSize = 20,
    align = "center"
  }
  self.tintColor = {0, 0, 0, 255}
  title:setTextColor(unpack(self.tintColor))
  self.titleView = title
  self.title = title.text
  
  -- bar buttons
  self.leftButtons = {}
  self.rightButtons = {}
  self.rightButton = self.rightButtons[1]
  self.leftButton = self.leftButtons[1]
  
  self.hidesBackButton = opt.hidesBackButton or false

  -- A Boolean value indicating whether the left items are displayed in addition to the back button.
  self.appendToBackButton = opt.appendToBackButton or true
end

-- ---
-- Customizing Views
-- ---
function NavigationItem:setLeftButton(button, animated)
  local leftButtons = self.leftButtons
  table.insert(leftButtons, 1, button)
  self.leftButton = button
  button.frame.isVisible = false
  button.y = self.titleView.y
  button.x = button.frame.contentBounds*.5
  if animated == true then
    
  end
end

function NavigationItem:setTintColor(color)
  self.titleView:setTextColor(unpack(color))
  self.tintColor = color
end

return NavigationItem