local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Player = class("Player", Entity)

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 5, 2)
  self.world = world

  self.speed = 2
end

function Player:update(dt)
  self:input(dt)
  self:move(self.x + self.vx * dt, self.y + self.vy * dt)
end

function Player:move(x, y)
  local actualX, actualY, cols, len = self.world:move(self, x, y)
  self.x = actualX
  self.y = actualY

  -- handle collision
  -- other.class.name to get class name
end

function Player:input(dt)
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end

    if love.keyboard.isDown("right") then
      self.vx = self.vx + self.speed -- player:move(player.x + self.speed * dt, player.y)

    elseif love.keyboard.isDown("left") then
      self.vx = self.vx - self.speed -- player:move(player.x - self.speed * dt, player.y)

    else
      self.vx = 0
    end

    if love.keyboard.isDown("up") then
      self.vy = self.vy - self.speed -- player:move(player.x, player.y - self.speed * dt)

    elseif love.keyboard.isDown("down") then
      self.vy = self.vy + self.speed -- player:move(player.x, player.y + self.speed * dt)

    else
      self.vy = 0
    end
end

function Player:draw()
  love.graphics.setColor(255, 0, 0)
  love.graphics.points(self.x, self.y)
  love.graphics.setColor(255, 255, 255)
end

return Player
