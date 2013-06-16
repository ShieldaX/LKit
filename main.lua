-- main.lua

print() 
print("LKit Lib")

DEBUG = true

-- ---
-- dump arbitrary variables include table
--
function print_r ( t )
--{{{
    local print_r_cache={}
        local function sub_print_r(t,indent)
            if (print_r_cache[tostring(t)]) then
                print(indent.."*"..tostring(t))
            else
                print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
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

local View = require("LView")

local testView = View.new({width = 200, height = 100})
local toInsert = View.new({name = "foo", width = 50, backgroundColor = {255, 255, 0}})

print("internal ids: ", testView._id, toInsert._id)

testView:addView(toInsert)

testView.frame.x = display.contentCenterX

print_r(testView)
