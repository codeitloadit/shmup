module(..., package.seeall)
Base = require('actors/base')
Bullet = require('actors/bullet')
Enemy1 = Base:extends()

function Enemy1:__init(x, y)
    self.super.__init(self, x, y)
    self.width = SCALE * 4
    self.height = SCALE * 6
    self.x = x-self.width/2
    self.y = y-self.height/2
    self.speed = 2
    self.radius = self.width

    self.squares = {}
    self.squares[1] = {x=self.x-SCALE, y=self.y-SCALE*2}
    self.squares[3] = {x=self.x, y=self.y-SCALE}
    self.squares[5] = {x=self.x, y=self.y}
    self.squares[7] = {x=self.x-SCALE, y=self.y}
    self.squares[8] = {x=self.x-SCALE*2, y=self.y}
    self.squares[6] = {x=self.x+SCALE, y=self.y}
    self.squares[4] = {x=self.x, y=self.y+SCALE}
    self.squares[2] = {x=self.x-SCALE, y=self.y+SCALE*2}

    for _, square in pairs(self.squares) do
    	square.width = SCALE
    	square.height = SCALE
    	square.life = 5
    end

    self.bullets = {}
    self.bulletTick = 0
end

function Enemy1:update(dt)
	-- Update postion.
    if self.angle >= 0 then
    	local ox = math.cos(math.rad(self.angle)) * self.speed
    	local oy = math.sin(math.rad(self.angle)) * self.speed

    	if self.x + ox < 0 then ox = 0 - self.x end
    	if self.x + ox > SW-self.width then ox = SW-self.width - self.x end
    	if self.y + oy < 0 then oy = 0 - self.y end
    	if self.y + oy > SH-self.height then oy = SH-self.height - self.y end
        self.x = self.x + ox
        self.y = self.y + oy

        for _, square in pairs(self.squares) do
        	square.x = square.x + ox
        	square.y = square.y + oy
        end
	end

	-- Update bounding box size and offset.
    self.x = self.squares[1].x
    self.y = self.squares[1].y
    self.height = self.squares[2].y-self.squares[1].y+SCALE

	for i, bullet in ipairs(self.bullets) do
		bullet:update(dt)
	end

	-- Destroy old bullets.
	for i, bullet in ipairs(self.bullets) do
		if bullet.x < 0-SCALE then
			table.remove(self.bullets, i)
		end
	end
end

function Enemy1:draw()
	g.setColor(240, 240, 240)
	for _, square in pairs(self.squares) do
		g.setColor(square.life*38+50, square.life*38+50, square.life*38+50)
		g.rectangle('fill', square.x, square.y, SCALE, SCALE)
	end

	for _, bullet in pairs(self.bullets) do
		bullet:draw()
	end
	-- g.setColor(240, 15, 15)
	-- g.rectangle('line', self.x, self.y, self.width, self.height)
end

function Enemy1:fire()
	self.bulletTick = self.bulletTick + 1
	if self.bulletTick % 20 == 0 then
		for i, square in ipairs(self.squares) do
			if square.life > 0 and i == 1 then
				self.bullets[#self.bullets+1] = Bullet:new(square.x-SCALE, square.y+SCALE/2, 190, 10)
			end
			if square.life > 0 and i == 2 then
				self.bullets[#self.bullets+1] = Bullet:new(square.x-SCALE, square.y+SCALE/2, 170, 10)
			end
			if square.life > 0 and i == 8 then
				self.bullets[#self.bullets+1] = Bullet:new(square.x-SCALE, square.y+SCALE/2, 180, 10)
			end
		end
	end
end

return Enemy1
