local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Algae = class("Algae", Entity)

local cache = require "cache"

function Algae:initialize(world, x, y, w, h, type)
  Entity.initialize(self, world, x, y, w, h)

  self.type = type
  self.img = cache:getOrLoad("asset/algae-" .. type .. ".png")

  if string.startsWith(type, "small") then
    local g = anim8.newGrid(2, 2, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-2', 1), 1)
  elseif string.startsWith(type, "medium") then
    local g = anim8.newGrid(3, 3, self.img:getWidth(), self.img:getHeight())
    self.animation = anim8.newAnimation(g('1-4', 1), 1)
  end

end

function Algae:update(dt)
  self.animation:update(dt)
end

function Algae:draw()
  self.animation:draw(self.img, self.x, self.y)
end

return Algae
