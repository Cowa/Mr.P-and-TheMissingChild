local class = require "lib/middleclass"
local cache = require "cache"

local Menu = class("Menu")

function Menu:initialize()
  self.img = cache:getOrLoadImage("asset/menu.png")
end

function Menu:update(dt)

end

function Menu:draw()
  love.graphics.draw(self.img)
end

return Menu
