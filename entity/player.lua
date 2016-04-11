local _ = require "lib/moses"
local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Player = class("Player", Entity)

local cache = require "cache"

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 3, 3)
  self.world = world

  self.img = love.graphics.newImage("asset/player.png")
  self.img:setFilter("nearest", "nearest")

  local g = anim8.newGrid(4, 3, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(g('1-1', 1), 1)

  local particleImg = cache:getOrLoadImage("asset/particle/player-bubble.png")
  self.bubbleParticle = love.graphics.newParticleSystem(particleImg, 10)
  self.bubbleParticle:setParticleLifetime(1)
  self.bubbleParticle:setEmissionRate(1)
  self.bubbleParticle:setLinearAcceleration(-1, -10, 1, -20)
  self.bubbleParticle:setColors(255, 255, 255, 255, 255, 255, 255, 0)

  self.position = "right"

  self.speed = 10
  self.speedUpDown = 20

  self.score = 0
end

function Player:update(dt)
  self:input(dt)
  self.animation:update(dt)
  self.bubbleParticle:update(dt)

  if self.position == "stand" then
    self:move(self.x, self.y + 10 * dt)
  else
    self:move(self.x, self.y + 2 * dt)
  end
end

function Player:move(x, y)
  local actualX, actualY, cols, len = self.world:move(self, x, y, self.filter)

  self.x = actualX
  self.y = actualY

  _.map(cols, function (i, o)
    if o.other.class.name == "Coin" then
      o.other:picked()
      self.score = self.score + o.other.value
    end
  end)
end

function Player:filter(other)
  local kind = other.class.name
  if kind == "Rock" then
    return "slide"
  elseif kind == "Coin" then
    return "cross"
  end
end

function Player:input(dt)
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end

    if love.keyboard.isDown("right") then
      self:move(self.x + self.speed * dt , self.y)
      self.position = "right"

    elseif love.keyboard.isDown("left") then
      self:move(self.x - self.speed * dt , self.y)
      self.position = "left"
    end

    if love.keyboard.isDown("up") then
      self:move(self.x, self.y - self.speedUpDown * dt)

    elseif love.keyboard.isDown("down") then
      self:move(self.x, self.y + self.speedUpDown * dt)

    end
end

function Player:draw()
  love.graphics.draw(self.bubbleParticle, self.x + 2, self.y + 2)
  if self.position == "right" then
    self.animation:draw(self.img, self.x, self.y)
  elseif self.position == "left" then
    self.animation:flipH()
    self.animation:draw(self.img, self.x, self.y)
    self.animation:flipH()
  else
    self.animation:draw(self.img, self.x, self.y)
  end
end

return Player
