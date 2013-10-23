-- main.lua

local util = require 'util'
util.show_fps()

local specRunner = require "TableView_spec"
specRunner.run()