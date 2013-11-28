-- Color.lua
-- ------------

local Color = {}

Color.RGB = {
  neoncyan = {16, 174, 239}, -- Neon Cyan
  neonyellow = {231, 228, 37}, -- Neon Yellow
  neonpink = {231, 83, 177}, -- Neon Pink
  neongreen = {4, 228, 37}, -- Neon Green
  
  iosblue = {0, 122, 255}, -- iOS Blue
  iosgrey = {146, 146, 146}, -- iOS Grey
  iosgreen = {50, 155, 43}, -- iOS Green
  iosdarkgreen = {35, 105, 28}, -- iOS Dark Green

  ios7gray = {142, 142, 147} -- iOS7 Gray
  ios7pink = {255, 45, 85} -- iOS7 Pink
  ios7red = {255, 59, 48} -- iOS7 Red
  ios7orange = {255, 149, 0} -- iOS7 Orange
  ios7yellow = {255, 204, 0} -- iOS7 Yellow
  ios7green = {76, 217, 100} -- iOS7 Green
  ios7powderblue = {90, 200, 250} -- iOS7 Powderblue
  ios7blue = {52, 170, 220} -- iOS7 Blue
  ios7pureblue = {0, 122, 255} -- iOS7 Pure Blue
  ios7purple = {88, 86, 214} -- iOS7 Purple
  
  white = {255, 255, 255}, --White
  orange = {255, 132, 66}, --Orange
  pink = {255, 192, 203}, --Pink
  red = {255, 0, 0}, --Red
  green = {0, 255, 0}, --Green
  blue = {0, 0, 255}, --Blue
  purple = {160, 32, 240}, --Purple
  black = {0, 0, 0}, --Black
  yellow = {255, 255, 0}, --Yellow
  grey = {150, 150, 150}, --Grey
  
  whitesmoke = {245, 245, 245}, --White Smoke
  
  skyblue = {135, 206, 250}, --Sky Blue
  deepskyblue = {0, 191, 255}, --Deep sky blue
  dodgerblue = {30, 144, 255}, --Dodger Blue
  navy = {0, 0, 128}, --Navy
  lightskyblue = {135, 206, 250}, --Light Sky Blue
  lightcyan = {224, 255, 255}, --Light Cyan
  powderblue = {176, 224, 230}, --Powder Blue
  
  darkgreen = {0, 100, 0}, --Dark Green
  darkolivegreen = {85, 107, 47}, -- Dark Olive Green
  yellowgreen = {154, 205, 50}, --Yellow Green
  khaki = {240, 230, 140}, --Khaki
  kellygreen = {76, 187, 23}, --Kelly Green
  northtexasgreen = {5, 144, 51}, --North Texas Green
  mediumspringgreen = {0, 250, 154}, -- Medium Spring Green
  honeydew = {240, 255, 240}, --Honeydew
  lightseagreen = {32, 178, 170}, --Light Sea Green
  palegreen = {152, 251, 152}, --Pale Green
  limegreen = {50, 205, 50}, --Lime Green
  forestgreen = {34, 139, 34}, --Forest Green
  
  gold = {255, 215, 0}, --Gold
  mustard = {255, 192, 3}, --Mustard
  lemonchiffon = {255, 250, 205}, --Lemon Chiffon
  lightgoldenrodyellow = {250, 250, 210}, --Light Goldenrod Yellow
  
  darkred = {160, 0, 0}, --Dark Red
  peach = {255, 185, 143}, --Peach
  hotpink = {255, 105, 180}, --Hot Pink
  deeppink = {255, 20, 147}, --Deep Pink
  turquoise = {64, 224, 208}, --Turquoise
  kcred = {207, 0, 0}, --KC Red
  petal = {173, 90, 255}, --Petal
  indianred = {205, 92, 92}, --Indian Red
  violetred = {208, 32, 144}, --Violet Red
  darksalmon = {233, 150, 122}, --Dark Salmon
  lavenderblush = {255, 240, 245}, --Lavender Blush
  wheat = {245, 222, 179}, --Wheat
  thistle = {216, 191, 216}, --Thistle
  maroon = {176, 48, 96}, --Maroon
  
  bamboo = {216, 199, 169}, --Bamboo
  greyflannel = {195, 196, 192}, -- Grey Flannel
  oldlace = {249, 240, 226}, --Old Lace
  brownbag = {192, 137, 103}, -- Brown Bag
  mediumgrey = {175, 175, 175}, -- Med Grey
  darkwood = {133, 94, 66}, -- Dark Wood
  woolgrey = {143, 148, 152}, -- Wool Grey
  tan = {139, 90, 43}, --Tan
  darkgrey = {100, 100, 100}, -- Dark Grey
  darkbrown = {95, 59, 24}, --Dark Brown
}

-- @param name The name of special color.
-- @param* alpha Change alpha channel of the color, default is opaque.
function Color.named(name, alpha)
  assert(type(name) == "string", "invalid name param, got " .. type(name))
  local color = Color.RGB[name]
  if type(alpha) == "number" and alpha >= 0 and alpha <= 255 then
    color[4] = alpha
  end
  return color
end

function Color:toRGB()
end

function Color:toHex()
end

function Color:toCMYK()
end

return Color