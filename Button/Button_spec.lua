-----------------------------------------------------------------------------------------
--
-- Button_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'
local Button = require 'Button'
local Label = require 'Label'
local Input = require 'Input'

--local VCW = display.viewableContentWidth
--local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    local bg = View {
      name = "background",
      backgroundColor = {255, 255, 255},
      yOffset = 100,
      xOffset = 100,
    }
    local simpleButton = Button {
      name = "simple",
      width = 100, height = 40,
      --x = display.contentCenterX,
      --y = display.contentCenterY
    }
    bg:addSubview(simpleButton)
    ts.button = simpleButton
end, "create a new button instance")

ts.regist(1, function()
    --ts.button:setStateDisabled()
end)

ts.regist(2, function()
    --ts.button:setStateNormal()
end)

ts.regist(2, function()
    --ts.button:setStatePressed()
end)

ts.desc("#control state")
ts.regist(0, function()
    local sampleLabel = Label {
      name = "sample",
      text = "Control State",
      align = "left",
      width = 200,
    }

    function sampleLabel:release(action)
      print("perform action")
      self:setText("State "..action.name)
    end

    ts.label = sampleLabel    
end, "create sample label")

ts.regist(1, function()
    local text = "State Normal >>"
    ts.label:setText(text)
end, "set label's content")

ts.regist(1, function()
    local sampleObj = {type = "object"}

    function sampleObj:release(action)
      print(self.type .. " perform " .. action.name)
    end
    ts.button:addTarget(ts.label, "release")
    ts.button:addTarget(sampleObj, "release")
end, "button add target")

ts.regist(1, function()
    ts.input = Input {
      name = "test",
      x = 10,
      y = display.contentCenterY,
      --cornerRadius = 5,
    }
end, "build text input field")

ts.regist(1, function()
    local inputFrame = ts.input.frame
    transition.to(inputFrame, {time = 200, delta = true, y = 20})
end, "translate input view")

ts.regist(1, function()
    local inputFrame = ts.input.frame
    transition.to(inputFrame, {time = 400, delta = false, y = 40, transition = easing.outQuad})
end, "translate input view")

return ts