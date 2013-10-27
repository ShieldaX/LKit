-----------------------------------------------
-- @class: TableView
-- @file TableView.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local DataSource = require 'DataSource'
local TableViewCell = require 'TableViewCell'
local TableViewSectionLabel = require 'TableViewSectionLabel'

-- ======
-- CLASS
-- ======
local TableView = View:subclass('TableView')

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

TableView.static.friction = 0.94
TableView.static.scrollStopThreshold = 250
-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a TableView Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function TableView:initialize(opt)
  View.initialize(self, opt)
  self.sections = {}
  self.header = nil
  self.footer = nil
  self._reusableCells = {} -- request element with special reuseId
  self.selectedRow = nil
  self.highlightedRow = nil
  self.dataSource = nil
end

-- ------
-- Configuring a Table View
-- ------

function TableView:setDataSource(data)
  -- if not data is class data source return
  self.dataSource = data
end

-- ------
-- Creating Table View Cells
-- ------

function TableView:headerInSection(index)
  local section = self:sectionForIndex(index)
  local header = TableViewSectionLabel {
    name = "headerView",
    y = 0,
    text = self.dataSource:titleForHeaderInSection(index),
  }
  
  section:insert(header.frame)
  section.headerView = header
  return header
end

-- Returns the table section at the specified index
function TableView:sectionForIndex(index)
  local sections = self.sections
  if not sections[index] then
    local section = display.newGroup()
    section.x = 0
    section.y = self:offsetToSection(index)
    self.bounds:insert(section)
    sections[index] = section
  end
  return sections[index]
end

-- Returns the table cell at the specified index path.
-- @param indexPath The index path locating the row in the table.
-- @return An object representing a cell of the table or nil if the cell is not visible or indexPath is out of range.
function TableView:cellForRowAtIndexPath(indexPath)
  local section, row = indexPath.section or 1, indexPath.row or 1
  -- TODO: is cell visible
  if section and row then
    local group = self:sectionForIndex(section)
    local offset, cell = self:offsetToRowAtIndexPath(indexPath)
    cell = TableViewCell {
      name = section .. '_' .. row, -- 2D naming, using underscore to separate [11][3] from [1][13]
      text = self.dataSource:textForRowAtIndexPath(indexPath),
      y = offset
    }
    --self:addSubview(cell)
    group:insert(cell.frame)
  end
end

-- ------
-- Accessing Header and Footer Views
-- ------

function TableView:setHeaderView(opt)
  
  if self.header then self.header:removeSelf() end
  self.header = display.newGroup()
  local label = display.newText(opt.labelText or "table header", 0, 0, system.FontBold, 20)
  label.x = self.background.x
  self.header:insert(label)
  
  --[[
  if self.header then self.header:removeFromSuperview() end
  local header = View {
    name = "header",
    height = self.defaultHeaderHeight or 40,
    Label {
      name = "label",
      text = opt.labelText or "Header",
      size = 20
    }
  }
  self:addSubview(header)
  ]]
end

function TableView:setFooterView(opt)
end

-- ------
-- Scrolling the Table View
-- ------

function TableView:indexPathsForVisibleRows()
  local visibleBounds = self.background.contentBounds
  local indexPaths = {}
  
  return indexPaths
end

function TableView:visibleCells()
  local cells = {}
  --table.insert(cells)
  return cells
end

-- ------
-- Managing Selections
-- ------

function TableView:indexPathsInBounds()
end

-- ------
-- Inserting, Deleting, and Moving Rows and Sections
-- ------

function TableView:insertSections(sections)
  local _sections = self.sections
  for index in pairs(sections) do
    self:sectionForIndex(index)
    
    table.insert(_sections, index, section)
  end
end

function TableView:insertRowsAtIndexPaths(indexPaths)
  assert(type(indexPath) == "table")
  local section, row = tonumber(indexPath.section), tonumber(indexPath.row)
  if section > 0 and row > 0 then
    local rowData = self.dataSource[section][row]
    if rowData then
      --row
    end
  end
end

-- ------
-- Reloading the Table View
-- ------

-- ------
-- Managing the Data Source
-- ------

-- ------
-- Accessing Drawing Areas of the Table View
-- ------

function TableView:offsetToSection(index)
  local data = self.dataSource
  local offset = 0
  for i = 1, index - 1 do
    offset = offset + data:heightForHeaderInSection(i) + data:heightForFooterInSection(i)
    for r = 1, data:numberOfRowsInSection(i) do
      offset = offset + data:heightForRowAtIndexPath({section = i, row = r})
    end
  end
  return offset
end

function TableView:offsetToRowAtIndexPath(indexPath)
  local data = self.dataSource
  local offset = 0
  local section, row = indexPath.section, indexPath.row
  offset = offset + data:heightForHeaderInSection(section)
  for i = 1, row - 1 do
    offset = offset + data:heightForRowAtIndexPath({section = section, row = i})
  end
  return offset
end

return TableView