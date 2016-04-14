local _ = require "lib/moses"
local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Player = class("Player", Entity)

local cache = require "cache"

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 5, 5)

  self.img = cache:getOrLoadImage("asset/player.png")

  local g = anim8.newGrid(5, 5, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(g('1-1', 1), 1)

  g = anim8.newGrid(6, 5, self.img:getWidth(), self.img:getHeight(), 0, 5)
  self.walkingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  g = anim8.newGrid(7, 5, self.img:getWidth(), self.img:getHeight(), 0, 10)
  self.swimmingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  local bubbleParticleImg = cache:getOrLoadImage("asset/particle/player-bubble.png")
  self.bubbleParticle = love.graphics.newParticleSystem(bubbleParticleImg, 10)
  self.bubbleParticle:setParticleLifetime(1)
  self.bubbleParticle:setEmissionRate(1)
  self.bubbleParticle:setLinearAcceleration(-1, -10, 1, -20)
  self.bubbleParticle:setColors(255, 255, 255, 255, 255, 255, 255, 100)

  self.position = "stand"

  self.speed = 20
  self.speedDown = 15
  self.jumpVelocity = 30
  self.gravity = 500

  self.score = 0

  self.isBabyAttached = false
  self.baby = nil
end

function Player:update(dt)
  self:changeVelocityByInput(dt)
  self:changeVelocityByGravity(dt)
  self:move(dt)

  self.animation:update(dt)
  self.walkingAnimation:update(dt)
  self.swimmingAnimation:update(dt)
  self.bubbleParticle:update(dt)
end

function Player:move(dt)
  local futureX = self.x + self.vx * dt
  local futureY = self.y + self.vy * dt

  local actualX, actualY, cols, len = self.world:move(self, futureX, futureY, self.filter)

  self.x = actualX
  self.y = actualY

  -- If we have the baby, we move it too
  if self.baby then
    self.baby.x = self.x - 2
    self.baby.y = self.y + 2
  end

  _.map(cols, function (i, o)
    if o.other.class.name == "Coin" then
      o.other:picked()
      self.score = self.score + o.other.value

    elseif o.other.class.name == "Baby" then
      self.baby = o.other
    end
  end)
end

function Player:filter(other)
  local kind = other.class.name
  if kind == "Rock" then
    return "slide"
  elseif kind == "Coin" then
    return "cross"
  elseif kind == "Baby" then
    return "cross"
  end
end

function Player:changeVelocityByGravity(dt)
  self.vy = self.vy + self.gravity * dt
end

function Player:changeVelocityByInput(dt)
    if love.keyboard.isDown("right") then
      self.vx = self.speed
      self.position = "right"

    elseif love.keyboard.isDown("left") then
      self.vx = -self.speed
      self.position = "left"

    else
      self.vx = 0
      self.position = "stand"
    end

    if love.keyboard.isDown("up") then
      self.vy = -self.jumpVelocity
      self.position = "swim"

    elseif love.keyboard.isDown("down") then
      self.vy = self.speedDown
      self.position = "swim"

    else
      self.vy = 0
    end

    if self.baby then
      self.baby.position = self.position
    end
end

function Player:draw()
  love.graphics.draw(self.bubbleParticle, self.x + 3, self.y + 1)

  if self.position == "right" then
    self.walkingAnimation:draw(self.img, self.x, self.y)
  elseif self.position == "left" then
    self.walkingAnimation:flipH()
    self.walkingAnimation:draw(self.img, self.x - 1, self.y)
    self.walkingAnimation:flipH()
  elseif self.position == "swim" then
    self.swimmingAnimation:draw(self.img, self.x - 1, self.y)
  else
    self.animation:draw(self.img, self.x, self.y)
  end
end

return Player
