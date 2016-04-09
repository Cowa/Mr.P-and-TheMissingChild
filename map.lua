local _ = require "lib/moses"
local sti = require "lib/sti"
local gamera = require "lib/gamera"
local class = require "lib/middleclass"
local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local Player = require "entity/player"
local Rock = require "entity/rock"

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

  self.player = Player:new(self.world, 20, 20)
end

function Map:update(dt)
  self.map:update(dt)

  self.player:input(dt)
  self.player:update(dt)

  self.camera:setPosition(self.player.x, self.player.y)
end

function Map:draw()
  self.camera:draw(function(l, t, w, h)
    self.map:draw()
    --bump_debug.draw(self.world)
    self.player:draw()
  end)
end

return Map
