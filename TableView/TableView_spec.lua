-----------------------------------------------------------------------------------------
--
-- TableView_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
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
      titleHeader = "Asia",
      {text = "China", height = 60},
      {text = "India"},
      {text = "Thailand"},
      {text = "Singapore"},
      {text = "Sri Lanka"},
      {text = "Malaysia"},
    },
    {
      titleHeader = "North America",
      {text = "America", height = 60},
      {text = "Canada"},
    },
    {
      titleHeader = "Europe",
      {text = "France", height = 60},
      {text = "England"},
      {text = "Germany"},
      {text = "Germany"},
      {text = "Spain"},
      {text = "Italy"},
      {text = "Portugal"},
      {text = "Greece"},
    },
  }

ts.desc("#Instance constructor")
ts.regist(0, function()
    local data = DataSource:new({data=dataSource})
    local tableView = TableView {
        name = "testTable",
        backgroundColor = {255, 255, 255, 255},
      }
    tableView:setDataSource(data)
    util.print_r(data.data)
    ts.table = tableView
end, "create a table view")

ts.desc("#Index section and row")
ts.regist(0, function()
    local number = ts.table.dataSource:numberOfSections()
    print(number)
end, "number of sections")

ts.regist(0, function()
    local tableView = ts.table
    print(tableView:offsetToRowAtIndexPath({section = 1, row = 3}))
end, "offset to row in section")

ts.desc("#Elements organization")
ts.regist(0, function()
    util.print_r(ts.table:indexPathsForVisibleRows())
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
    tableView:visibleCells()
    tableView:visibleSections()
    util.print_r(tableView.bounds.numChildren)
end, "insert rows in sections")

ts.regist(1, function()
    local tableView = ts.table
    print("offset to section 2 is", tableView:offsetToSection(2))
    print("offset to section 3 is", tableView:offsetToSection(3))
    --print("offset to section 4 is", tableView:offsetToSection(4))
end, "offset to special section")

ts.regist(0, function()
    local tableView = ts.table
    print("offset to row 1 in section 1 is", tableView:offsetToRowAtIndexPath({section = 1, row = 1}))
    print("offset to row 2 in section 1 is", tableView:offsetToRowAtIndexPath({section = 1, row = 2}))
    print("actual offset to row 2 in section 2 is", tableView:offsetToSection(2) + tableView:offsetToRowAtIndexPath({section = 2, row = 2}))
end, "offset to special row")

ts.regist(1, function()
    local tableView = ts.table
    local yMin = tableView:offsetToSection(1) + tableView:offsetToRowAtIndexPath({section = 1, row = 4})
    local yMax = tableView:offsetToSection(2) + tableView:offsetToRowAtIndexPath({section = 2, row = 3})
    print("yMin", yMin, "From top of row 4 in section 1")
    print("yMax", yMax, "To bottom of row 2 in section 2")
    util.print_r(tableView:indexPathsForRowsInBounds({yMin = yMin, yMax = yMax}))
end, "indexPaths For Rows In Bounds")

ts.regist(1, function()

end, "position section header")

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