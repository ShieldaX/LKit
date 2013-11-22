-----------------------------------------------------------------------------------------
--
-- CollectionView_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local d = util.print_r
local ts = require 'spec_runner'
local FlowView = require 'FlowView'
local Cell = require 'Cell'
--util.hide_fps()

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

ts.desc("#initialize")
ts.regist(0, function()
      ts.data = {{
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
        --
        {image = "photos/FlaKeysSunset.jpg", width = 1024, height = 686},
        {image = "photos/MaimiSkyline.jpg", width = 1024, height = 819},
        {image = "photos/MtRanier8x10.jpg", width = 1024, height = 819},
        {image = "photos/Tulip.jpg", width = 658, height = 1024},
        {image = "photos/Biloxi05.jpg", width = 1024, height = 683},
        {image = "photos/Arch01.jpg", width = 680, height = 1024},
        {image = "photos/Butterfly01.jpg", width = 1024, height = 682},
        {image = "photos/DSC6722.jpg", width = 1024, height = 689},
        {image = "photos/ElCap.jpg", width = 1024, height = 686},
        {image = "photos/FlaKeysSunset.jpg", width = 1024, height = 686},
        {image = "photos/MaimiSkyline.jpg", width = 1024, height = 819},
        --
        {image = "photos/FlaKeysSunset.jpg", width = 1024, height = 686},
        {image = "photos/MaimiSkyline.jpg", width = 1024, height = 819},
        {image = "photos/MtRanier8x10.jpg", width = 1024, height = 819},
        {image = "photos/Tulip.jpg", width = 658, height = 1024},
        {image = "photos/WhiteTiger.jpg", width = 1024, height = 683},
        {image = "photos/Arch01.jpg", width = 680, height = 1024},
        {image = "photos/Butterfly01.jpg", width = 1024, height = 682},
        {image = "photos/DSC6722.jpg", width = 1024, height = 689},
        {image = "photos/DSC_7743.jpg", width = 1024, height = 686},
        {image = "photos/MtRanier8x10.jpg", width = 1024, height = 819},
        {image = "photos/Yosemite Valley.jpg", width = 1024, height = 686},
        {image = "photos/Yosemite2013_Mule_Deer04.jpg", width = 1024, height = 680},
        {image = "photos/bfly2.jpg", width = 1024, height = 819},
        {image = "photos/bodieIsland.jpg", width = 1024, height = 819},
        {image = "photos/Biloxi05.jpg", width = 1024, height = 683},
      }}

      local flow = FlowView {
        name = "waterFall",
        numberOfColumns = 3,
      }

      ts.view = flow
end, "new flow view")

ts.regist(0, function()
      local flow = ts.view
      flow:setDataSource(ts.data)
      flow:visibleCells()
end)
--[[
ts.desc("#insert and delete")
ts.regist(2, function()
    -- insert data to view data source
    local flow = ts.view
    local data = flow.data
    local rows = data[1]
    d(flow.updatedLayout[1][2])
    table.insert(rows, 6, {image = "photos/WhiteTiger.jpg", width = 1024, height = 683})
    flow:updateLayout()
    d(flow.updatedLayout[1][2])

    flow:insertItemAtIndexPath({section = 1, row = 6})
end, "insert a new cell")
]]
return ts