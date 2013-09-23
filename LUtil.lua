-- lUtil.lua
-- ======

local lUtil = {}

local self = lUtil

---
local coronaMetaTable = getmetatable(display.getCurrentStage())

function self.isDisplayObject(aDisplayObject)
  return type(aDisplayObject) == "table" and getmetatable(aDisplayObject) == coronaMetaTable
end

function self.isPointInBounds(point, bounds)
  return point.x > bounds.xMin and point.x < bounds.xMax and point.y > bounds.yMin and point.y < bounds.yMax
end

--- Dump arbitrary variables include table
-- @param t Table or string
function self.print(t)
--{{{
  local print_r_cache={}
  local function sub_print_r(t,indent)
    if (print_r_cache[tostring(t)]) then
      print(indent.."*"..tostring(t))
    else
      print_r_cache[tostring(t)]=true
      if (type(t)=="table") then
        for pos,val in pairs(t) do
          if (type(pos)=="table") then pos = tostring(pos) end
          if (type(val)=="table") then
            print(indent.."["..pos.."] => "..tostring(t).." {")
            sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
            print(indent..string.rep(" ",string.len(pos)+6).."}")
          elseif (type(val)=="string") then
            print(indent.."["..pos..'] => "'..val..'"')
          else
            print(indent.."["..pos.."] => "..tostring(val))
          end
        end
      else
      print(indent..tostring(t))
      end
    end
  end

    if (type(t)=="table") then
      print(tostring(t).." {")
      sub_print_r(t,"  ")
      print("}")
    else
      sub_print_r(t,"  ")
    end
    print()
--}}}
end

return lUtil