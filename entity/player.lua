local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Player = class("Player", Entity)

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 3, 3)
  self.world = world

  self.img = love.graphics.newImage("asset/player.png")
  self.img:setFilter("nearest", "nearest")

  self.position = "right"

  self.speed = 10
  self.speedUpDown = 20
end

function Player:update(dt)
  self:input(dt)

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
end

function Player:filter(other)
  local kind = other.class.name
  if kind == 'Rock' then return 'slide' end
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

    else
      self.position = "stand"
    end

    if love.keyboard.isDown("up") then
      self:move(self.x, self.y - self.speedUpDown * dt)

    elseif love.keyboard.isDown("down") then
      self:move(self.x, self.y + self.speedUpDown * dt)

    end
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end

return Player
