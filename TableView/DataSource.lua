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
  self.defaultSectionHeaderHeight = 0
  self.defaultSectionFooterHeight = 0
  self.defaultRowHeight = 40
  self.font = {
    section = {
      header = { size = 24, font = native.systemFont },
      Footer = { size = 24, font = native.systemFont }
    },
    row = { size = 20, font = native.systemFontBold }
  }
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
  assert(index > 0 and index < self:numberOfSections(), "WARNING: Tring to retrive section with invalid index number")
  return #self.data[index]
end

-- dimension of element

function DataSource:heightForHeaderInSection(index)
  if self:titleForHeaderInSection() then
    return 30
  end
end

function DataSource:heightForFooterInSection(index)
  if self:titleForHeaderInSection() then
    return 30
  end
end

function DataSource:heightForRowAtPath(path)
  local section, row = path.section, path.row
  if section and row then
    local sectionData = self.data[section]
    if sectionData then
      local rowData = sectionData[row]
      if rowData then
        return rowData.height or self.defaultRowHeight
      end
    end
  end
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

-- update and reload

-- @merge True for merge rows in, false for sections addition
function DataSource:updateWith(data, merge)
  -- table.remove from new data
  -- table.insert to origin data
  -- dispatchEvent({name = "dataUpdate"})
end

return DataSource