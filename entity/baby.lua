local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
local cache = require "cache"

local Entity = require "entity/entity"
local Bubble = require "entity/bubble"

local Baby = class("Baby", Entity)

function Baby:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 3, 3)

  self.type = type
  self.img = cache:getOrLoadImage("asset/baby.png")

  local g = anim8.newGrid(3, 3, self.img:getWidth(), self.img:getHeight())
  self.standAnimation = anim8.newAnimation(g('1-1', 1), 1)

  g = anim8.newGrid(4, 3, self.img:getWidth(), self.img:getHeight(), 4, 0)
  self.walkingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  g = anim8.newGrid(5, 3, self.img:getWidth(), self.img:getHeight(), 0, 3)
  self.swimmingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  self.position = "stand"

  self.bubbleParticle = Bubble:new()
end

function Baby:update(dt)
  self.standAnimation:update(dt)
  self.walkingAnimation:update(dt)
  self.swimmingAnimation:update(dt)
  self.bubbleParticle:update(dt)
end

function Baby:draw()
  if self.position == "right" then
    self.bubbleParticle:draw(self.x + 3, self.y + 1)
    self.walkingAnimation:draw(self.img, self.x, self.y)
  elseif self.position == "left" then
    self.bubbleParticle:draw(self.x + 6, self.y + 1)
    self.walkingAnimation:flipH()
    self.walkingAnimation:draw(self.img, self.x + 5, self.y)
    self.walkingAnimation:flipH()
  elseif self.position == "swim" then
    self.bubbleParticle:draw(self.x + 1, self.y + 1)
    self.swimmingAnimation:draw(self.img, self.x - 1, self.y)
  else
    self.bubbleParticle:draw(self.x + 1, self.y + 1)
    self.standAnimation:draw(self.img, self.x, self.y)
  end
end

return Baby
