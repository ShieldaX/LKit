-- main.lua

local util = require 'util'
util.show_fps()

local specRunner = require "Scroll_spec"
specRunner.run()