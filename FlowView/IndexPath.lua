-- IndexPath.lua

local class = require "middleclass"

local IndexPath = class "IndexPath"

local _indexed = {}

local function pathToIndex(i, p)
  assert(type(i) == "number" and type(p) == "number", "number expected")
  return i .. '_' .. p
end

function IndexPath:initialize(index, path)
  local index = pathToIndex(index, path)
  _indexed[index] = _indexed[index] or {section = index, row = path}
  return _indexed[index]
end

return IndexPath