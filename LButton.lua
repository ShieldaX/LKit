-- LButton.lua
-- Button maintainer
--

local Button = {}
local ButtonMT = {__index = Button}

-- Constructor method
function Button.new(opts)
    local newButton = {}
    
    return setmetatable( newButton, ButtonMT )
end

