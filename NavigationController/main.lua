-- main.lua

local util = require 'util'
util.show_fps()

local spec = require "NavigationBar_spec"
--local spec = require "NavigationItem_spec"
spec.run()