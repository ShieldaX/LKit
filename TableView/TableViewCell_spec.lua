-----------------------------------------------------------------------------------------
--
-- TableViewCell_spec.lua
--
-----------------------------------------------------------------------------------------

local util = require 'util'
local ts = require 'spec_runner'
local Scroll = require 'Scroll'
--local TableView = require 'TableView'
local TableViewCell = require 'TableViewCell'

local VCW = display.viewableContentWidth
local VCH = display.viewableContentHeight

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
      {text = "United States"},
      {text = "Canada"},
    },
  }

ts.desc("#Instance constructor")
ts.regist(0, function()
    ts.cell = TableViewCell {
        name = "testTable",
        text = "North America",
        y = 20,
        hightlightedColor = {142, 142, 147, 255},
    } 
end, "create a table view")

ts.desc("#Response to user's action'")
ts.regist(1, function()
    ts.cell:setHighlighted(true)
    assert(ts.cell.highlighted == true)
end, "set highlighted")

ts.regist(1, function()
    ts.cell:setHighlighted(false)
    assert(ts.cell.highlighted == false)
end, "cancell highlighted")

return ts