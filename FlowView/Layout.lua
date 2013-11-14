-- Layout.lua
-- Abstract: Provide information about the position and visual state of items in the view.
-- ------------------

local util = require 'util'

local Layout = {
  layout = {{}}
}

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

function Layout:invalidateWithContext(context)
end

function Layout:included(class)
  print("layout module included")
end

local Attributes = {}

function Attributes.new()
  local instance = {
    indexPath = {1, 0}
    zIndex = 0,
    alpha = 1,
    x = 0, y = 0, -- position
    xScale = 1, yScale = 1, -- transform
  }

  function instance:isEqual(object)
    -- compare
  end

  return instance
end

return Layout