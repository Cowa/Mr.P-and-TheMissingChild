local class = require "lib/middleclass"

local Entity = class("Entity")

function Entity:initialize(world, x, y, w, h)
  self.world, self.x, self.y, self.w, self.h = world, x, y, w, h
  self.vx, self.vy = 0,0
  self.world:add(self, x, y, w, h)
end

function Entity:remove()
  self.world:remove(self)
end

return Entity
