module(..., package.seeall)
Base = require('actors/base')
Bullet = require('actors/bullet')
Player = Base:extends()

function Player:__init(x, y)
    self.super.__init(self, x, y)
    self.width = SCALE * 4
    self.height = SCALE * 6
    self.x = x-self.width/2
    self.y = y-self.height/2

    self.state = 3
    self.isTransforming = false
    self.isTransUp = true
    self.transTick = 1
    self.transSpeed = 1

    self.squares = {}
    self.squares[1] = {x=self.x-SCALE*2, y=self.y-SCALE*3}
    self.squares[3] = {x=self.x-SCALE, y=self.y-SCALE*2}
    self.squares[5] = {x=self.x, y=self.y-SCALE}
    self.squares[7] = {x=self.x+SCALE, y=self.y-SCALE}
    self.squares[8] = {x=self.x+SCALE, y=self.y}
    self.squares[6] = {x=self.x, y=self.y}
    self.squares[4] = {x=self.x-SCALE, y=self.y+SCALE}
    self.squares[2] = {x=self.x-SCALE*2, y=self.y+SCALE*2}

    for _, square in pairs(self.squares) do
    	square.width = SCALE
    	square.height = SCALE
    	square.life = 5
    end

    self.bullets = {}
    self.bulletTick = 0

end

function Player:update(dt)
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

    -- Do transformations.
	if self.isTransforming then
		self.transTick = self.transTick + 1
		if self.isTransUp then
			self.squares[1].y = self.squares[1].y - self.transSpeed
			self.squares[2].y = self.squares[2].y + self.transSpeed
			if self.state > 2 then
				self.squares[3].y = self.squares[3].y - self.transSpeed
				self.squares[4].y = self.squares[4].y + self.transSpeed
			end
			if self.state > 3 then
				self.squares[5].y = self.squares[5].y - self.transSpeed
				self.squares[6].y = self.squares[6].y + self.transSpeed
			end
		else
			self.squares[1].y = self.squares[1].y + self.transSpeed
			self.squares[2].y = self.squares[2].y - self.transSpeed
			if self.state > 1 then
				self.squares[3].y = self.squares[3].y + self.transSpeed
				self.squares[4].y = self.squares[4].y - self.transSpeed
			end
			if self.state > 2 then
				self.squares[5].y = self.squares[5].y + self.transSpeed
				self.squares[6].y = self.squares[6].y - self.transSpeed
			end
		end
		if self.transTick == SCALE/self.transSpeed	+ 1 then
			self.isTransforming = false
			self.transTick = 1
		end
	end

	for i, bullet in ipairs(self.bullets) do
		bullet:update(dt)
	end

	-- Destroy old bullets.
	for i, bullet in ipairs(self.bullets) do
		if bullet.x > SW+SCALE then
			table.remove(self.bullets, i)
		end
	end

	global.debugString = #self.bullets
end

function Player:draw()

    -- g.setPixelEffect(global.effect)
	for _, square in pairs(self.squares) do
		g.setColor(square.life*38+50, square.life*38+50, square.life*38+50)
		g.rectangle('fill', square.x, square.y, square.width, square.height)
	end

	g.setColor(240, 240, 240)
	for _, bullet in pairs(self.bullets) do
		bullet:draw()
	end
	-- g.setColor(240, 15, 15)
	-- g.rectangle('line', self.x, self.y, self.width, self.height)
end

function Player:fire()
	self.bulletTick = self.bulletTick + 1
	if self.bulletTick % 3 == 0 then
		for i, square in ipairs(self.squares) do
			if square.life > 0 and 
			((self.state == 1 and i >= 7) or 
			(self.state == 2 and (i > 6 or i < 3)) or
			(self.state == 3 and (i > 6 or i < 5)) or
			self.state == 4) then
				self.bullets[#self.bullets+1] = Bullet:new(square.x-SCALE, square.y+SCALE/2)
			end
		end
	end
end

function Player:transformUp()
	if self.isTransforming == false and self.state < 4 then
		self.speed = self.speed - 3
		self.state = self.state + 1
		self.isTransforming = true
		self.isTransUp = true
	end
end

function Player:transformDown()
	if self.isTransforming == false and self.state > 1 then
		self.speed = self.speed + 3
		self.state = self.state - 1
		self.isTransforming = true
		self.isTransUp = false
	end
end

return Player
