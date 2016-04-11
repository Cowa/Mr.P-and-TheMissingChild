local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Coin = class("Coin", Entity)

local cache = require "cache"

function Coin:initialize(world, x, y, w, h)
  Entity.initialize(self, world, x, y, w, h)

  self.value = 10

  self.sound = cache:getOrLoadSound("asset/sound/coin.wav")
end

function Coin:draw()
  if self.removed then return end

  love.graphics.setColor(187, 166, 81)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
end

function Coin:picked()
  self:remove()
  love.audio.play(self.sound)
end

return Coin
