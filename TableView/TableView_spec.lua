-----------------------------------------------------------------------------------------
--
-- TableView_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local print_r = util.print_r
local ts = require 'spec_runner'
--local Scroll = require 'Scroll'
local TableView = require 'TableView'
local DataSource = require 'DataSource'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

display.setStatusBar(display.HiddenStatusBar)

local dataSource = {
    header = {labelText = "Country List"},
    {
      titleHeader = "Europe",
      {text = "Russia", height = 60},
      {text = "France"},
      {text = "England"},
      {text = "Germany"},
      {text = "Spain"},
      {text = "Italy"},
      {text = "Portugal"},
      {text = "Greece"},
      {text = "Netherlands"},
      {text = "Finland"},
    },
    {
      titleHeader = "Asia",
      {text = "China", height = 60},
      {text = "India"},
      {text = "Thailand"},
      {text = "Singapore"},
      {text = "Sri Lanka"},
      {text = "Malaysia"},
      {text = "Afghanistan"},
      {text = "Mongolia"},
      {text = "North Korea"},
      {text = "South Korea"},
      {text = "Turkey"},
    },
    {
      titleHeader = "America",
      {text = "United States", height = 60},
      {text = "Canada"},
      {text = "Mexico"},
      {text = "Brazil"},
      {text = "Cuba"},
      {text = "Greenland"},
      {text = "Jamaica"},
      {text = "Peru"},
      {text = "Colombia"},
      {text = "Argentina"},
    },
  }

ts.desc("#Instance constructor")
ts.regist(0, function()
    local data = DataSource:new({data=dataSource})
    local tableView = TableView {
        name = "testTable",
        backgroundColor = {255, 255, 255, 255},
        --y = 120,
        --height = 300,
      }
    tableView:setDataSource(data)
    --print_r(data.data)
    ts.table = tableView
    --[[create debug overlay
    local overlayTop = display.newRect( 0, 0, display.viewableContentWidth, 120 )
    local overlayBottom = display.newRect( 0, 420, display.viewableContentWidth, 60 )
    overlayTop:setFillColor(0, 0, 0)
    overlayBottom:setFillColor(0, 0, 0)
    local transparent = 1
    overlayTop.alpha = transparent
    overlayBottom.alpha = transparent
    overlayTop.strokeWidth = 1
    overlayBottom.strokeWidth = 1
    overlayTop:setStrokeColor(255, 0, 0)    
    overlayBottom:setStrokeColor(255, 0, 0)
    --create debug overlay]]
end, "create a table view")

ts.desc("#Index section and row")
ts.regist(0, function()
    local number = ts.table.dataSource:numberOfSections()
    print(number)
    local bottom = ts.table:offsetToSection(number + 1)
    print("scroll height should be", bottom)
end, "number of sections")

ts.regist(0, function()
    local tableView = ts.table
    print("offset to section 2 is", tableView:offsetToSection(2))
    print("offset to section 3 is", tableView:offsetToSection(3))
end, "offset to special section")

ts.regist(0, function()
    local tableView = ts.table
    print("offset to row 1 in section 1 is", tableView:offsetToRowAtIndexPath({section = 1, row = 1}))
    print("offset to row 2 in section 1 is", tableView:offsetToRowAtIndexPath({section = 1, row = 2}))
    print("actual offset to row 2 in section 2 is", tableView:offsetToSection(2) + tableView:offsetToRowAtIndexPath({section = 2, row = 2}))
end, "offset to special row")

ts.desc("#Elements organization")
ts.regist(0, function()
    print_r(ts.table:indexPathsForVisibleRows())
end, "visible rows")

ts.regist(0, function()
    local tableView = ts.table
    --[[
    tableView:cellForRowAtIndexPath({section = 1, row = 1})
    tableView:cellForRowAtIndexPath({section = 1, row = 2})
    tableView:cellForRowAtIndexPath({section = 1, row = 3})
    tableView:cellForRowAtIndexPath({section = 1, row = 4})    
    tableView:cellForRowAtIndexPath({section = 2, row = 1})
    tableView:cellForRowAtIndexPath({section = 2, row = 2})
    ]]
    --tableView:visibleCells()
    --tableView:visibleSections()
    print("visible section number")
    print_r(tableView.bounds.numChildren)
end, "visible elements rows in sections")

ts.regist(1, function()
    local tableView = ts.table
    --print(#tableView._availableCells)
end, "available cells number")

ts.regist(0, function()
    local tableView = ts.table
    local yMin = tableView:offsetToSection(1) + tableView:offsetToRowAtIndexPath({section = 1, row = 4})
    local yMax = tableView:offsetToSection(2) + tableView:offsetToRowAtIndexPath({section = 2, row = 3})
    print("yMin", yMin, "From top of row 4 in section 1")
    print("yMax", yMax, "To bottom of row 2 in section 2")
    local indexPaths = tableView:indexPathsForRowsInBounds({yMin = yMin, yMax = yMax})
    --assert(#indexPaths == 6)
    print_r(indexPaths)
end, "indexPaths For Rows In Bounds")

ts.desc("#interact with cell")
ts.regist(1, function()
    local tableView = ts.table
    local y = 85
    local testPoint = display.newCircle( 100, y, 2 )
    testPoint:setFillColor(255, 0, 0)
    ts.testIndexPath = tableView:indexPathForRowAtPoint({x = 100, y = y})
    print_r(ts.testIndexPath)
end, "indexPath at point")

ts.regist(1, function()
    local tableView = ts.table
    local cellPointed = tableView:cellForRowAtIndexPath(ts.testIndexPath)
    cellPointed:setHighlighted(true)
    ts.cellPointed = cellPointed
end, "cell at point")

ts.regist(1, function()
    ts.cellPointed:setHighlighted(false)
end, "unhighlighted")

--[[
ts.regist(1, function()
end, "move rows in sections")

ts.regist(2, function()
end, "move sections")

ts.regist(2, function()
end, "delete rows in sections")

ts.regist(1, function()
end, "delete sections")

ts.desc("#Focus and selection")
ts.regist(1, function()
end, "stuck top section's title header'")

ts.regist(4, function()
end, "report selection")
]]

return ts