local _ = require "lib/moses"
local sti = require "lib/sti"
local gamera = require "lib/gamera"
local class = require "lib/middleclass"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local Player = require "entity/player"
local Rock = require "entity/rock"
local Algae = require "entity/algae"
local Fish = require "entity/fish"

local Map = class("Map")

function Map:initialize()
  self.width = 64
  self.height = 200

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

  self.player = Player:new(self.world, 15, 20)
end

function Map:update(dt)
  self.map:update(dt)
  _.each(self.algaes, function (i, e) e:update(dt) end)
  _.each(self.fishes, function (i, e) e:update(dt) end)

  self.player:input(dt)
  self.player:update(dt)

  self.camera:setPosition(self.player.x, self.player.y)
end

function Map:draw()
  self.camera:draw(function(l, t, w, h)
    self.map:draw()
    --bump_debug.draw(self.world)
    self.player:draw()

    _.each(self.algaes, function (i, e) e:draw() end)
    _.each(self.fishes, function (i, e) e:draw() end)
  end)
end

return Map
