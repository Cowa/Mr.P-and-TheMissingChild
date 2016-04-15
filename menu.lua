local class = require "lib/middleclass"
local cache = require "cache"
local sti = require "lib/sti"
local _ = require "lib/moses"
local bump = require "lib/bump"
local tween = require "lib/tween"

local Algae = require "entity/algae"
local DummyBaby = require "entity/dummy-baby"
local DummyPlayer = require "entity/dummy-player"
local Rock = require "entity/rock"

local Menu = class("Menu")

function Menu:initialize()
  self.map = sti.new("asset/menu.lua")
  self.world = bump.newWorld(1)

  self.volume = { volume = 0.0 }

  self.music = cache:getOrLoadSound("asset/music/menu.mp3")
  self.music:setLooping(true)

  self.title = {
    displayed = false, opacity = 0,
    pressEnterDisplayed = false, opacityPressEnter = 0,
    pressedEnter = false
  }

  self.menuTitle = cache:getOrLoadImage("asset/menu-title.png")
  self.pressEnter = cache:getOrLoadImage("asset/menu-press.png")

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
  self.baby.position = "swim"

  self.moveBabyTween = tween.new(3, self.baby, {x = self.baby.x + 20})
  self.showTitleTween = tween.new(2, self.title, { opacity = 255 } )
  self.showPressEnterTween = tween.new(1, self.title, { opacityPressEnter = 255 } )

  self.hideTitleTween = tween.new(1, self.title, { opacity = 0 } )
  self.hidePressTween = tween.new(1, self.title, { opacityPressEnter = 0 } )

  self.musicTween = tween.new(2, self.volume, { volume = 1.0 } )
  self.lowerMusicTween = tween.new(2, self.volume, { volume = 0.0 } )

  local player = self.map.layers["player"].objects[1]
  self.player = DummyPlayer:new(self.world, player.x, player.y)
end

function Menu:update(dt)
  self.map:update(dt)
  _.each(self.algaes, function (i, e) e:update(dt) end)
  self.baby:update(dt)
  self.player:update(dt)
  local isBabyLost = self.moveBabyTween:update(dt)

  if isBabyLost then
    self.musicTween:update(dt)
    self.music:setVolume(self.volume.volume)

    self.music:play()
    self.title.displayed = true
    local titleDisplayed = self.showTitleTween:update(dt)

    if titleDisplayed then
      self.title.pressEnterDisplayed = true
      self.showPressEnterTween:update(dt)
    end
  end

  if self.title.pressedEnter then
    local musicMute = self.lowerMusicTween:update(dt)
    self.music:setVolume(self.volume.volume)

    self.hidePressTween:update(dt)
    self.hideTitleTween:update(dt)

    if musicMute then
      state:set(game)
    end
  end

  if love.keyboard.isDown("return") then
    self.title.pressedEnter = true
  end
end

function Menu:draw()
  self.map:draw()
  _.each(self.algaes, function (i, e) e:draw() end)
  self.player:draw(self.title.displayed)
  self.baby:draw()

  love.graphics.setColor(255, 255, 255, self.title.opacity)
  love.graphics.draw(self.menuTitle)

  love.graphics.setColor(255, 255, 255, self.title.opacityPressEnter)
  love.graphics.draw(self.pressEnter)

  love.graphics.setColor(255, 255, 255, 255)
end

return Menu
