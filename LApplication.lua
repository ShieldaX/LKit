-- ========================================
-- LApplication.lua
-- Singleton, application loop controller.
--
-- ========================================

local application = {}
--local application_metatable = {__index = application}

-- Instance reference
local instance = nil

-- Constructor function.
function application.new()
    if instance then
        return false
    else
        instance = application
    end
end
--

-- Get singleton instance.
function application:getInstance()
    if not instance then
        return self.new()        
    else
        return instance
    end
end
--

function application:start()
end

function application:stop()
end

function application:pause()
end

function application:resume()
end

return application