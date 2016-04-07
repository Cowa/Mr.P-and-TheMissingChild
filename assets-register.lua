local register = {}
register.assets = {}

-- Allow to only load an asset once
function register:getOrLoad(path)
  if register.assets[path] then
    return register.assets[path]
  else
    local asset = love.graphics.newImage(path)
    asset:setFilter("nearest","nearest")

    register.assets[path] = asset

    return asset
  end
end

return register
