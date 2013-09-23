-- enum.lua
--

local enum = {}

function enum.def(list)
  local instance = {}
  table.foreach(list, function(i, v)
    instance[v] = v
  end)
  return instance
end

return enum