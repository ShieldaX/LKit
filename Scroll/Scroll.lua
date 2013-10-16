-----------------------------------------------
-- @class: Scroll
-- @file Scroll.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'

-- ======
-- CLASS
-- ======
local Scroll = View:subclass('Scroll')

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight

-- ======
-- VARIABLES
-- ======

Scroll.static.friction = 0.972
Scroll.static.scrollStopThreshold = 250
-- Internal identifier

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a Scroll Object
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Scroll:initialize(opt)
  View.initialize(self, opt)
  local view = self.bounds
  view._startXPos = 0
	view._startYPos = 0
	view._prevXPos = 0
	view._prevYPos = 0
	view._prevX = 0
	view._prevY = 0
	view._delta = 0
	view._velocity = 0
	view._prevTime = 0
	view._lastTime = 0
  view._timeHeld = 0
  view._maxVelocity = 2
  view._friction = self.class.friction
  self.frame:addEventListener("touch", self)
  Runtime:addEventListener("enterFrame", self)
end

-- Function to clamp velocity to the maximum value
local function clampVelocity( view )
	-- Throttle the velocity if it goes over the max range
	if view._velocity < -view._maxVelocity then
		view._velocity = -view._maxVelocity
	elseif view._velocity > view._maxVelocity then
		view._velocity = view._maxVelocity
	end
end

function Scroll:touch(event)
  local phase = event.phase
  local time = event.time  
  local view = self.bounds
  
	if "began" == phase then	
		-- Reset values	
		view._startXPos = event.x
		view._startYPos = event.y
		view._prevXPos = event.x
		view._prevYPos = event.y
		view._prevX = 0
		view._prevY = 0
		view._delta = 0
		view._velocity = 0
		view._prevTime = 0
		view._moveDirection = nil
		view._trackVelocity = true
		view._updateRuntime = false
		
		-- Set the limits now
		-- setLimits( M, view )
		
		-- Cancel any active tween on the view
		if view._tween then
			transition.cancel( view._tween )
			view._tween = nil
		end				
		
		-- Set focus
		display.getCurrentStage():setFocus( event.target, event.id )
		view._isFocus = true
	
	elseif view._isFocus then
    if "moved" == phase then
      view._delta = event.y - view._prevYPos
      view._prevYPos = event.y
      view.y = view.y + view._delta
      -- Set the time held
      view._timeHeld = time
    elseif "ended" == phase or "cancelled" == phase then
      -- Reset values				
			view._lastTime = event.time
			view._trackVelocity = false			
			view._updateRuntime = true
			if event.time - view._timeHeld > self.class.scrollStopThreshold then
			    view._velocity = 0
			end
			view._timeHeld = 0
      
      if view._delta > 0 and view._velocity < 0 then
			    view._velocity = - view._velocity
			end
			
			if view._delta < 0 and view._velocity > 0 then
			    view._velocity = - view._velocity
			end
      
      display.getCurrentStage():setFocus( nil )
			view._isFocus = nil
    end
  end
  
  return true
end

function Scroll:enterFrame(event)
  local view = self.bounds
  
  if view._updateRuntime then
    local timePassed = event.time - view._lastTime
		view._lastTime = view._lastTime + timePassed
    print(view._velocity)
    -- Stop scrolling if velocity is near zero
		if math.abs( view._velocity ) < 0.01 then
			view._velocity = 0
			view._updateRuntime = false			
		end
    
    -- Set the velocity
		view._velocity = view._velocity * view._friction
    -- Clamp the velocity if it goes over the max range
		clampVelocity( view )

    view.y = view.y + view._velocity * timePassed
  end
  
  -- If we are tracking velocity
	if view._trackVelocity then	
		-- Calculate the time passed
		local newTimePassed = event.time - view._prevTime
		view._prevTime = view._prevTime + newTimePassed
    
    if view._prevY then
      local possibleVelocity = ( view.y - view._prevY ) / newTimePassed
                
      if possibleVelocity ~= 0 then
        view._velocity = possibleVelocity
        -- Clamp the velocity if it goes over the max range
        clampVelocity( view )
      end
    end
    view._prevY = view.y
  end
end

function Scroll:scrollTo()
end

function Scroll:scrollBy()
end

return Scroll