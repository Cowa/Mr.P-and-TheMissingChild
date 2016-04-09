local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Rock = class("Rock", Entity)

function Rock:initialize(world, x, y, w, h)
  Entity.initialize(self, world, x, y, w, h)
  self.world = world
end

return Rock
