-- main.lua

local util = require 'util'
util.show_fps()

local specRunner = require "TableView_spec"
--local specRunner = require "TableViewCell_spec"
specRunner.run()