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
local Linear = require("LLinear")
local foobar = Linear.new({width = 200, height = 400})
local foo = View.new({name = "foo", width = 50, backgroundColor = {255, 255, 0}})
local bar = View.new({name = "bar", height = 50, backgroundColor = {0, 255, 255}})

--print("internal ids: ", foobar._id, foo._id, bar._id)

foobar:addView(foo)
foobar:addView(bar, 2)

foobar.frame.x = display.contentCenterX
--foobar:setBackgroundColor({255, 0, 255})

--print_r(foobar)
timer.performWithDelay(2600, function()
    --foobar:removeView(1)
    --print_r(foobar)
    --foobar:moveViewToIndex(1, 2)
    --print(foo:getWindow()._id)
    --print_r(bar:isDescendantOfView(foobar))
    --print(foobar:nameOfView(5))
    --foobar:removeView('bar')
end)

timer.performWithDelay(2600 + 100, function()
  --print_r(bar)
  --foobar:addView(bar)
  print('force')
end)
