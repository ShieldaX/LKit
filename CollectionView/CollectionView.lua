-- CollectionView.lua
-- ------------------

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
--local Scroll = require 'Scroll'
local TableView = require 'TableView'

-- ======
-- CLASS
-- ======
local CollectionView = TableView:subclass('CollectionView')

-- ======
-- FUNCTIONS
-- ======

--- Instance constructor
-- @param opt Intent table for construct new instance.
function CollectionView:initialize(opt)
  TableView.initialize(self, opt)
end

function CollectionView:offsetToSection(index)
  return 0
end

function CollectionView:sectionForIndex(index)
  local section = TableView.sectionForIndex(self, index)
  section.x = (index - 1) * self.columnWidth
  return section
end

function CollectionView:setDataSource(data)
  TableView.setDataSource(self, data)
  self.columnWidth = data.columnWidth
end

return CollectionView