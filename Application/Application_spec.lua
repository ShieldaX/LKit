-----------------------------------------------------------------------------------------
--
-- Application_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local Application = require 'Application'
local Toast = require 'Toast'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()

    Application {name = "Mobile"}

    local app = Application.sharedApplication()

    function app:onStart()
      print("application started ...")
    end

    Runtime:addEventListener("system", app)
    util.print_r(app)
    ts.app = app
end, "get instance")

ts.regist(0, function()
    Application {name = "Fake App"}
    local fakeApp = Application.sharedApplication()
    util.print_r(fakeApp)
    assert(fakeApp == ts.app)
end, "keep singleton")

ts.desc("#test for notification system")
ts.regist(0, function()
    Toast.text("aaa", Toast.Length.Short)
end, "show toast notification")

ts.regist(2, function()
    Toast.text("toggle display", Toast.Length.Long)
end, "show toast notification")

return ts