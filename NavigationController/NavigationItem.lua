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

local iconInfo = {
  width = 40,
  height = 40,
  numFrames = 20,
  sheetContentWidth = 200,
  sheetContentHeight = 160
}

NavigationItem.static.icons = graphics.newImageSheet("assets/ios7icons.png", iconInfo)

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
  local text = opt.title or opt.name
  local title = display.newText {
    parent = bounds,
    x = display.contentCenterX, y = self.background.contentHeight*.5,
    text = text,
    font = self.class.font,
    fontSize = 20,
    align = "center"
  }
  title:setTextColor(0, 0, 0, 255)
  self.titleView = title
  self.leftButtons = {}
  self.rightButtons = {}
  self.rightButton = self.rightButtons[1]
  
  local backButton = display.newImageRect(bounds, self.class.icons, 14, 40, 40)
  backButton.y = self.background.contentHeight*.5
  backButton.x = backButton.contentWidth*.4
  --backButton.isVisible = false
  self.backButton = backButton
end

function NavigationItem:setTintColor(color)
  -- body
end

return NavigationItem