-----------------------------------------------
-- @class: Input
-- @file Input.lua - v0.0.1 (2013-09)
-- wrapper of native input field
-- (Implement Reference)[http://www.coronalabs.com/blog/2013/12/03/tutorial-customizing-text-input]
-- TODO: Validate input text, basic validate types like numbers(phone, post, fax), names(first, last) and so on.
-----------------------------------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
--local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Input = View:subclass('Input')

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

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Input Control
-- ------

--- Instance constructor
-- @param api Intent table for construct new instance.
function Input:initialize(api)
  api.backgroundColor = api.backgroundColor or {255, 255, 255} -- override default value
  api.width = api.width or display.contentWidth*.75
  api.height = api.height or 20
  -- instantiation
  View.initialize(self, api)
  local bounds = self.bounds
  local frame = self.frame
  local width = frame.width
  local height = frame.height -- frame.height + 10
  
  api.cornerRadius = api.cornerRadius or height*.2
  api.font = api.font or native.systemFont

  self.background:removeSelf(); self.background = nil
  local background = display.newRoundedRect(bounds, 0, 0, width, height, api.cornerRadius)
  background.strokeWidth = api.strokeWidth or 2
  background:setFillColor(unpack(self.backgroundColor))
  background:setStrokeColor(unpack(api.strokeColor or {0, 0, 0}))
  self.background = background

  self.defaultText = api.defaultText or ""
  self.defaultColor = api.defaultColor or {0, 0, 0}
  self.inputColor = api.inputColor or self.defaultColor
  self.everInput = false

  -- layout real text field
  local field = native.newTextField( 0, 0, width - api.cornerRadius, height - background.strokeWidth*2)
  field.x = background.x
  field.y = background.y

  -- config text field
  field.font = native.newFont(api.font)
  field.inputType = api.inputType or "default"
  field.isSecure = api.isSecure
  field.hasBackground = false

  local deviceScale = ( display.pixelWidth / display.contentWidth ) * 0.5
  local fontSize = api.fontSize or height*.67
  field.size = fontSize*deviceScale
  
  self.bounds:insert(field)
  self.field = field

  -- placeholder 
  self:rollBack()

  field:addEventListener("userInput", self)
end

function Input:userInput(event)
  local phase = event.phase
  if phase == "began" then

    -- user begins editing textField
    if not self.everInput then self:onUserBeganInput() end
    -- scroll content up
    self:sendEvent({
      name = "inputBegan",
      target = self,
    })

  elseif phase == "ended" then

    -- textField loses focus
    -- roll back ?
    if self.field.text == '' then self:rollBack() end
    
    self:sendEvent({
      name = "inputEnded",
      target = self,
    })

    --native.setKeyboardFocus( nil )

    -- transfer input focus
  elseif phase == "submitted" then

    if self.field.text == '' then self:rollBack() end

    if not self.tween then
      self:sendEvent({
        name = "inputSubmitted",
        target = self,
      })
    end

    if self.nextFocus then
      native.setKeyboardFocus( self.nextFocus.field )
    elseif not self.tween then
      native.setKeyboardFocus( nil )
    end

  elseif phase == "editing" then

    print( event.newCharacters )
    print( event.oldText )
    print( event.startPosition )
    print( event.text )

    self:sendEvent({
      name = "inputEditing",
      target = self,
    })

  end
end

-- Roll input text back to default or none
-- rolling back only happened when there is no text and just losed focus by default.
function Input:rollBack(clear)
  self.field.text = clear == true and '' or self.defaultText
  self.field:setTextColor(unpack(self.defaultColor))
  self.everInput = false
end

function Input:onUserBeganInput()
  -- switch color
  self.field.text = ''
  self.field:setTextColor(unpack(self.inputColor))
  self.everInput = true
end

function Input:setText(text)
  assert(type(text) == "string")
  self.field.text = text
end

function Input:onValidate()
end

function Input:sendEvent(event)
  self.frame:dispatchEvent(event)
end

function Input:addTarget(obj, action)
  self.frame:addEventListener(action, obj)
  print("responses to", action)
end

function Input:removeTarget(obj, action)
  self.frame:removeEventListener(action, obj)
end

function Input:finalize()
  if self.field then self.field:removeSelf() end
  View.finalize(self)
end

return Input