-- DataSource.lua
-- ------------------

local util = require 'util'

local DataSource = {
  --data = {{}},
}

function  DataSource:numberOfSections()
  return #self.data
end

function DataSource:numberOfItemsInSection(index)
  return #self.data[index]
end

function DataSource:heightForItemAtIndexPath(indexPath)
  local section = indexPath.section
  local row = indexPath.row
  local raw = self.data[section][row]
  return math.floor(raw.height*(self.columnWidth/raw.width))
end

function DataSource:rawForItemAtIndexPath(indexPath)
  local section = indexPath.section
  local row = indexPath.row
  return self.data[section][row]
end

function DataSource:imageForItemAtIndexPath(indexPath)
  local raw = self:rawForItemAtIndexPath(indexPath)
  return raw.image
end

function DataSource:cellForItemAtIndexPath(indexPath)
  local reuseIdentifier = self.reuseIdentifierForCell
  local cell = self:dequeueReusableCellForIndexPath(reuseIdentifier, indexPath)
  -- set properties that correspond to the data of the corresponding item
  -- ...
  cell.image = self:imageForItemAtIndexPath(indexPath)
  return cell
end

function DataSource:included(class)
  print("DataSource module included")
end

return DataSource