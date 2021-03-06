-----------------------------------------------------------------------------------------
--
-- DataSource_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local d = util.print_r
local ts = require 'spec_runner'
local DataSource = require 'DataSource'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

local dataSource = {
	{image = "photos/Biloxi05.jpg", width = 1024, height = 683},
	{image = "photos/Arch01.jpg", width = 680, height = 1024},
	{image = "photos/Butterfly01.jpg", width = 1024, height = 682},
	{image = "photos/DSC6722.jpg", width = 1024, height = 689},
	{image = "photos/DSC_7743.jpg", width = 1024, height = 686},
	{image = "photos/ElCap.jpg", width = 1024, height = 686},
	{image = "photos/FlaKeysSunset.jpg", width = 1024, height = 686},
	{image = "photos/MaimiSkyline.jpg", width = 1024, height = 819},
	{image = "photos/MtRanier8x10.jpg", width = 1024, height = 819},
	{image = "photos/Tulip.jpg", width = 658, height = 1024},
	{image = "photos/WhiteTiger.jpg", width = 1024, height = 683},
	{image = "photos/Yosemite Valley.jpg", width = 1024, height = 686},
	{image = "photos/Yosemite2013_Mule_Deer04.jpg", width = 1024, height = 680},
	{image = "photos/bfly2.jpg", width = 1024, height = 819},
	{image = "photos/bodieIsland.jpg", width = 1024, height = 819},
}

ts.desc("#Instance constructor")
ts.regist(0, function()
    local source = DataSource:new({data = dataSource})
    d(source.data)
    ts.source = source
end, "create a datasource")

ts.regist(1, function()
    print(ts.source.columnWidth)
    print(ts.source:heightForRowAtIndexPath({section = 1, row = 2}))
end)

return ts