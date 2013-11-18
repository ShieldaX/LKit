-- FlowView.lua
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
local scroller = require 'scroller'
local Layout = require 'Layout'
local DataSource = require 'DataSource'
local Cell = require 'Cell'

-- ======
-- CLASS
-- ======
local FlowView = View:subclass('FlowView')
FlowView:include(Layout)
FlowView:include(DataSource)
FlowView:include(scroller)
FlowView.static.friction = 0.94
FlowView.static.scrollStopThreshold = 250

-- ======
-- FUNCTIONS
-- ======

local function boundsIntersect(bounds, bounds1)
  return bounds.yMax >= bounds1.yMin and bounds.xMax >= bounds1.xMin and bounds.yMin <= bounds1.yMax and bounds.xMin <= bounds1.xMax
end

--- Instance constructor
-- @param api Intent table for construct new instance.
function FlowView:initialize(api)
  View.initialize(self, api)
  self.direction = api.direction -- scroll direction
  self.numberOfColumns = api.numberOfColumns
  self.indexPathsForSelectedItems = {}
  self.indexPathsForHighlightedItems = {}
  self.reusableCells = {}
  self.visibleItems = {}
  self.reuseIdentifierForCell = "flowCell"
  self.reusableCells[self.reuseIdentifierForCell] = {}
end

function FlowView:setDataSource(data)
  self.data = data
  self:prepareLayout()
  self.frame:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

function FlowView:dequeueReusableCellForIndexPath(reuseIdentifier, indexPath)
  local reusableCells = self.reusableCells
  local possibleCells = reusableCells[reuseIdentifier]
  if possibleCells and #possibleCells > 0 then
    print("reuse cell")
    local cell = table.remove( possibleCells, 1 ) -- first in, first out
    cell:prepareForReuse()
    cell.name = indexPath.section .. '_' .. indexPath.row
    return cell
  end
  local newCell = Cell {
    name = indexPath.section .. '_' .. indexPath.row,
    reuseIdentifier = reuseIdentifier
  }
  print("create new cell")
  return newCell
end

function FlowView:invalidateLayout()
  self.layout = nil
  -- 
end

function FlowView:_queueReusableCells()
  local visibleBounds = {
    yMin = - self.bounds.y,
    yMax = - self.bounds.y + self.background.contentHeight,
    xMin = - self.bounds.x,
    xMax = - self.bounds.x + self.background.contentWidth
  }
  local visibleItems = self.visibleItems
  local reuseIdentifier = self.reuseIdentifierForCell
  local reusableCells = self.reusableCells[reuseIdentifier]
  table.foreach(visibleItems, function(i, item)
    local bounds = item._bounds
    if not boundsIntersect(bounds, visibleBounds) then
      -- cell not visible
      --print(item.name, "cell not visible")
      reusableCells[#reusableCells + 1] = item
      item:removeFromSuperview()
      item.name = nil
      visibleItems[i] = nil
    end
  end)
end

function FlowView:visibleCells()
  local visibleBounds = {
    yMin = - self.bounds.y,
    yMax = - self.bounds.y + self.background.contentHeight,
    xMin = - self.bounds.x,
    xMax = - self.bounds.x + self.background.contentWidth
  }
  local visibleItems = self.visibleItems
  --util.print_r(visibleBounds)
  local visibleItemsLayout = self:layoutForItemsInBounds(visibleBounds)
  table.foreach(visibleItemsLayout, function(_, layout)
    local indexPath = layout.indexPath
    local name = indexPath.section .. '_' .. indexPath.row
    if not self[name] then
      local cell = self:cellForItemAtIndexPath(indexPath)
      cell:applyLayout(layout)
      self:addSubview(cell)
      visibleItems[#visibleItems + 1] = cell -- cell visible
    end
  end)

  return visibleItems
end

function FlowView:touch(event)
  self:handleScrollTouch(event)
  local contentView = self.bounds
  local phase = event.phase
  if phase == "began" then
    -- set selected indexPath
    -- convert point to local
    local x, y = contentView:contentToLocal(event.x, event.y)
    local indexPathTouched = self:indexPathForItemAtPoint({x = x, y = y})
    util.print_r(indexPathTouched)
    local cell = self[indexPathTouched.section .. '_' .. indexPathTouched.row]
    cell:setSelected(true)
  elseif self.tracking then
    if "moved" == phase then

    elseif "ended" == phase or "cancelled" == phase then

    end
  end
end

function FlowView:enterFrame(event)
  -- queue reusable cell (with reuseIdentifier)
  self:_queueReusableCells()
  self:visibleCells()
  if self.isLayoutInvalid then
    -- invalidation loop
    self:invalidateLayout()
    self.isLayoutInvalid = false
  end
  self:handleScrolling(event)
  --self:handleScrolling(event)
end

return FlowView