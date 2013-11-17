-- FlowView.lua
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local Layout = require 'Layout'
local DataSource = require 'DataSource'
local Cell = require 'Cell'

-- ======
-- CLASS
-- ======
local FlowView = View:subclass('FlowView')
FlowView:include(Layout)
FlowView:include(DataSource)

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
-- @param api Intent table for construct new instance.
function FlowView:initialize(api)
  View.initialize(self, api)
  self.direction = api.direction -- scroll direction
  self.numberOfColumns = api.numberOfColumns
  self.reusableCells = {}
  self.visibleItems = {}
end

function FlowView:dequeueReusableCellForIndexPath(reuseIdentifier, indexPath)
  local reusableCells = self.reusableCells
  local possibleCells = reusableCells[reuseIdentifier]
  if possibleCells and #possibleCells > 0 then
    print("reuse cell")
    local cell = table.remove( possibleCells, 1 )
    cell:prepareForReuse()
    return cell
  end
  local newCell = Cell {
    name = indexPath.section .. '_' .. indexPath.row,
    reuseIdentifier = reuseIdentifier
  }
  print("create new cell")
  return newCell
end

function FlowView:enterFrame(event)
  -- queue reusable cell (with reuseIdentifier)

  if self.isInvalid then
    -- invalidation loop
    self:invalidate()
    self.isInvalid = false
  end
end

function queueReusableCells()
  -- body
end

function FlowView:visibleCells()
  local visibleBounds = {
    yMin = - self.bounds.y,
    yMax = - self.bounds.y + self.background.contentHeight,
    xMin = - self.bounds.x,
    xMax = - self.bounds.x + self.background.contentWidth
  }
  util.print_r(visibleBounds)
  local visibleItems = self:layoutForItemsInBounds(visibleBounds)
  table.foreach(visibleItems, function(_, item)
    local cell = self:cellForItemAtIndexPath(item.indexPath)
    cell:applyLayout(item)
    self:addSubview(cell)
  end)
end

return FlowView