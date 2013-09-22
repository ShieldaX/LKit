---- main.lua ----

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Set the background to white
display.setDefault( "background", 255, 255, 255 )

print() 
print("LKit Lib Demo")

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

local View = require("LView")
local Window = require("LWindow")
local Linear = require("LLinear")
local Button = require("LButton")

local win = Window {name = "window"}

local box = Linear {name = "hbox", width = 200, direction = "vertical"}
box:setBackgroundColor({255, 204, 0})

local v = View {name = "gray", height = 50, backgroundColor = {142, 142, 147}}

local vv = View {name = "blue", height = 25, backgroundColor = {52, 170, 220}}

local btn = Button {
    name = "new_button",
    width = 160,
    height = 60,
    backgroundColor = {255, 255, 255, 0}
  }

win:addView(box)
box:addView(v)
box:addView(vv)
box:addView(btn)

print(box:nameOfView(2))
print(vv:isDescendantOfView(box))
print("window level :", v:getWindow().name)
print(box.name)

--print_r(foobar)
timer.performWithDelay(2600, function()
  --box:removeView(1)
  print(box.blue.name)
  print(box.gray.name)
    --foobar:removeView(1)
    --print_r(foobar)
    --foobar:moveViewToIndex(1, 2)
    --print(foo:getWindow()._id)
    --print_r(bar:isDescendantOfView(foobar))
    --print(foobar:nameOfView(5))
    --foobar:removeView('bar')
  print_r(box.gray)
end)

--[[
local win = Window {
  linear {
    name = "linear",
    width = "match",
    height = "match",
    direction = "horizontal",
    View {
      name = "rootView",
      width = "match",
      height = "wrap",
      Button = {
        name = "print",
        width =  "wrap",
        height = "wrap",
      }
    },
    ScrollView {
      name = "scroll",
      width = "match",
      height = "match",
    }
  }
}

win.linear.rootview.print._frame
win.subviews.linear.subviews.rootview.subviews.print

]]
