local bump = require "lib/bump"
local bump_debug = require "lib/bump_debug"

local class = require "lib/middleclass"

local Player = require "entity/player"

local Map = class("Map")
local gamera = require "lib/gamera"

local sti = require "lib/sti"

function Map:initialize()
  self.width = 64
  self.height = 200

  self.camera = gamera.new(0, 0, self.width, self.height)
  self.camera:setWindow(0, 0, self.width, self.width)
  self.camera:setPosition(0, 0)

  self.map = sti.new("asset/map1.lua")

  self.world = bump.newWorld(8)

  self.player = Player:new(self.world, 16, 16)
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
    self.player:draw()
  end)
end

return Map
