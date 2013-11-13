-----------------------------------------------------------------------------------------
--
-- CollectionView_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local d = util.print_r
local ts = require 'spec_runner'
local DataSource = require 'DataSource'
local CollectionView = require 'CollectionView'
util.hide_fps()

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#initialize")

return ts