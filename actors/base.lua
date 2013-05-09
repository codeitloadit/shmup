module(..., package.seeall)
class = require('lib/30log')
Base = class()

function Base:__init(x, y)
    self.bbox = {x=x, y=y, width=0, height=0}
    self.angle = -1
    self.speed = 8
end

function Base:update(dt)
    
end

function Base:draw()
end

return Base