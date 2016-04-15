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

  self.title = {
    displayed = false, opacity = 0,
    pressEnterDisplayed = false, opacityPressEnter = 0
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


  self.babyTween = tween.new(3, self.baby, {x = self.baby.x + 20})
  self.titleTween = tween.new(1.5, self.title, { opacity = 255 } )
  self.pressTween = tween.new(1, self.title, { opacityPressEnter = 255 } )

  local player = self.map.layers["player"].objects[1]
  self.player = DummyPlayer:new(self.world, player.x, player.y)
end

function Menu:update(dt)
  self.map:update(dt)
  _.each(self.algaes, function (i, e) e:update(dt) end)
  self.baby:update(dt)
  self.player:update(dt)
  local isBabyLost = self.babyTween:update(dt)

  if isBabyLost then
    self.title.displayed = true
    local titleDisplayed = self.titleTween:update(dt)

    if titleDisplayed then
      self.title.pressEnterDisplayed = true
      self.pressTween:update(dt)
    end
  end

  if love.keyboard.isDown("return") then
    state:set(game)
  end
end

function Menu:draw()
  self.map:draw()
  _.each(self.algaes, function (i, e) e:draw() end)
  self.player:draw(self.title.displayed)
  self.baby:draw()

  if self.title.displayed then
    love.graphics.setColor(255, 255, 255, self.title.opacity)
    love.graphics.draw(self.menuTitle)
  end

  if self.title.pressEnterDisplayed then
    love.graphics.setColor(255, 255, 255, self.title.opacityPressEnter)
    love.graphics.draw(self.pressEnter)
  end

  love.graphics.setColor(255, 255, 255, 255)
end

return Menu
