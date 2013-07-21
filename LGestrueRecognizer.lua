-- LGestureRecognizer.lua

local LGestureRecognizer = {}

function LGestureRecognizer:touch(event)
  print('try to parse', event.name)
end

return LGestureRecognizer