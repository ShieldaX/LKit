-----------------------------------------------
-- @class: ViewController
-- @file ViewController.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local NavigationController = require 'NavigationController'
local NavigationItem = require 'NavigationItem'

-- ======
-- CLASS
-- ======
local ViewController = class 'ViewController'

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
-- Initializing a View Controller
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function ViewController:initialize(opt)
  assert(type(opt.title) == "string", "ERROR: title expects a string value, got "..type(opt.title))
  self.name = opt.name
  self.title = opt.title
  self.view = nil -- UI
  self.parentController = nil -- The container view controller this is contained in.
  self.presentedController = nil -- The view controller that is presented by this view controller.
  self.presentingController = nil -- The view controller that presented this view controller.
  self.navigationController = nil -- The nearest ancestor in the view controller hierarchy that is a navigation controller. Set by navigation contoller itself while pushing.

  -- config navigation item for navigation bar
  local navigationItem = opt.navigationItem or NavigationItem { 
    name = self.name, title = self.title:upper(),
    hidesBackButton = opt.hidesBackButton,
  }
  self.navigationItem = navigationItem

  -- implement UIs before present
  function self:loadView()
    if self.view then return print("View already exists") end
    self.view = View {
      name = self.name,
      height = ACH,
      backgroundColor = {204, 204, 204, 255}, -- #ccc
    }
    print("setup view")
  end

  function self:unloadView()
    local view = self.view
    -- remove view from super controller's container view
    if view then view:removeFromSuperview() end
    self.view = nil
  end

  -- take view (from background) to foreground
  function self:appear()
    print(self.name, "show now!")
  end

  -- send view to background
  function self:disappear()
    print(self.name, "being invisible...")
  end

  -- stop function in memory
  function self:finalize()
    print(self.name, "finalizing...")
    if self.superController then
      self.superController = nil
    end
  end

  --[[ Get the nearest ancestor in the view controller hierarchy that is a navigation controller.
  function self:getNavigationController()
    local parentController = self.parentController
    while parentController do
      if Object.isInstanceOf(parentController, NavigationController) then
        return parentController
      else
        parentController = parentController.parentController
      end
    end
  end
  ]]
end

return ViewController