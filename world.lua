local anim8 = require "lib/anim8"
local class = require "lib/middleclass"

local World = class("World")

function World:initialize(width, height, tileSize, register)
  self.width = width
  self.height = height
  self.tileSize = tileSize

  self.cols = width / tileSize
  self.lines = height / tileSize

  self.register = register
  self.spritesheet = register:getOrLoad("asset/spritesheet.png")

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
  if x == 1 then
    return self:generateFirstRow(y)
  elseif y == 1 then
    return self:createTile("rock-left")
  elseif y == self.cols then
    return self:createTile("rock-right")
  else
    return self:createTile("water-still")
  end
end

function World:generateFirstRow(y)
  if y == 1 then
    return self:createTile("rock-top-left")

  elseif y == self.cols then
    return self:createTile("rock-top-right")

  else
    return self:createTile("water-top")
  end
end

function World:createTile(name)
  local tile = { type = name, isAnimated = false }

  if name == "water-top" then
    local g = anim8.newGrid(8, 8, 64, self.spritesheet:getHeight(), 0, 16)
    local animation = anim8.newAnimation(g('1-8', 1), 0.5)

    tile.animation = animation
    tile.isAnimated = true

    return tile
  end

  if name == "rock-top-left" then
    tile.img = self.register:getOrLoad("asset/rock-top-left.png")

    return tile

  elseif name == "rock-top-right" then
    tile.img = self.register:getOrLoad("asset/rock-top-right.png")

    return tile

  elseif name == "rock-right" then
    tile.img = self.register:getOrLoad("asset/rock-right.png")

    return tile

  elseif name == "rock-left" then
    tile.img = self.register:getOrLoad("asset/rock-left.png")

    return tile

  else
    tile.img = self.register:getOrLoad("asset/water-still.png")

    return tile
  end

end

function World:update(dt)
  for line = 1, self.lines do
    for col = 1, self.cols do
      local tile = self.grid[line][col]

      if tile.isAnimated then
        tile.animation:update(dt)
      end
    end
  end
end

function World:draw()
  for line = 1, self.lines do
    for col = 1, self.cols do
      local tile = self.grid[line][col]
      local x = (line - 1) * self.tileSize
      local y = (col - 1) * self.tileSize

      if tile.isAnimated then
        tile.animation:draw(self.spritesheet, y, x)

      else
        love.graphics.draw(tile.img, y, x)
      end
    end
  end
end

return World
