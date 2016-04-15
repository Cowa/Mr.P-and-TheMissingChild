local class = require "lib/middleclass"

local State = class("State")

function State:initialize()
  self.current = nil
end

function State:set(state)
  self.current = state
end

function State:update(dt)
  self.current:update(dt)
end

function State:draw()
  self.current:draw()
end

return State
