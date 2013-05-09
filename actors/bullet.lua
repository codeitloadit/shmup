module(..., package.seeall)
Base = require('actors/base')
Bullet = Base:extends()

function Bullet:__init(x, y, angle, speed)
    self.super.__init(self, x, y)
    self.angle = angle or 0
    self.speed = speed or 30
    self.width = SCALE * 2
    self.height = SCALE / 2
    self.x = x-self.width/2
    self.y = y-self.height/2
end

function Bullet:update(dt)
    self.x = self.x + math.cos(math.rad(self.angle)) * self.speed
    self.y = self.y + math.sin(math.rad(self.angle)) * self.speed
end

function Bullet:draw()
	g.setColor(240, 240, 240)
	g.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Bullet
