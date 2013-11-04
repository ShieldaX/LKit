-- scroller.lua
-- Enable scrolling module

local util = require "util"
local Abs = math.abs
local Max = math.max

local scroller = {
  scrollEnabled = true,
  dragging = false,
  tracking = false,
  decelerating  = false,
  decelerationRate = 0.94,
  tween = nil, -- content view transition reference
  upperLimit = nil, bottomLimit = nil, -- dynamic scroll limitation
  offsetUpLimit = nil, offsetDownLimit = nil, -- dynamic scroll limitation
  _prevYPos = 0, _prevY = 0,
  _delta = 0,
  velocity = 0, maxVelocity = 2,
  _prevTime = 0,
  _lastTime = 0,
  _timeHeld = 0,
  _topPadding = 0, _bottomPadding = 0,
}

function scroller:limitVelocity()
  -- Throttle the velocity if it goes over the max range
  if self.velocity < -self.maxVelocity then
    self.velocity = -self.maxVelocity
  elseif self.velocity > self.maxVelocity then
    self.velocity = self.maxVelocity
  end
end

-- update scrollable content height
function scroller:updateScrollHeight()
  -- TODO: dynamic on data source if any.
  self.scrollHeight = self.bounds.contentHeight
  --self.scrollHeight = self:offsetToSection(self.dataSource:numberOfSections() + 1)
  --self.scrollHeight = self:offsetToRowAtIndexPath(self.dataSource:numberOfRowsInSection())
  local dataSource = self.dataSource
  local scrollHeight = self.scrollHeight
  for i = 1, dataSource:numberOfSections() do
    local lastIndexPath = {section = i, row = dataSource:numberOfRowsInSection(i)}
    scrollHeight = Max( scrollHeight, self:offsetToRowAtIndexPath(lastIndexPath) + dataSource:heightForRowAtIndexPath(lastIndexPath) )
  end
  self.scrollHeight = scrollHeight
  -- smallest scrolling height is view height
  if self.scrollHeight < self.background.contentHeight then    
    self.scrollHeight = self.background.contentHeight
  end
end

function scroller:updateLimitation() -- onUpdateScrollLimitation
  self:updateScrollHeight()
  self.bottomLimit = self.yOffset or 0
  self.upperLimit = self.background.contentHeight - self.scrollHeight - self._bottomPadding
end

function scroller:limitationReached(bounce) -- overscroll(bounce)
  local limitHit = "none"
  local bounceTime = 400
  local contentView = self.bounds
  
  if contentView.y > self.bottomLimit then
    limitHit = "bottom"
    if bounce == true then
      print("snap back to the top")
      self.tween = transition.to( contentView, { time = bounceTime, y = self.bottomLimit, transition = easing.outQuad } )
    end
  elseif contentView.y < self.upperLimit then
    limitHit = "top"
    if bounce == true then
      print("snap back to the bottom")
      self.tween = transition.to( contentView, { time = bounceTime, y = self.upperLimit, transition = easing.outQuad } )
    end
  end
  return limitHit
end

function scroller:touch(event)
  local contentView = self.bounds
  local phase = event.phase
  local time = event.time
  local target = event.target
  
  if "began" == phase then
    -- Reset values	
    self._prevYPos = event.y
    self._prevY = 0
    self._delta = 0
    self.velocity = 0
    self._prevTime = 0
    self.dragging = false
    self.tracking = true
    self.decelerating = false
    
    -- Set the limits now
    self:updateLimitation()
    
    -- Cancel any active tween on the content view
    if self.tween then
      transition.cancel( self.tween )
      self.tween = nil
    end
    
    --self:willBeginDragging()
    if type(self.willBeginDragging) == "function" then self:willBeginDragging() end
    --self:send("willBeginDragging", event)
    
    -- Set focus
    display.getCurrentStage():setFocus( event.target, event.id )
    --target.isFocus = true

  elseif self.tracking then
    if "moved" == phase then      
      self._delta = event.y - self._prevYPos
      self._prevYPos = event.y
      if Abs(self._delta) > 1 then self.dragging = true end      
      -- If the view is more than the limits, handle overscroll
      if contentView.y < self.upperLimit or contentView.y > self.bottomLimit then
        contentView.y = contentView.y + ( self._delta * 0.5 )
      else
        contentView.y = contentView.y + self._delta 
      end
      
      self:limitationReached( false )
      
      -- update the last held time
      self._timeHeld = time
            
      --util.print_r(#(self:indexPathsForVisibleRows()))
      --TODO: stuck section header
      
    elseif "ended" == phase or "cancelled" == phase then
      self._lastTime = event.time
      self.dragging = false
      self.tracking = false
      self.decelerating = true
      
      -- touch held
      if event.time - self._timeHeld > self.class.scrollStopThreshold then
        self.velocity = 0
      end
      self._timeHeld = 0
      
      if self._delta > 0 and self.velocity < 0 then
        self.velocity = -self.velocity
      end
      if self._delta < 0 and self.velocity > 0 then
        self.velocity = -self.velocity
      end
      
      display.getCurrentStage():setFocus( event.target, nil )
      --target.isFocus = false
    end
  end
  
  return true
end

function scroller:enterFrame(event)
  self:_queueReusableCells()
  --self:visibleSections()
  self:visibleCells()

  local contentView = self.bounds
  -- dragging content  
  if self.dragging then
  -- time elapsed
    local deltaTime = event.time - self._prevTime
    self._prevTime = event.time
    local calculatedVelocity = (contentView.y - self._prevY) / deltaTime
    if calculatedVelocity ~= 0 then
      self.velocity = calculatedVelocity
      self:limitVelocity()
    end
    self._prevY = contentView.y
    
  -- fling content
  elseif self.decelerating then
    -- Set the limits now
    self:updateLimitation()

    local timePassed = event.time - self._lastTime
    self._lastTime = event.time
    -- Stop scrolling if velocity is near zero
    if Abs( self.velocity ) < 0.1 then
      self.velocity = 0
      self.decelerating = false
    end
    -- update velocity
    self.velocity = self.velocity * self.decelerationRate
    self:limitVelocity()
    -- update content view position
    contentView.y = contentView.y + self.velocity * timePassed
    -- check limitation reaching
    local limit = self:limitationReached( true )
    if limit == "top" or limit == "bottom" then
      self.decelerating = false
    end
  end
end

return scroller