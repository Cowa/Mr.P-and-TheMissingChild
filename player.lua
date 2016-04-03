local class = require "lib/middleclass"

local Player = class("Player")

function Player:initialize(world)
  self.x = 0
  self.y = 0
  self.vx = 0
  self.vy = 0

  self.w = 8
  self.h = 7

  self.world = world

  self.img = love.graphics.newImage("asset/pinguin.png")
end

function Player:update(dt)

end

function Player:move(x, y)
  local actualX, actualY, cols, len = self.world:move(self, x, y)
  self.x = actualX
  self.y = actualY
end

function Player:draw()
  love.graphics.draw(self.img, self.x, self.y)
end


return Player
