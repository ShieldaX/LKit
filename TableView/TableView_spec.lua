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
      {text = "China"},
      {text = "Korea"},
      {text = "Japan"},
      {text = "India"},
    },
    {
      titleHeader = "North America",
      {text = "America"},
      {text = "Canada"},
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

ts.regist(1, function()
    local tableView = ts.table
    --[[

    tableView:cellForRowAtIndexPath({section = 1, row = 1})
    tableView:cellForRowAtIndexPath({section = 1, row = 2})
    tableView:cellForRowAtIndexPath({section = 1, row = 3})
    tableView:cellForRowAtIndexPath({section = 1, row = 4})
    tableView:headerInSection(2)
    tableView:cellForRowAtIndexPath({section = 2, row = 1})
    tableView:cellForRowAtIndexPath({section = 2, row = 2})
    ]]
    tableView:headerInSection(1)
    tableView:visibleCells()
    util.print_r(tableView.bounds.numChildren)
    print(tableView.touch)
end, "insert rows in sections")

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

return ts