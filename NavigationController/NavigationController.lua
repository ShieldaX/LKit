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
  self.backController = nil
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
  
  local rootController = ViewController {name = opt.name, title = opt.title, hidesBackButton = true}
  self:pushController(rootController, false)
end

-- Push new controller to top of stack
function NavigationController:pushController(controller, animated)
  local controllers = self.controllers
  table.insert(controllers, controller)
  self.backController = self.topController
  self.topController = controller
  
  -- load view before moving
  controller:loadView()
  local view = controller.view
  self.view:addSubview(view)
  controller:appear()

  local function hidesBackController()
    if self.backController then
      self.backController:disappear()
    end
  end

  -- navigation bar
  if controller.navigationItem then
    --print("pushing navigation item")
    self.navigationBar:pushItem(controller.navigationItem, animated)
  end

  -- moving horizontal
  if animated == true then
    self.tween = transition.from(view.frame, {x = view.frame.contentWidth, transition = easing.inOutExpo, onComplete = hidesBackController})
  else
    hidesBackController()
  end

  self.visibleController = controller
end

function NavigationController:popController(animated)
  local controllers = self.controllers
  assert(#controllers > 1, "ERROR: Try to pop the last view controller")
  
  -- remove top controller
  local controller = table.remove(controllers)

  -- move index back
  self.topController = controllers[#controllers]
  self.backController = controllers[#controllers - 1] --nil if #controllers == 1

  local function switchController()
    controller:finalize()
    self.topController:appear()
  end

  -- frame need will move out
  local frame = controller.view.frame

  -- navigation bar
  --print("popping navigation item")
  self.navigationBar:popItem(animated)

  -- moving horizontal
  if animated == true then
    --transition.cancel("navigationTween")
    self.tween = transition.to(frame, {x = frame.contentWidth, transition = easing.inOutExpo, onComplete = switchController})
  else
    switchController()
  end

  self.visibleController = self.topController
end

function NavigationController:rootController()
  return self.controllers[1]
end

function NavigationController:popToController(controller, animated)
  -- body
end

function NavigationController:popToRootController(animated)
  -- body
end

return NavigationController