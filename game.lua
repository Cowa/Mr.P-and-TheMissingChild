local _ = require "lib/moses"
local sti = require "lib/sti"
local gamera = require "lib/gamera"
local class = require "lib/middleclass"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"
local cache = require "cache"
local tween = require "lib/tween"

local Player = require "entity/player"
local Rock = require "entity/rock"
local Algae = require "entity/algae"
local Fish = require "entity/fish"
local Coin = require "entity/coin"
local Baby = require "entity/baby"
local Exit = require "entity/exit"

local Game = class("Game")

function Game:initialize()
  self.width = 64
  self.height = 122

  self.music = { src = cache:getOrLoadSound("asset/music/game.mp3"), volume = 0.0 }
  self.music.src:setLooping(true)
  self.music.src:play()

  self.blackBox = { opacity = 0 }

  self.playMusicTween = tween.new(2, self.music, { volume = 1.0 })
  self.shutMusicTween = tween.new(1, self.music, { volume = 0.0 })
  self.hideGameWhenExit = tween.new(1, self.blackBox, { opacity = 255 })

  -- once exit with baby
  self.finished = false

  self.camera = gamera.new(0, 0, self.width, self.height)
  self.camera:setWindow(0, 0, self.width, self.width)
  self.camera:setPosition(0, 0)

  self.world = bump.newWorld(1)

  self.map = sti.new("asset/map1.lua")

  local collisionEntities = self.map.layers["collision"].objects

  _.each(collisionEntities, function (i, e)
    Rock:new(self.world, e.x, e.y, e.width, e.height)
  end)

  local algaes = self.map.layers["algae"].objects

  self.algaes = _.map(algaes, function (i, e)
    return Algae:new(self.world, e.x, e.y, e.width, e.height, e.type)
  end)

  local fishes = self.map.layers["fish"].objects

  self.fishes = _.map(fishes, function (i, e)
    return Fish:new(self.world, e.x, e.y, e.width, e.height, e.type)
  end)

  local coins = self.map.layers["coin"].objects

  self.coins = _.map(coins, function (i, e)
    return Coin:new(self.world, e.x, e.y, e.width, e.height)
  end)

  local exit = self.map.layers["exit"].objects[1]

  Exit:new(self.world, exit.x, exit.y, exit.width, exit.height)

  local baby = self.map.layers["baby"].objects[1]

  self.player = Player:new(self.world, 11, 5)
  self.baby = Baby:new(self.world, baby.x, baby.y)
end

function Game:update(dt)
  self.map:update(dt)
  _.each(self.algaes, function (i, e) e:update(dt) end)
  _.each(self.fishes, function (i, e) e:update(dt) end)
  _.each(self.coins, function (i, e) e:update(dt) end)

  self.player:update(dt)
  self.baby:update(dt)

  if self.player.exit then
    local musicShut = self.shutMusicTween:update(dt)
    self.hideGameWhenExit:update(dt)

    if musicShut then
      switchMenu()
    end
  else
    self.playMusicTween:update(dt)
  end

  self.music.src:setVolume(self.music.volume)

  self.camera:setPosition(self.player.x, self.player.y)

  if love.keyboard.isDown("escape") then
    switchMenu()
  end
end

function Game:draw()
  self.camera:draw(function(l, t, w, h)
    self.map:draw()
    self.player:draw()
    self.baby:draw()

    _.each(self.algaes, function (i, e) e:draw() end)
    _.each(self.fishes, function (i, e) e:draw() end)
    _.each(self.coins, function (i, e) e:draw() end)

    love.graphics.setColor(0, 0, 0, self.blackBox.opacity)
    love.graphics.rectangle("fill", 0, 0, 64, 64)
    love.graphics.setColor(255, 255, 255, 255)
  end)
end

return Game
