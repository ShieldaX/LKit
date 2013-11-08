-----------------------------------------------
-- @class: NavigationBar
-- @file NavigationBar.lua - v0.0.1 (2013-09)
-- Container view controller with a controller stack.
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local NavigationBar = require 'NavigationBar'
local NavigationItem = require 'NavigationItem'
local ViewController = require 'ViewController'

-- ======
-- CLASS
-- ======
local NavigationController = class("NavigationController")

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

NavigationController.static.pushPopDistance = CW
NavigationController.static.pushPopDuration = 400 -- time for pushing and popping animation

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Object
-- ------

--- Instance constructor
function NavigationController:initialize(opt)
  self.controllers = {} -- contollers table
  self.topController = nil
  self.visibleController = nil
  self.popGesture = opt.popGesture

  -- container view
  self.view = View {
    name = "navigation",
    backgroundColor = {255, 255, 255, 0},
    y = SOY,
    height = ACH,
  }

  local navigation = opt.navigation or {name = "navigator"}
  self.navigationBar = NavigationBar:new(navigation)
  self.view.frame:insert(self.navigationBar.frame)
  self.navigationBar.frame.y = 0
  
  local rootController = ViewController {name = opt.name, title = opt.title}
  self:pushController(rootController, false)
end

function NavigationController:pushController(controller, animated)
  local controllers = self.controllers
  table.insert(controllers, controller)
  self.topController = controller
  
  controller:loadView()
  local view = controller.view
  util.print_r(view.background.contentBounds)
  self.view:addSubview(view)
  
  -- navigation bar
  if controller.navigationItem then
    print("pushing navigation item")
    self.navigationBar:pushItem(controller.navigationItem, true)
  end

  -- moving horizontal
  if animated == true then
    self.tween = transition.to(view.frame, {x = 0, transition = easing.inOutExpo})
  else
    --view.frame.x = 0
  end

  self.visibleController = controller
end

function NavigationController:popController(animated)
  -- body
end

function NavigationController:popToController(controller, animated)
  -- body
end

function NavigationController:popToRootController(animated)
  -- body
end

return NavigationController