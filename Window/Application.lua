-----------------------------------------------
-- @class: Application (singleton)
-- @file Application.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
--local Window = require 'Window'

-- ======
-- CLASS
-- ======
local Application = class 'Application'
local sharedApplication

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

-- Internal identifier

-- ======
-- FUNCTIONS <TASKS>
-- ======

-- Get the shared instance
function Application.sharedApplication(opt)
  if not sharedApplication then Application:new(opt) end
  return sharedApplication
end

-- ------
-- @task Task description
-- ------

--- Instance constructor
-- Because Application is singleton, use Application.sharedApplication to retrieve application instance
function Application:initialize(api)
  if sharedApplication then return end -- singleton

  api = api or {}
  local opt = {}
  opt.name = api.name or "applicationObject"
  print("instantiation application named", opt.name)

  local app = {name = opt.name} -- singleton object
  --app.window = opt.window or Window { name = "mainWindow" }
  
  -- system event router
  function app:system(event)
    local type = event.type
    if type == "applicationStart" then
      self:_start()
    elseif type == "applicationSuspend" then
      self:_suspend()
    elseif type == "applicationResume" then
      self:_resume()
    elseif type == "applicationExit" then
      self:_exit()
    elseif type == "applicationOpen" then -- iOS only
      self:_openUrl(event.url)
    end
  end

  function app:_callback(functionName, params)
    local callback = self[functionName]
    if callback and type(callback) == "function" then
      callback(self, params)
    end
  end

  function app:_start()
    print("")
    print("==========================")
    print("== Dulcinea Application ==")
    print("==========================")
    print("")
    self:_callback("onStart")
  end

  function app:_suspend()
    print("== Application Suspend ==")
    self:_callback("onSuspend")
  end

  function app:_resume()
    print("== Application Resume ==")
    self:_callback("onResume")
  end

  function app:_exit()
    self:_callback("onExit")
    print("== Good Bye! ==")
  end

  function app:_open(url)
    print("Application requests URL:")
    print(url)
  end

  sharedApplication = app
end

return Application