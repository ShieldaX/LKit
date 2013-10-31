-- DataSource.lua
-- DataSource Class, provide data for data consumer.
-- Parser data from JSON file, updatable in time.
-- Support data reloading.
-- ------

local class = require "middleclass"

-- ======
-- CLASS
-- ======
local DataSource = class "DataSource"

-- ======
-- VARIABLES
-- ======

DataSource.static._version = "0.0.1"

-- ======
-- FUNCTIONS
-- ======


-- Instance Method
function DataSource:initialize(opt)
  self.data = opt.data
  self.defaultSectionHeaderHeight = 22
  self.defaultSectionFooterHeight = 22
  self.defaultRowHeight = 43
end

function DataSource:initWithData(data)
  assert(type(data) == "table", "WARNING: data must be wrapped in a table")
  self:initialize({data = data})
end

-- number of element

function DataSource:numberOfSections()
  return #self.data
end

function DataSource:numberOfRowsInSection(index)
  index = tonumber(index)
  assert(index > 0 and index <= self:numberOfSections(), "ERROR: Tring to retrive section with invalid index number")
  return #self.data[index]
end

-- dimension of element

function DataSource:heightForHeaderInSection(index)
  if self:titleForHeaderInSection(index) then
    return self.defaultSectionHeaderHeight
  end
  return 0
end

function DataSource:heightForFooterInSection(index)
  if self:titleForFooterInSection(index) then
    return self.defaultSectionFooterHeight
  end
  return 0
end

function DataSource:heightForRowAtIndexPath(path)
  local section, row = path.section, path.row
  if section and row then
    assert( row > 0 and row <= self:numberOfRowsInSection(section), "ERROR: The indexPath is over range")
    local sectionData = self.data[section]
    if sectionData then
      local rowData = sectionData[row]
      if rowData then
        return rowData.height or self.defaultRowHeight
      end
    end
  end
  assert(false, "invalid indexPath")
end

-- content provider

function DataSource:titleForHeaderInSection(index)
  local section = self.data[index]
  if section then return section.titleHeader end
end

function DataSource:titleForFooterInSection(index)
  local section = self.data[index]
  if section then return section.titleFooter end
end

function DataSource:textForRowAtIndexPath(indexPath)
  local section, row = indexPath.section, indexPath.row
  if section and row then
    local sectionData = self.data[section]
    if sectionData then
      local rowData = sectionData[row]
      if rowData then
        return rowData.text
      end
    end
  end
  return ""
end

-- update and reload

-- @merge True for merge rows in, false for add new sections
function DataSource:updateWith(data, merge)
  -- table.remove from new data
  -- table.insert to origin data
  -- dispatchEvent({name = "dataUpdate"})
end

function DataSource:reload()
end

return DataSource