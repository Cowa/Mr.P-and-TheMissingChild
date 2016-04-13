require "util"
require "lib/maid64"

local Map = require "map"
local cache = require "cache"

function love.load()
  math.randomseed(os.time())
  local screenSize = 64

  maid64.setup(screenSize)
  love.keyboard.setKeyRepeat(true)

  map = Map:new()
end

function love.update(dt)
  -- handy restart
  if love.keyboard.isDown("r") then
    map = Map:new()
  end

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  map:update(dt)

  love.window.setTitle("Score: " .. map.player.score .. " | FPS: " .. love.timer.getFPS())
end

function love.draw()
  maid64.start()

  map:draw()

  maid64.finish()
end

function love.resize(w, h)
  maid64.resize(w, h)
end
