-----------------------------------------------------------------------------------------
--
-- Window_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local Application = require 'Application'
local Window = require 'Window'
local View = require 'View'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
  Application {name = "Mobile"}
  ts.window = Window {
    name = 'keyWindow',
    --backgroundColor = {255, 255, 255, 128},
  }
end, "Check window appearence")

ts.regist(1, function()
  ts.window:makeKeyAndVisible()
  assert(Application.sharedApplication().mainWindow)
end, "become key window")

return ts