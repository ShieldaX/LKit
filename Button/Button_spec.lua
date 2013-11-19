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

ts.desc("#control state")
ts.regist(0, function()
    local sampleLabel = Label {
      name = "sample",
      text = "Controll State",
      width = 200, height = 200,
    }

    function sampleLabel:release(action)
      print("perform action")
      self:setText("State "..action.name)
    end

    ts.label = sampleLabel    
end, "create sample label")

ts.regist(1, function()
    local text = "State Normal"
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

ts.regist(0, function()
    local inputField = Input {
      name = "userField",
      x = 50,
      y = display.contentCenterY,
      width = 80, height = 30,
    }
end, "create input view")

return ts