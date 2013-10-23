-----------------------------------------------------------------------------------------
--
-- TableView_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local Scroll = require 'Scroll'
local TableView = require 'TableView'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

local dataSource = {
    header = {labelText = "Country List"}
    {
      labelText = "Asia",
      {text = "China"},
      {text = "Korea"},
      {text = "Japan"},
      {text = "India"},
    },
    {
      labelText = "North America",
      {text = "United States"},
      {text = "Canada"},
    },
  }

ts.desc("#Instance constructor")
ts.regist(0, function()
    local tableView = TableView {
        name = "testTable",
        backgroundColor = {255, 255, 255, 255},
      }
    tableView:setDataSource(dataSource)
    util.print_r(tableView.dataSource)
end, "create a table view")

ts.desc("#Index section and row")
ts.regist(0, function()
end, "number of sections")

ts.regist(0, function()
end, "number of rows in section")

ts.desc("#Elements organization")
ts.regist(0, function()
end, "insert sections")

ts.regist(1, function()
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