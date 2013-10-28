-- scroller.lua
-- Enable scrolling module

local scroller = {
  scrollEnabled = true,
  dragging = false,
  tracking = false,
  decelerating  = false,
  decelerationRate = 0.94,
}

-- module varibles
local upperLimit, bottomLimit -- dynamic scroll limitation
local contentView = self.bounds
--view._startXPos = 0
--view._startYPos = 0
local tween -- content view transition reference
local friction = 0.94
local velocity = 0
local _prevYPos = 0
local _prevY = 0
local _delta = 0
local velocity = 0
local _prevTime = 0
local _lastTime = 0
local _timeHeld = 0
local maxVelocity = 2
local _topPadding, _bottomPadding = 0, 0
--local _scrollHeight = self.background.contentHeight
local isFocus = false

local function limitVelocity()
  -- Throttle the velocity if it goes over the max range
  if velocity < -maxVelocity then
    velocity = -maxVelocity
  elseif velocity > maxVelocity then
    velocity = maxVelocity
  end
end

local function updateLimitation()
  bottomLimit = _topPadding
  upperLimit = - contentView.contentHeight + self.background.contentHeight - _bottomPadding
end

local function limitationReached(bounce) -- overscroll(bounce)
  local limitHit = "none"
  local bounceTime = 400
  if contentView.y > bottomLimit then
    limitHit = "bottom"
    if bounce == true then
      print("snap back to the top")
      tween = transition.to( contentView, { time = bounceTime, y = bottomLimit, transition = easing.outQuad } )
    end
  elseif view.y < self.upperLimit then
    limitHit = "top"
    if bounce == true then
      print("snap back to the bottom")
      tween = transition.to( contentView, { time = bounceTime, y = upperLimit, transition = easing.outQuad } )
    end
  end
  return limitHit
end

function scroller:touch(event)
  local phase = event.phase
  local time = event.time
  
  if "began" == phase then
    -- Reset values	
    _prevYPos = event.y
    _prevY = 0
    _delta = 0
    velocity = 0
    _prevTime = 0
    self.dragging = true
    self.decelerating = false
    
    -- Set the limits now
    updateLimitation()
    
    -- Cancel any active tween on the content view
    if _tween then
      transition.cancel( _tween )
      _tween = nil
    end
    
    -- Set focus
    display.getCurrentStage():setFocus( event.target, event.id )
    isFocus = true

  elseif isFocus then
    if "moved" == phase then
      _delta = event.y - _prevYPos
      _prevYPos = event.y
      -- If the view is more than the limits, handle overscroll
      if contentView.y < upperLimit or contentView.y > bottomLimit then
        contentView.y = contentView.y + ( _delta * 0.5 )
      else
        contentView.y = contentView.y + _delta 
      end
      
      limitationReached( false )
      
      -- update the last held time
      _timeHeld = time
    elseif "ended" == phase or "cancelled" == phase then
      _lastTime = event.time
      self.dragging = false
      self.decelerating = true
      
      -- touch held
      if event.time - _timeHeld > self.class.scrollStopThreshold then
        velocity = 0
      end
      _timeHeld = 0
      
      if _delta > 0 and velocity < 0 then
        velocity = -velocity
      end
      if _delta < 0 and velocity > 0 then
        velocity = -velocity
      end
      
      display.getCurrentStage():setFocus( event.target, nil )
      isFocus = false
    end
  end
  
  return true
end

function scroller:enterFrame(event)
  print(event.time)
  -- dragging content
  if self.dragging then
    -- time elapsed
    local deltaTime = event.time - _prevTime
    _prevTime = event.time
    local calculatedVelocity = (contentView.y - _lastY) / deltaTime
    if calculatedVelocity ~= 0 then
      velocity = calculatedVelocity
      limitVelocity()
    end
    _prevY = contentView.y
  end
  -- fling content
  if self.decelerating then
    local timePassed = event.time - _lastTime
    _lastTime = event.time
    -- Stop scrolling if velocity is near zero
    if math.abs( self.velocity ) < 0.1 then
      velocity = 0
      self.decelerating = false
    end
    -- update velocity
    velocity = velocity * self.decelerationRate
    limitVelocity()
    -- update content view position
    contentView.y = contentView.y + velocity * timePassed
    -- check limitation reaching
    local limit = limitationReached( true )
    if limit == "top" or limit == "bottom" then
      self.decelerating = false
    end
  end
end

function scroller:included(class)
end

return scroller