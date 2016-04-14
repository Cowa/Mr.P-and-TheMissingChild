local class = require "lib/middleclass"
local cache = require "cache"

local Entity = require "entity/entity"
local Coin = class("Coin", Entity)

function Coin:initialize(world, x, y, w, h)
  Entity.initialize(self, world, x, y, w, h)

  self.value = 10

  self.sound = cache:getOrLoadSound("asset/sound/coin.wav")

  local particleImg = cache:getOrLoadImage("asset/particle/coin-picked.png")
  self.particle = love.graphics.newParticleSystem(particleImg, 10)
end

function Coin:setUpParticle()
  self.particle:setParticleLifetime(1)
  self.particle:setEmissionRate(5)
  self.particle:setLinearAcceleration(-1, -10, 1, -20)
  self.particle:setColors(255, 255, 255, 255, 255, 255, 255, 0)
  self.particle:setEmitterLifetime(0.75)
end

function Coin:update(dt)
  self.particle:update(dt)
end

function Coin:draw()
  love.graphics.draw(self.particle, self.x + 1, self.y + 1)

  if self.removed then return end

  love.graphics.setColor(187, 166, 81)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
end

function Coin:picked()
  self:remove()
  self:setUpParticle()
  love.audio.play(self.sound)
end

return Coin
