-- main.lua

local util = require 'util'
util.show_fps()

--local specRunner = require "DataSource_spec"
local specRunner = require "CollectionView_spec"
specRunner.run()