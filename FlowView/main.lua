-- main.lua

local util = require 'util'
util.show_fps()

--local specRunner = require "DataSource_spec"
local specRunner = require "FlowView_spec"
specRunner.run()

--[[ test super call
local class = require 'middleclass'

local View = class 'View'

function View:initialize(api)
  self.x = api.x
end

function View:print_x()
  print(self.x)
end

local ViewGroup = View:subclass("ViewGroup")

function ViewGroup:initialize(api)
  View.initialize(self, api)
end

function ViewGroup:print_x()
  View.print_x(self)
  print("super called")
end

local aView = View {x = 10}

aView:print_x()

local aGroup = ViewGroup {x = 12}

aGroup:print_x()
]]