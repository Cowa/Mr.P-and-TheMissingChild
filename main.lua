require "util"
require "lib/maid64"

local Map = require "map"
local Menu = require "menu"
local State = require "state"
local cache = require "cache"

function love.load()
  math.randomseed(os.time())

  maid64.setup(64)
  love.keyboard.setKeyRepeat(true)

  state = State:new()

  menu = Menu:new()

  state:set(menu)

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

  if love.keyboard.isDown("n") then
    state:set(map)
  end

  state:update(dt)

  love.window.setTitle("FPS: " .. love.timer.getFPS())
end

function love.draw()
  maid64.start()

  state:draw()

  maid64.finish()
end

function love.resize(w, h)
  maid64.resize(w, h)
end
