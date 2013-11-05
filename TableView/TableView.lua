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
local TableViewHeaderFooterView = require 'TableViewHeaderFooterView'

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
  local headerFooterLayer = display.newGroup()
  headerFooterLayer.y = self.bounds.y
  self.frame:insert(headerFooterLayer)
  self.headerFooterView = headerFooterLayer
  self._reusableHeaderFooterViews = {}
  self.sections = {}
  self.header = nil -- table header
  self.footer = nil -- table footer
  self._reusableCells = {} -- request element with special reuseIdentifier
  self._availableCells = {} -- insert all cached elements for reusing
  self.selectedRow = nil -- indexPath point to selected row
  self.highlightedRow = nil -- indexPath point to row should be highlighted
  self.dataSource = nil
  self.stuckSectionHeader = opt.stuckSectionHeader or true -- section headers stick to the top by default for better UX
end

-- ------
-- Configuring a Table View
-- ------

-- ------
-- Creating Table View Cells
-- ------

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
  local section, row = indexPath.section, indexPath.row
  local dataSource = self.dataSource
  local availableCells = self._availableCells
  
  if section and row then
    
    local name = section .. '_' .. row -- 2D naming, using underscore to separate [11][3] from [1][13]
    if not availableCells[name] then -- if cell is not available
      local offset = self:offsetToRowAtIndexPath(indexPath)
      local reuseIdentifier = "reuseCellInSection"..section
      
      local cell = self:dequeueReusableCell(reuseIdentifier) -- request reusable cell instance
      
      if not cell then -- create new table cell instance
        cell = TableViewCell {
          name = name,
          text = dataSource:textForRowAtIndexPath(indexPath),
          y = offset,
          height = dataSource:heightForRowAtIndexPath(indexPath),
          identifier = reuseIdentifier
        }
        self:sectionForIndex(section):insert(cell.frame) -- display in right position
        --print("create new cell instance.")
      else
        --print("reuse a cell instance.")        
        cell.frame.y = offset
        cell:setHeight(dataSource:heightForRowAtIndexPath(indexPath))
        cell:setLabelText(dataSource:textForRowAtIndexPath(indexPath))
        -- cell:reuseForRowAtIndexPath(indexPath)
      end
      
      availableCells[name] = cell -- mark available at the same time
    end
    
    return availableCells[name]
  end
  
end

-- Request a resuable table cell with special indentifier
-- @param reuseIdentifier String already defined on instance creation.
-- @return A cell instance with the associated identifier or nil if no such instance exists in the reusableCells queue.
function TableView:dequeueReusableCell(reuseIdentifier)
  local reusableCells = self._reusableCells
  -- Try to find cell with reuseIdentifier
  local cell = reusableCells[reuseIdentifier]
  if cell then
    cell:prepareForReuse()
    reusableCells[reuseIdentifier] = nil
  end
  return cell
end

-- Mark rendered cells for reuse. With one reuse identifier at the same time,
-- there is only one cell marked for reuse.
function TableView:_queueReusableCells()
  local threshold = 0 -- TODO: implement reusableThreshold
  local reusableCells = self._reusableCells
  -- update visible bounds
  local visibleBounds = self.background.contentBounds
  local yMin = visibleBounds.yMin + threshold
  local yMax = visibleBounds.yMax - threshold
  -- loop through currently available cells
  local availableCells = self._availableCells
  table.foreach(availableCells, function(name, cell)
    local cellBounds = cell.frame.contentBounds

    --[cull cells
    if cellBounds.yMax < yMin or cellBounds.yMin > yMax then

      if cell.identifier then
        --table.insert(reusableCells, availableCells[name])
        local identifier = cell.identifier

        local previousCell = reusableCells[identifier]
        if previousCell then
          previousCell:removeFromSuperview()
          reusableCells[identifier] = nil
          previousCell = nil
          --print("Cell already exists has been removed.")
        end
        reusableCells[identifier] = cell -- apply new cell instance
        --print("Cell with "..identifier.." became reusable.")
      else
        --print("Cell not reusable will be removed...")
        cell:removeFromSuperview()
      end

      availableCells[name] = nil -- remove from availableCells anyway
    end
    -- cull cells]
  end)
end

-- ------
-- Accessing Header and Footer Views
-- ------

function TableView:headerInSection(index)
  local section = self:sectionForIndex(index)
  
  if not section.header then
    -- request reusble header any way
    local header = self:dequeueReusableHeaderFooterView("globalHeader")
    if not header then
      -- just create new header footer view instance
      header = TableViewHeaderFooterView {
        name = "header",
        --text = self.dataSource:titleForHeaderInSection(index),
        text = self.dataSource:titleForHeaderInSection(index),
        reuseIdentifier = "globalHeader",
        --y = self:offsetToSection(index),
      }
      self.headerFooterView:insert(header.frame)
      print("create new header instance")
    else
      print("reusing")
      -- reuse already rendered header footer view
      header:setText(self.dataSource:titleForHeaderInSection(index))      
      --header:setText("reused")  
    end
    section.header = header
  end
  local contentOffset = - self.bounds.y
  section.header.frame.y = self:offsetToSection(index) - contentOffset
end

function TableView:dequeueReusableHeaderFooterView(reuseIdentifier)
  local reusableHeaderFooterViews = self._reusableHeaderFooterViews
  local headerFooter = reusableHeaderFooterViews[reuseIdentifier]
  if headerFooter then
    headerFooter:prepareForReuse()
    reusableHeaderFooterViews[reuseIdentifier] = nil
  end
  return headerFooter
end

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

-- update visible cells on demand (Runtime, Touch ...)
function TableView:visibleCells()
  --local cells = {}
  local indexPaths = self:indexPathsForVisibleRows()
  table.foreach(indexPaths, function(_, indexPath)
    --cells[#cells+1] = self:cellForRowAtIndexPath(indexPath)
    self:cellForRowAtIndexPath(indexPath)
  end)
  --return cells
end

-- Display table sections via their header/footer.
function TableView:visibleSections()
  --TODO: merge this caculate into Runtime
  -- update visible limit
  local yMin = - self.bounds.y
  local yMax = yMin + self.background.contentHeight
  
  -- loops throw all sections
  for s = 1, self.dataSource:numberOfSections() do
    local top = self:offsetToSection(s)
    local bottom = self:offsetToSection(s+1)
    self:headerInSection(s)
    -- check rects intersection to determine visible or not
    if bottom >= yMin and top <= yMax then -- visible, show header
      local section = self:sectionForIndex(s)
      local header = section.header
      if top < yMin then
        -- top section header
        local headerHeight = self.dataSource:heightForHeaderInSection(s)
        if bottom >= yMin + headerHeight then
          header.frame.y = 0
          --print("stick header in section", s)
        else
          header.frame.y = bottom + self.bounds.y - headerHeight
          --print("pushing up")
        end
      end
    else -- not visible, but is possible both above and blow.
      local section = self:sectionForIndex(s)
      local header = section.header
      -- queue reusable header footer view
      if header then
        print("mark reusable")
        if not self._reusableHeaderFooterViews[header.reuseIdentifier] then
          self._reusableHeaderFooterViews[header.reuseIdentifier] = header
        end
        section.header = nil
      end
    end
  end
end

-- ------
-- Managing Selections
-- ------

function TableView:indexPathForRowAtPoint(point)
  local possiblePaths = self:indexPathsForRowsInBounds({yMin = point.y, yMax = point.y, xMin = point.x, xMax = point.x})
  return #possiblePaths > 0 and possiblePaths[1]
end

-- ------
-- Inserting, Deleting, and Moving Rows and Sections
-- ------

-- @param sections Target Indexes to insert new sections
function TableView:insertSections(sections, animation)
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
      print(r)
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