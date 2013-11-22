-----------------------------------------------
-- @class: Toast
-- @file Toast.lua - v0.0.1 (2013-11)
-- 
-----------------------------------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'

-- ======
-- CLASS
-- ======
local Toast = class 'Toast'

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentHeight
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

-- ======
-- VARIABLES
-- ======

Toast.static.Position = {
  Bottom = {x = display.contentCenterX, y = display.contentHeight-display.screenOriginY-128},
  Top = {x = display.contentCenterX, y = 128+display.screenOriginY},
  Center = {x = display.contentCenterX, y = display.contentCenterY}
}

Toast.static.EdgeInset = {
  top = 10,
  left = 20,
  bottom = 12,
  right = 22,
}

local background = display.newRoundedRect(0, 0, 20, 20, 4)
background:setFillColor(0, 0, 0, 200)
background.strokeWidth = 1
background:setStrokeColor(142, 142, 147, 100)
background.x = Toast.Position.Bottom.x
background.y = Toast.Position.Bottom.y

local textContent = display.newText {
  text = "--",
  font = native.systemFontBold,
  fontSize = 14,
  align = "center",
  x = background.x, y = background.y,
}

textContent:setTextColor(255, 255, 255, 200)

background.alpha = 0
textContent.alpha = 0

local gte = 400
local _lastTime = os.clock()*1000 - gte

-- ======
-- FUNCTIONS
-- ======

local function updateBackgroundBounds(textWidth, textHeight)
  assert(textWidth and textHeight)
  local edgeInset = Toast.EdgeInset
  background.width = textWidth + edgeInset.left + edgeInset.right
  background.height = textHeight + edgeInset.top + edgeInset.bottom
end

local function show()
  if Toast.tweenB then transition.cancel( Toast.tweenB ) end
  if Toast.tweenT then transition.cancel( Toast.tweenT ) end
  background.alpha = 1
  textContent.alpha = 1
  _lastTime = os.clock()*1000
end

local function dismiss(delay)
  --if Toast.tweenB then transition.cancel( Toast.tweenB ) end
  Toast.tweenB = transition.to(background, {delay = delay, time = gte, transition = easing.inQuad, alpha = 0})
  Toast.tweenT = transition.to(textContent, {delay = delay, time = gte, transition = easing.inQuad, alpha = 0})
end

local function isFrequent()
  print(os.clock()*1000 - _lastTime)
  return os.clock()*1000 - _lastTime < gte
end

-- ------
-- Initializing a Toast Object
-- ------

--- Instance constructor
-- @param text Text Content to show. [string]
-- @param *time Optional timer to dismiss toast view. [positive number greater than 1]
function Toast.text(text, time)
  if isFrequent() then return end
  text = type(text) == "string" and text or "--"
  local time = tonumber(time)
  time = time and time > 1 and time or 2000
  if not text then
    text = "width: " .. textContent.contentWidth .. ", " .. "height: " .. textContent.contentHeight 
  end
  textContent.text = text
  local textWidth, textHeight = textContent.contentWidth, textContent.contentHeight
  updateBackgroundBounds(textWidth, textHeight)
  show()
  dismiss(time)
end

-- ======
-- EXECUTIONS
-- ======

updateBackgroundBounds(textContent.contentWidth, textContent.contentHeight)

return Toast