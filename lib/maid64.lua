function maid64(pixels)
   maid64 = {}
    maid64.size = pixels or 64
    maid64.scaler = love.graphics.getHeight() / maid64.size
    maid64.x = love.graphics.getWidth()/2-(maid64.scaler*(maid64.size/2))
    maid64.y = love.graphics.getHeight()/2-(maid64.scaler*(maid64.size/2))
    maid64.canvas = love.graphics.newCanvas(maid64.size, maid64.size)
    maid64.canvas:setFilter("nearest","nearest")

end
function love.draw()
   love.graphics.setCanvas(maid64.canvas)
   love.graphics.clear()
   maid64_draw()
   love.graphics.setCanvas()
   love.graphics.draw(maid64.canvas, maid64.x,maid64.y,0,maid64.scaler,maid64.scaler)
end
function love.resize(w, h)
    if h < w then
        maid64.scaler = h / maid64.size
    else
        maid64.scaler = w / maid64.size
    end
    maid64.x = w/2-(maid64.scaler*(maid64.size/2))
    maid64.y = h/2-(maid64.scaler*(maid64.size/2))
end
