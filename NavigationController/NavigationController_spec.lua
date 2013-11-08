-----------------------------------------------------------------------------------------
--
-- NavigationController_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local View = require 'View'
local NavigationItem = require 'NavigationItem'
local NavigationController = require 'NavigationController'
local ViewController = require 'ViewController'

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentHeight
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY
local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#Instance constructor")
ts.regist(0, function()
    local controller = NavigationController {
      name = "follow",
      title = "My Follow",
    }
    ts.ctrl = controller
end, "init a new navigation controller with root controller")

ts.regist(2, function()
    local clipContoller = ViewController {
      name = "clip",
      title = "clip",      
    }
    function clipContoller:loadView()
      self.view = View {
        name = self.name,
        height = ACH,
        backgroundColor = {142, 142, 147}
      }
    end
    ts.ctrl:pushController(clipContoller, true)
end)

return ts