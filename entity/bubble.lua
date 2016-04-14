local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
local cache = require "cache"

local Entity = require "entity/entity"
local Bubble = class("Bubble", Entity)

function Bubble:initialize()
  local bubbleParticleImg = cache:getOrLoadImage("asset/particle/player-bubble.png")
  self.bubbleParticle = love.graphics.newParticleSystem(bubbleParticleImg, 10)
  self.bubbleParticle:setParticleLifetime(1)
  self.bubbleParticle:setEmissionRate(1)
  self.bubbleParticle:setLinearAcceleration(-1, -10, 1, -20)
  self.bubbleParticle:setColors(255, 255, 255, 255, 255, 255, 255, 100)
end

function Bubble:update(dt)
  self.bubbleParticle:update(dt)
end

function Bubble:draw(x, y)
  love.graphics.draw(self.bubbleParticle, x, y)
end

return Bubble
