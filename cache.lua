local cache = {}
cache.assets = {}

-- Allow to only load an asset once
function cache:getOrLoad(path)
  if cache.assets[path] then
    return cache.assets[path]
  else
    local asset = love.graphics.newImage(path)
    asset:setFilter("nearest","nearest")

    cache.assets[path] = asset

    return asset
  end
end

return cache
