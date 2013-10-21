-----------------------------------------------
-- @class: TableView
-- @file TableView.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local TableView = View:subclass('TableView')

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

TableView.static.friction = 0.94
TableView.static.scrollStopThreshold = 250
-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a TableView Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function TableView:initialize(opt)
  View.initialize(self, opt)
  self.sections = {}
  self.header = nil
  self.footer = nil  
end

-- ------
-- Configuring a Table View
-- ------

-- ------
-- Creating Table View Cells
-- ------

-- ------
-- Accessing Header and Footer Views
-- ------

-- ------
-- Scrolling the Table View
-- ------

-- ------
-- Managing Selections
-- ------

-- ------
-- Inserting, Deleting, and Moving Rows and Sections
-- ------

-- ------
-- Reloading the Table View
-- ------

-- ------
-- Managing the Data Source
-- ------


return TableView