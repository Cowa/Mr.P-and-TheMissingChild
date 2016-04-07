local class = require "lib/middleclass"

local World = class("World")

function World:initialize(width, height, tileSize)
  self.width = width
  self.height = height
  self.tileSize = tileSize

  self.cols = width / tileSize
  self.lines = height / tileSize

  -- world is a grid, tile 8x8
  self.grid = {}
end

function World:generateWorld()
  for x = 1, self.lines do
    self.grid[x] = {}
    for y = 1, self.cols do
      self.grid[x][y] = self:generateTile(x, y)
    end
  end
end

function World:generateTile(x, y)
  -- On first row
  if y == 1 then
    return self:generateFirstRow(x)
  elseif x == 1 then
    return { type = "rock-left", img = loadImage("asset/rock-left.png") }
  elseif x == self.cols then
    return { type = "rock-right", img = loadImage("asset/rock-right.png") }
  else
    return { type = "water-still", img = loadImage("asset/water-still.png") }
  end
end

function World:generateFirstRow(y)
  if y == 1 then
    return { type = "rock-top-left", img = loadImage("asset/rock-top-left.png") }

  elseif y == self.cols then
    return { type = "rock-top-right", img = loadImage("asset/rock-top-right.png") }

  else
    return { type = "water-top", img = loadImage("asset/water-top.png") }
  end
end

function World:draw()
  for line = 1, self.lines do
    for col = 1, self.cols do
      local img = self.grid[line][col].img
      local x = (line - 1) * self.tileSize
      local y = (col - 1) * self.tileSize

      love.graphics.draw(img, x, y)
    end
  end
end

function loadImage(path)
  local img = love.graphics.newImage(path)
  img:setFilter("nearest","nearest")

  return img
end

return World
