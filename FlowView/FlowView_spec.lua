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

  local data = {{
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

  FlowView.data = data
  ts.view = flow
end, "new flow view")

ts.regist(0, function()
  local flow = ts.view
  flow:prepareLayout()
  flow:visibleCells()
end)

return ts