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
}

ts.desc("#Instance constructor")
ts.regist(0, function()
    local source = DataSource:new({numberOfColumn = 3, data = dataSource})
    d(source.data)
    ts.source = source
end, "create a datasource")

ts.regist(0, function()
    local marginTop, viewHeight = display.screenOriginY, 220
    ts.collection = CollectionView {
      name = "collection",
      y = marginTop,
      yOffset = - display.screenOriginY,
      --height = viewHeight,
      --backgroundColor = {255, 255, 255, 255},
    }
    ts.collection:setDataSource(ts.source)
    --[[create debug overlay
    local overlayTop = display.newRect( 0, 0, display.viewableContentWidth, marginTop )
    local overlayBottom = display.newRect( 0, marginTop + viewHeight, display.viewableContentWidth, display.contentHeight - marginTop + viewHeight )
    overlayTop:setFillColor(0, 0, 0)
    overlayBottom:setFillColor(0, 0, 0)
    local transparent = 0.99
    overlayTop.alpha = transparent
    overlayBottom.alpha = transparent
    --overlayTop.strokeWidth = 1
    --overlayBottom.strokeWidth = 1
    --overlayTop:setStrokeColor(255, 0, 0)    
    --overlayBottom:setStrokeColor(255, 0, 0)
    --create debug overlay]]
end)

ts.regist(1, function()
  local collection = ts.collection
  d(collection:indexPathsForRowsInBounds({yMin = 100, yMax = 400}))
end, "visible rows")

ts.regist(1, function()
  --local collection = ts.collection
  print(display.screenOriginY)
end, "screen origin y")

return ts