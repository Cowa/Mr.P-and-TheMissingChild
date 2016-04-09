require "util"
require "lib/maid64"

local Map = require "map"
local cache = require "cache"

function love.load()
  local screenSize = 64

  maid64.setup(screenSize)
  love.keyboard.setKeyRepeat(true)

  map = Map:new()
end

function love.update(dt)
  map:update(dt)

  love.window.setTitle("FPS: " .. love.timer.getFPS())
end

function love.draw()
  maid64.start()

  love.graphics.clear(0, 0, 0)

  map:draw()

  maid64.finish()
end

function love.resize(w, h)
  maid64.resize(w, h)
end
