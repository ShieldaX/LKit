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
  self.navigationItem = NavigationItem { 
    name = "login", title = "SIGN IN",
    hidesBackButton = true,
  }
end

function ViewController:loadView()
  self.view = View {
    name = self.name,    
    height = ACH,
    backgroundColor = {204, 204, 204, 255}, -- #ccc
  }
end

return ViewController