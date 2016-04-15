local _ = require "lib/moses"
local anim8 = require "lib/anim8"
local class = require "lib/middleclass"
local cache = require "cache"

local Entity = require "entity/entity"
local Bubble = require "entity/bubble"

local Player = class("Player", Entity)

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 5, 5)

  self.img = cache:getOrLoadImage("asset/player.png")

  local g = anim8.newGrid(5, 5, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(g('1-1', 1), 1)

  g = anim8.newGrid(6, 5, self.img:getWidth(), self.img:getHeight(), 0, 5)
  self.walkingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  g = anim8.newGrid(7, 5, self.img:getWidth(), self.img:getHeight(), 0, 10)
  self.swimmingAnimation = anim8.newAnimation(g('1-2', 1), 0.5)

  self.bubbleParticle = Bubble:new()

  self.position = "stand"

  self.speed = 20
  self.speedDown = 15
  self.jumpVelocity = 28
  self.gravity = 500

  self.exit = false

  self.score = 0

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

    elseif o.other.class.name == "Exit" then
      self.exit = true
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
  elseif kind == "Exit" and self.baby then
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

    -- If we have the baby, set the same position state
    if self.baby then
      self.baby.position = self.position
    end
end

function Player:draw()
  self.bubbleParticle:draw(self.x + 3, self.y + 1)

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
