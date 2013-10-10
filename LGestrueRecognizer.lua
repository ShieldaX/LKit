-- LGestureRecognizer.lua

-- http://jessewarden.com/2012/07/finite-state-machines-in-game-development.html

local LGestureRecognizer = class 'LGestureRecognizer'

LGestureRecognizer.static.State = {
    Possible = 1,
    Began = 2,
    Changed = 3,
    Ended = 4,
    Cancelled = 5,
    Failed = 6,
    Recognized = 4
  }

local State = StateMachine:new()
State:addState("possible", {from="*"})
State:addState("began", {from="possible"})
State:addState("changed", {from="began", enter = onEnterChanged})
State:setInitialState("possible")
  
function LGestureRecognizer:touch(event)
  print('try to parse', event.name)
end

return LGestureRecognizer