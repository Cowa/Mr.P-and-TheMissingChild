local class = require "lib/middleclass"
local cache = require "cache"
local sti = require "lib/sti"
local _ = require "lib/moses"
local bump = require "lib/bump"
local tween = require "lib/tween"

local Game = require "game"
local Algae = require "entity/algae"
local DummyBaby = require "entity/dummy-baby"
local DummyPlayer = require "entity/dummy-player"
local Rock = require "entity/rock"

local End = class("End")

function End:initialize()
  self.map = sti.new("asset/end.lua")
  self.world = bump.newWorld(1)

  self.volume = { volume = 0.0 }

  self.title = {
    opacity = 0
  }

  self.showTitleTween = tween.new(2, self.title, { opacity = 255 } )

  self.endTitle = cache:getOrLoadImage("asset/end-title.png")

  self.music = cache:getOrLoadSound("asset/music/menu.mp3")
  self.music:setLooping(true)

  local algaes = self.map.layers["algae"].objects

  self.algaes = _.map(algaes, function (i, e)
    return Algae:new(self.world, e.x, e.y, e.width, e.height, e.type)
  end)

  local collisionEntities = self.map.layers["collision"].objects

  _.each(collisionEntities, function (i, e)
    Rock:new(self.world, e.x, e.y, e.width, e.height)
  end)

  local baby = self.map.layers["baby"].objects[1]

  self.baby = DummyBaby:new(self.world, baby.x, baby.y)
  self.baby.position = "stand"

  self.musicTween = tween.new(2, self.volume, { volume = 1.0 } )

  local player = self.map.layers["player"].objects[1]
  self.player = DummyPlayer:new(self.world, player.x, player.y)
end

function End:update(dt)
  self.map:update(dt)
  _.each(self.algaes, function (i, e) e:update(dt) end)
  self.baby:update(dt)
  self.player:update(dt)

  self.showTitleTween:update(dt)

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

  self.musicTween:update(dt)
  self.music:setVolume(self.volume.volume)

  self.music:play()
end

function End:draw()
  self.map:draw()
  _.each(self.algaes, function (i, e) e:draw() end)
  self.player:draw(true)
  self.baby:draw()

  love.graphics.setColor(255, 255, 255, self.title.opacity)
  love.graphics.draw(self.endTitle)

  love.graphics.setColor(255, 255, 255, 255)
end

return End
