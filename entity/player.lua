local class = require "lib/middleclass"

local Entity = require "entity/entity"
local Player = class("Player", Entity)

function Player:initialize(world, x, y)
  Entity.initialize(self, world, x, y, 3, 3)
  self.world = world

  self.img = love.graphics.newImage("asset/player.png")
  self.img:setFilter("nearest", "nearest")

  self.speed = 2
  self.runAccel = 5
end

function Player:update(dt)
  self:input(dt)
  self:move(self.x + self.vx, self.y + self.vy)
end

function Player:move(x, y)
  local actualX, actualY, cols, len = self.world:move(self, x, y, self.filter)

  self.x = round(actualX)
  self.y = round(actualY)

  -- rounded player world position to avoid unsync view/world
  self.world:update(self, self.x, self.y)
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
      self.vx = self.vx + self.speed * dt

    elseif love.keyboard.isDown("left") then
      self.vx = self.vx - self.speed * dt

    else
      self.vx = 0
    end

    if love.keyboard.isDown("up") then
      self.vy = self.vy - self.speed * dt

    elseif love.keyboard.isDown("down") then
      self.vy = self.vy + self.speed * dt

    else
      self.vy = 0
    end
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end

return Player
