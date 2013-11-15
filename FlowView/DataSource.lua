-- DataSource.lua
-- ------------------

local util = require 'util'

local DataSource = {
  data = {{}},
}

function  DataSource:numberOfSections()
  return #self.data
end

function DataSource:numberOfItemsInSection(index)
  return #self.data[index]
end

function DataSource:cellForItemAtIndexPath(indexPath)
  local cell = dequeueReusableCellforIndexPath(reuseIdentifier, indexPath)
  -- set properties that correspond to the data of the corresponding item
  -- ...
  return cell
end

function DataSource:columnIndexForIndexPath(indexPath)
  local cols = self.numberOfColumns
  local row = indexPath.row
  local colNum = math.fmod(row, cols)
  return colNum == 0 and cols or colNum
end

function DataSource:included(class)
  print("DataSource module included")
end

return DataSource