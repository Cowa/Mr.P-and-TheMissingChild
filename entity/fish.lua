local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Fish = class("Fish", Entity)

local cache = require "cache"

function Fish:initialize(world, x, y, w, h, type)
  Entity.initialize(self, world, x, y, w, h)

  self.type = type
  self.img = cache:getOrLoad("asset/fish-" .. type .. ".png")
  self.state = "right"
  self.speed = 10

  local g = anim8.newGrid(4, 2, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(g('1-2', 1), 0.5)
end

function Fish:update(dt)
  self.animation:update(dt)

  local x = self.x - self.speed * dt

  if self.state == "right" then
    x = self.x + self.speed * dt
  end

  local actualX, actualY, cols, len = self.world:move(self, x, self.y, self.filter)

  if len > 0 then self:flipState() end

  self.x = actualX
end

function Fish:draw()
  self.animation:draw(self.img, self.x, self.y)
end

function Fish:flipState()
  self.animation:flipH()

  if self.state == "left" then
    self.state = "right"
  else
    self.state = "left"
  end
end

return Fish
