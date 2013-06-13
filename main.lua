-- main.lua

print() 
print("LKit Lib")

DEBUG = true

local View = require("LView")

local testView = View.new({width = 200, height = 100})

print("testView internal id: ", testView._id)
