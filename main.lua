require "lib/maid64"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local gamera = require "lib/gamera"
local camera = nil

local register = require "assets-register"

local Player = require "player"
local World = require "world"

local physicsWorld = nil

local screenSize = 64
local tileSize = 8

love.keyboard.setKeyRepeat(true)

function love.load()
  maid64.setup(screenSize)

  physicsWorld = bump.newWorld(8)

  camera = gamera.new(0, 0, screenSize, 200)
  camera:setWindow(0, 0, screenSize, screenSize)
  camera:setPosition(0, 0)

  player = Player:new(physicsWorld, register)
  physicsWorld:add(player, player.x, player.y, player.w, player.h)

  world = World:new(screenSize, 500, tileSize, register)
  world:generateWorld()
end

function love.update(dt)
  player:input(dt)
  player:update(dt)
  camera:setPosition(player.x, player.y)

  love.window.setTitle("FPS: " .. love.timer.getFPS())
end

function love.draw()
  maid64.start()

  love.graphics.clear(255, 0, 255)

  camera:draw(function(l, t, w, h)
    world:draw()
    --bump_debug.draw(physicsWorld)
    player:draw()
  end)

  maid64.finish()
end

function love.resize(w, h)
  maid64.resize(w, h)
end
