local class = require "lib/middleclass"

local Player = class("Player")

function Player:initialize(world, register)
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0

  self.w = 8
  self.h = 7

  self.speed = 15

  self.world = world

  self.img = register:getOrLoad("asset/pinguin.png")
  self.img:setFilter("nearest","nearest")
end

function Player:update(dt)
  self:move(self.x + self.vx * dt, self.y + self.vy * dt)
end

function Player:move(x, y)
  local actualX, actualY, cols, len = self.world:move(self, x, y)
  self.x = actualX
  self.y = actualY
end

function Player:input(dt)
    if love.keyboard.isDown("escape") then
      love.event.quit()
    end

    if love.keyboard.isDown("right") then
      player:move(player.x + self.speed * dt, player.y)

    elseif love.keyboard.isDown("left") then
      player:move(player.x - self.speed * dt, player.y)

    end

    if love.keyboard.isDown("up") then
      player:move(player.x, player.y - self.speed * dt)

    elseif love.keyboard.isDown("down") then
      player:move(player.x, player.y + self.speed * dt)
    end
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end


return Player
