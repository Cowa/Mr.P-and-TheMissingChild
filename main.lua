require "lib/maid64"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local gamera = require "lib/gamera"
local camera = nil

local Player = require "player"
local World = require "world"

local physicsWorld = nil

local screenSize = 64
local tileSize = 8

love.keyboard.setKeyRepeat(true)

function love.load()
  maid64(screenSize)

  physicsWorld = bump.newWorld(8)

  camera = gamera.new(0, 0, screenSize, 200)
  camera:setWindow(0, 0, screenSize, screenSize)
  camera:setPosition(0, 0)

  player = Player:new(physicsWorld)
  physicsWorld:add(player, player.x, player.y, player.w, player.h)

  world = World:new(screenSize, 500, tileSize)
  world:generateWorld()
end

function love.update(dt)
  player:input(dt)
  player:update(dt)
  camera:setPosition(player.x, player.y)

  love.window.setTitle("FPS: " .. love.timer.getFPS())
end

function maid64_draw()
  love.graphics.clear(255, 0, 255)

  camera:draw(function(l, t, w, h)
    --bump_debug.draw(physicsWorld)
    world:draw()

    player:draw()
  end)
end
