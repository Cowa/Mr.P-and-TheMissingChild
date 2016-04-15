local class = require "lib/middleclass"

local Player = require "entity/player"

local DummyPlayer = class("DummyPlayer", Player)

-- Dummy player is used in menu (no input or other stuff)
function DummyPlayer:initialize(world, x, y)
  Player.initialize(self, world, x, y)
end

function DummyPlayer:update(dt)
  self:changeVelocityByGravity(dt)
  self:move(dt)

  self.walkingAnimation:update(dt)
  self.swimmingAnimation:update(dt)
end

function DummyPlayer:draw(flipped)
  if self.position == "right" then
    self.walkingAnimation:draw(self.img, self.x, self.y)
  elseif self.position == "swim" then
    self.swimmingAnimation:draw(self.img, self.x - 1, self.y)
  else
    if flipped then
      self.animation:draw(self.img, self.x, self.y)
    else
      self.animation:flipH()
      self.animation:draw(self.img, self.x, self.y)
      self.animation:flipH()
    end
  end
end

return DummyPlayer
