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
  self.view = nil

  -- config navigation item for navigation bar
  local navigationItem = opt.navigationItem or NavigationItem { 
    name = self.name, title = self.title:upper(),
    hidesBackButton = opt.hidesBackButton,
  }
  self.navigationItem = navigationItem

  -- implement UIs before present
  function self:loadView()
    self.view = View {
      name = self.name,    
      height = ACH,
      backgroundColor = {204, 204, 204, 255}, -- #ccc
    }
    print("setup view")
  end

  function self:unloadView()
    local view = self.view
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
  end
end

return ViewController