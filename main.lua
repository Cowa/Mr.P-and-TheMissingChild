require "util"
require "lib/maid64"

local Game = require "game"
local Menu = require "menu"
local End = require "end"
local State = require "state"
local cache = require "cache"

function love.load()
  math.randomseed(os.time())

  maid64.setup(64)
  love.keyboard.setKeyRepeat(true)

  state = State:new()

  switchMenu()
end

function switchMenu()
  local menu = Menu:new()
  state:set(menu)
end

function switchGame()
  local game = Game:new()
  state:set(game)
end

function switchEnd()
  local ending = End:new()
  state:set(ending)
end

function love.update(dt)
  state:update(dt)

  love.window.setTitle("Mr. P and the missing child | FPS: " .. love.timer.getFPS())
end

function love.draw()
  maid64.start()

  state:draw()

  maid64.finish()
end

function love.resize(w, h)
  maid64.resize(w, h)
end
