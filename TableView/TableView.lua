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
local Scroll = require 'Scroll'
local DataSource = require 'DataSource' -- TODO: include as a module
local TableViewCell = require 'TableViewCell'
local TableViewSectionLabel = require 'TableViewSectionLabel'

-- ======
-- CLASS
-- ======
local TableView = Scroll:subclass('TableView')

-- ======
-- CONSTANTS
-- ======

--local ACW = display.actualContentWidth
--local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a TableView Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function TableView:initialize(opt)
  Scroll.initialize(self, opt)
  self.sections = {}
  self.header = nil -- table header
  self.footer = nil -- table footer
  self._reusableCells = {} -- request element with special reuseIdentifier
  self._availableCells = {} -- insert all cached elements for reusing
  self.selectedRow = nil -- indexPath point to selected row
  self.highlightedRow = nil -- indexPath point to row should be highlighted
  self.dataSource = nil
end

-- ------
-- Configuring a Table View
-- ------

-- ------
-- Creating Table View Cells
-- ------

function TableView:headerInSection(index)
  local section = self:sectionForIndex(index)
  if not section.headerView then
    local header = TableViewSectionLabel {
      name = "headerView",
      y = 0,
      text = self.dataSource:titleForHeaderInSection(index),
    }    
    section:insert(header.frame)
    section.headerView = header
  end
  return section.headerView
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
  local dataSource = self.dataSource
  if section and row then
    local group = self:sectionForIndex(section)
    local offset = self:offsetToRowAtIndexPath(indexPath)
    local reuseIndentifier = "reuseCellInSection"..section
    local cell = self:dequeueReusableCell(reuseIndentifier)
    if not cell then
      cell = TableViewCell {
        name = section .. '_' .. row, -- 2D naming, using underscore to separate [11][3] from [1][13]
        text = dataSource:textForRowAtIndexPath(indexPath),
        y = offset,
        height = dataSource:heightForRowAtIndexPath(indexPath),
        identifier = reuseIndentifier
      }      
      table.insert(self._availableCells, cell)
    end
    group:insert(cell.frame)
    return cell
  end
end

-- Request a resuable table cell with special indentifier
-- @param reuseIndentifier String already defined on table creation.
function TableView:dequeueReusableCell(reuseIndentifier)
  local reusableCells = self._reusableCells
  table.foreach(reusableCells, function(i, cell)
    -- return the first finding
    if cell.identifier == reuseIndentifier then
      return table.remove(reusableCells, i)
    end
  end)
end

function TableView:_queueReusableCells()
  -- local threshold = 20
  local reusableCells = self._reusableCells
  -- update visible bounds
  local visibleBounds = self.background.contentBounds
  local yMin = visibleBounds.yMin
  local yMax = visibleBounds.yMax
  -- loop through currently available cells
  local availableCells = self._availableCells
  table.foreach(availableCells, function(i, cell)
    local cellBounds = cell.frame.contentBounds
    if cellBounds.yMax < yMin or cellBounds.yMin > yMax then
      if cell.identifier then
        table.insert(reusableCells, table.remove(availableCells, i))
        print("Cell "..cell.identifier.." became reusable.")
      else
        print("Cell not reusable will remove cell...")
        table.remove(availableCells, i)
        cell.frame:removeSelf()
      end
    end
  end)
end

-- ------
-- Accessing Header and Footer Views
-- ------

function TableView:setHeaderView(opt)
  
  if self.header then self.header:removeSelf() end -- clear previous header view
  -- build new header with options
  self.header = display.newGroup()
  local label = display.newText(opt.labelText or "table header", 0, 0, system.FontBold, 20)
  label.x = self.background.x
  self.header:insert(label)
  
  self.bounds:insert(self.header)
end

function TableView:setFooterView(opt)
  --[[
  if self.footer then self.footer:removeFromSuperview() end
  local footer = View {
    name = "footer",
    height = self.defaultHeaderHeight or 40,
    Label {
      name = "label",
      text = opt.labelText or "Footer",
      size = 20
    }
  }
  self:addSubview(header)
  ]]
end

-- ------
-- Scrolling the Table View
-- ------

function TableView:indexPathsForVisibleRows()
  -- update visible limit
  local yMin = - self.bounds.y
  local yMax = yMin + self.background.contentHeight
  return self:indexPathsForRowsInBounds({yMin = yMin, yMax = yMax})
end

-- update visible cells on demand
function TableView:visibleCells()
  local cells = {}
  local indexPaths = self:indexPathsForVisibleRows()
  table.foreach(indexPaths, function(_, indexPath)
    cells[#cells+1] = self:cellForRowAtIndexPath(indexPath)
  end)
  return cells
end

function TableView:visibleSections()  
  -- update visible limit
  local yMin = - self.bounds.y
  local yMax = yMin + self.background.contentHeight
  
  local offset = 0
  -- loops throw sections
  for s = 1, self.dataSource:numberOfSections() do
    offset = self:offsetToSection(s) -- reset offset base at every begining
    -- check rects intersection
    local bottomOffset = self:offsetToSection(s+1)
    if bottomOffset >= yMin and offset <= yMax then
      -- section is visible, show its header
      local header = self:headerInSection(s)
      --[[
      if header then
        --header.frame:toFront()
        local bottomLine = yMin
        local inset = yMin - offset
        if inset >= 0 and bottomOffset - yMin >= header.frame.contentHeight then
          header.frame.y = inset
        else
        end
      end
      ]]
    end
  end
end

-- ------
-- Managing Selections
-- ------

function TableView:indexPathForRowAtPoint(point)
  local possiblePaths = self:indexPathsInBounds({yMin = point.y, yMax = point.y, xMin = point.x, xMax = point.x})
  return #possiblePaths > 0 and possiblePaths[1]
end

-- ------
-- Inserting, Deleting, and Moving Rows and Sections
-- ------

-- @param sections Target Indexes to insert new sections
function TableView:insertSections(sections)
  local _sections = self.sections
  for index in pairs(sections) do
    self:sectionForIndex(index)
    
    table.insert(_sections, index, section)
  end
end

-- @param animation Define animation will be used while insertion
function TableView:insertRowsAtIndexPaths(indexPaths, animation)
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

function TableView:setDataSource(data)
  local Object = class.Object
  assert(Object.isInstanceOf(data, DataSource), "ERROR: data is not a valid DataSource instance")
  if self.dataSource then
    self.dataSource = nil -- unload previous dataSource    
  end
  self.dataSource = data
end

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

function TableView:indexPathsForRowsInBounds(bounds)
  local yMin = bounds.yMin
  local yMax = bounds.yMax
  local dataSource = self.dataSource
  local indexPaths = {}
  local offset = 0
  
  -- loops throw sections
  for s = 1, dataSource:numberOfSections() do
    offset = self:offsetToSection(s) -- reset offset base at every begining
    -- check rects intersection ?
    if self:offsetToSection(s+1) >= yMin and offset <= yMax then
      -- checking each rows
      for r = 1, dataSource:numberOfRowsInSection(s) do
        local indexPath = {section = s, row = r}
        local rowTop = offset + self:offsetToRowAtIndexPath(indexPath)
        local rowBottom = rowTop + dataSource:heightForRowAtIndexPath(indexPath)
        -- collect or discard (intersect? )
        if rowBottom >= yMin and rowTop <= yMax then
          indexPaths[#indexPaths+1] = indexPath
        elseif rowBottom > yMax then
          break
        end
      end
    end
  end
  
  return indexPaths
end

return TableView