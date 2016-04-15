local class = require "lib/middleclass"

local Baby = require "entity/baby"

local DummyBaby = class("DummyBaby", Baby)

-- Dummy player is used in menu (no input or other stuff)
function DummyBaby:initialize(world, x, y)
  Baby.initialize(self, world, x, y)
end

function DummyBaby:draw()
  if self.position == "right" then
    self.walkingAnimation:draw(self.img, self.x, self.y)
  elseif self.position == "swim" then
    self.swimmingAnimation:draw(self.img, self.x - 1, self.y)
  else
    self.standAnimation:draw(self.img, self.x, self.y)
  end
end

return DummyBaby
