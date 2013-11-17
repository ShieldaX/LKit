-- Layout.lua
-- Abstract: Provide information about the position and visual state of items in the view.
-- ------------------

local util = require 'util'
local d = util.print_r

local Layout = {
  --layout = {{}}, -- layout attributes table before view update.
  --updatedLayout = {{}}, -- layout attributes table shall the view apply in next invalidation cycle.
}

local function boundsIntersect(bounds, bounds1)
  return bounds.yMax >= bounds1.yMin and bounds.xMax >= bounds1.xMin and bounds.yMin <= bounds1.yMax and bounds.xMin <= bounds1.xMax
end

function Layout:prepareLayout()
  self.interSpacing = 12
  self.columnWidth = math.floor(display.viewableContentWidth/self.numberOfColumns)
  print("columnWidth:", self.columnWidth)
  --local numberOfItems = self:numberOfItemsInSection(1)
end

function Layout:updateLayout()
  local updated = {{}}
  local columnWidth = self.columnWidth
  -- build table of columnHeights
  local columnHeights = {}
  for i = 1, self.numberOfColumns do
    columnHeights[i] = 0
  end

  self.contentHeight = 0

  local numberOfItems = self:numberOfItemsInSection(1)
  for i = 1, numberOfItems do
    -- set focus on shortest column
    local cursorColumn = 1 -- default cursor is 1st column
    local shortestColumnHeight = math.huge
    for i = 1, #columnHeights do
      if columnHeights[i] < shortestColumnHeight then
        cursorColumn = i -- update column cursor
        shortestColumnHeight = columnHeights[i] -- update shortest column height
      end
    end

    -- ask for item height
    local section = 1
    local row = i
    local indexPath = {section = section, row = row}
    local itemHeight = self:heightForItemAtIndexPath(indexPath)

    -- update layout attributes for item
    local layout = {
      indexPath = indexPath,
      width = columnWidth,
      height = itemHeight,
      x = (cursorColumn - 1) * columnWidth,
      y = columnHeights[cursorColumn],
    }
    updated[section][row] = layout

    -- update cursor column height
    columnHeights[cursorColumn] = columnHeights[cursorColumn] + itemHeight
    --TODO: column height contains vertical spacing
    --columnHeights[cursorColumn] = columnHeights[cursorColumn] + self.interSpacing
    if self.contentHeight < columnHeights[cursorColumn] then
      self.contentHeight = columnHeights[cursorColumn] -- update content height
    end
  end

  if self.updatedLayout then self.updatedLayout = nil end
  self.updatedLayout = updated
end

function  Layout:contentSize()
  -- used for scrolling limitation and so on
  return {width = self.contentWidth, height = self.contentHeight}
end

function Layout:layoutForItemAtIndexPath(indexPath)
  if not self.layout then
    self:updateLayout()
    self.layout = self.updatedLayout
  end
  return self.layout[indexPath.section][indexPath.row]
end

function Layout:layoutForItemsInBounds(bounds)
  if not self.layout then
    self:updateLayout()
    self.layout = self.updatedLayout
  end

  local items = {}
  table.foreach(self.layout[1], function(_, layout)
    local itemBounds = {yMin = layout.y, yMax = layout.y + layout.height, xMin = layout.x, xMax = layout.x + layout.width}
    -- filter items
    if boundsIntersect(itemBounds, bounds) then
      items[#items+1] = layout
    end
  end)
  return items
end

-- ---
-- layout information to reflect view updating
-- ---

function Layout:layoutForAppearingItem(indexPath)
end

function Layout:layoutForDisappearingItem(indexPath)
end

-- @params updateItems Table of UpdateItem objects
function Layout:prepareForViewUpdates(updateItems)
  -- collect update inform with updateItems
  local contex = {}
  table.foreach(updateItems, function(_, item)
    local pathBefore = item.indexPathBeforeUpdate
    local pathAfter = item.indexPathAfterUpdate
    local action = item.updateAction
    if action == "insert" and pathAfter then
      context.cusorIndexPath = pathAfter
    elseif action == "delete" and pathBefore then
      context.cusorIndexPath = pathBefore
    elseif action == "move" and pathBefore and pathAfter then
      context.cusorIndexPath = pathAfter
    elseif action == "reload" then
      context.cusorIndexPath = pathAfter
    else
    end
  end)
  -- provide invalidation contexts
end

function Layout:finalizeViewUpdates()
  -- perform final animations ...
end

--[[ Forces the collection view to recompute all of its layout information and reapply it.
function Layout:invalidateLayout()
  -- 
end
]]
-- @param context An invalidation context lets you specify which parts of the layout changed.
-- The layout object can then use that information to minimize the amount of data it recomputes.
function Layout:invalidateWithContext(context)
end

-- transition between layouts
function Layout:offsetForProposedOffset(proposedOffset)
end

-- make the scrolling behavior to snap to specific boundaries
function Layout:offsetForProposedOffsetWithScrollingVelocity(proposedOffset, velocity)
end

function Layout:included(class)
  print("Layout module included")
end

return Layout