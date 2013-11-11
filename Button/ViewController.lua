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
  assert(type(opt.title) == "string", "Error: title expects a string value, got "..type(opt.title))
  local view = require(opt.viewClass)
  self:include(view)
  self.view = self:loadView()
  self.title = opt.title 

end

function ViewController:loadView()
  return View {name = self.title}
end

return ViewController