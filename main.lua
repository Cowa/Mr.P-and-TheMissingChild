require "lib/maid64"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local gamera = require "lib/gamera"
local camera = nil

local Player = require "player"
local world = nil

love.keyboard.setKeyRepeat(true)

function love.load()
  maid64(64)

  world = bump.newWorld(8)

  camera = gamera.new(0, 0, 64, 2000)
  camera:setWindow(0, 0, 64, 64)
  camera:setPosition(0, 0)

  player = Player:new(world)
  world:add(player, player.x, player.y, player.w, player.h)
end

function love.update(dt)
  player:update(dt)
  camera:setPosition(player.x, player.y)
end

function maid64_draw()
  love.graphics.clear()

  camera:draw(function(l, t, w, h)
    bump_debug.draw(world)

    player:draw()
  end)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "right" then
    player:move(player.x + 1, player.y)
  elseif key == "left" then
    player:move(player.x - 1, player.y)
  elseif key == "up" then
    player:move(player.x, player.y - 1)
  elseif key == "down" then
    player:move(player.x, player.y + 1)
  end
end
