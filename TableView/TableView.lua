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

local function offsetForSection(index)
  --section.bounds.yMin - self.background.bounds.yMin
end

-- ------
-- Configuring a Table View
-- ------

function TableView:setDataSource(data)
  if not type(data) == "table" then return false end
  if #data > 0 then
    self.dataSource = data
  end
end

function TableView:setHeaderView(opt)
  if self.header then self.header:removeSelf() end
  self.header = display.newGroup()
  local label = display.newText(opt.labelText or "table header", 0, 0, system.FontBold, 20)
  label.x = self.background.x
  self.header:insert(label)
end

function TableView:setFooterView(opt)
end

-- ------
-- Creating Table View Cells
-- ------

function TableView:headerInSection(section)
  local header = display.newGroup()
  local label = display.newText(header, section.labelText, 0, 0, system.FontBold, 20)
  label:setReferencePoint(display.CenterReferencePoint)
  label.y = label.contentHeight*.5
  section.headerView = header
  section.headerTitle = label
  section.headerHeight = label.contentHeight
end

function TableView:sectionForIndex(index)
  local sectionData = self.dataSource[index]
  local section = display.newGroup()
  section.labelText = sectionData.labelText
  self:headerInSection(section)
end

-- ------
-- Accessing Header and Footer Views
-- ------

-- ------
-- Scrolling the Table View
-- ------

-- ------
-- Managing Selections
-- ------

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

function TableView:insertRowsAtIndexPath(indexPath)
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


return TableView