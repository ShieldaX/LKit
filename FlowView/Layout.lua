-- Layout.lua
-- Abstract: Provide information about the position and visual state of items in the view.
-- ------------------

local util = require 'util'

local Layout = {
  layout = {{}}, -- layout attributes table before view update.
  updatedLayout = {{}}, -- layout attributes table shall the view apply in next invalidation cycle.
}

function Layout:prepareLayout()
  self.interSpacing = 12
  self.columnWidth = math.floor(display.viewableContentWidth/self.numberOfColumns)
  print("columnWidth:", self.columnWidth)
  local numberOfItems = self:numberOfItemsInSection(1)
  self.columnHeights = {{}} -- table records column heights
end

function Layout:updateLayout()
  local columnHeights = self.columnHeights
  local numberOfItems = self:numberOfItemsInSection(1)
  for i = 1, numberOfItems do
    local itemHeight
    self:heightForItemAtIndexPath({section = 1, row = i})
    
  end
end

function  Layout:contentSize()
  -- used for scrolling limitation and so on
end

function Layout:layoutForItemAtIndexPath(indexPath)
end

function Layout:layoutForItemInBounds(bounds)

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
    elseif action == "reload"
      context.cusorIndexPath = pathAfter
    else
    end
  end)
  -- provide invalidation contexts
end

function Layout:finalizeViewUpdates()
  -- perform final animations ...
end

-- Forces the collection view to recompute all of its layout information and reapply it.
function Layout:invalidateLayout()
  -- 
end

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
  print("layout module included")
end

return Layout