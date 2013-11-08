-----------------------------------------------------------------------------------------
--
-- NavigationController_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local NavigationItem = require 'NavigationItem'
local NavigationController = require 'NavigationController'

--local VCW = display.viewableContentWidth
--local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    local controller = NavigationController {
      name = "follow",
      title = "My Follow",
    }
end, "create a new navigation controller")

return ts