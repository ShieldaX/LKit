-- LEnum.lua
--

-- ------
-- LIBRARIES
-- ------

require 'middleclass'

-- ------
-- CLASS
-- ------

local LEnum = class "LEnum"

-- ------
-- CLASS METHOD
-- ------

function LEnum:initialize(list)
  table.foreach(list, function(i, v)
    self[v] = v
  end)
end

return LEnum