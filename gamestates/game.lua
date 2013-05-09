module(..., package.seeall)
local game = Gamestate.new()

Player = require('actors/player')
Enemy1 = require('actors/enemy1')

player = Player:new(50, SH/2)

enemies = {}
enemies[#enemies+1] = Enemy1:new(SW-50, SH/2)

function game:update(dt)
	-- Player movement.
    player.angle = -1
    if keyDown('w') and keyDown('d') then
        player.angle = 315
    elseif keyDown('w') and keyDown('a') then
        player.angle = 225
    elseif keyDown('s') and keyDown('d') then
        player.angle = 45
    elseif keyDown('s') and keyDown('a') then
        player.angle = 135
    elseif keyDown('w') then
        player.angle = 270
    elseif keyDown('s') then
        player.angle = 90
    elseif keyDown('a') then
        player.angle = 180
    elseif keyDown('d') then
        player.angle = 0
    end

    if keyDown('left') then
    	player:fire()
    end

    player:update(dt)

    for _, enemy in pairs(enemies) do
        -- enemy.angle = math.deg(math.atan2(player.y - enemy.y, player.x - enemy.x)) + 360;
        enemy:update(dt)

        -- Enemy Collision.  (Flocking)
        local isCollidingWithEnemy = false
        -- for i, otherEnemy in ipairs(enemies) do
        --     if enemy ~= otherEnemy and isColliding(enemy, otherEnemy) then
        --         local collisionAngle = getAngle(otherEnemy, enemy)
        --         isCollidingWithEnemy = true
        --         enemy.angle = collisionAngle
        --     end
        -- end

        if isCollidingWithEnemy == false then
            updateAngle(enemy, player)
        end

        updateCords(enemy, enemy.angle, enemy.speed)

        enemy:fire()

        for i, bullet in ipairs(enemy.bullets) do
            for _, square in pairs(player.squares) do
                if square.life > 0 and intersects(bullet, square) then
                    table.remove(enemy.bullets, i)
                    square.life = square.life - 1
                end
            end
        end

        for i, bullet in ipairs(player.bullets) do
            for _, square in pairs(enemy.squares) do
                if square.life > 0 and intersects(bullet, square) then
                    table.remove(player.bullets, i)
                    square.life = square.life - 1
                end
            end
        end
    end


end



function getDistance(a, b)
    return math.sqrt((a.x - b.x ) * ( a.x - b.x) + (a.y - b.y) * (a.y - b.y));
end

function isColliding(a, b)
    return getDistance(a, b) <= a.radius + b.radius;
end

function getAngle(object, target)
    return math.deg(math.atan2(target.y - object.y, target.x - object.x)) + 360;
end

function updateAngle(object, target)
    object.angle = getAngle(object, target)
end

function updateCords(object, angle, speed)
    if angle >= 0 then
        object.x = object.x + math.cos(math.rad(angle)) * speed;
        object.y = object.y + math.sin(math.rad(angle)) * speed;
    end
end

function drawParticleSystem(ps)
    if global.debug == false then
        love.graphics.setColorMode("modulate")
        love.graphics.setBlendMode("additive")
        love.graphics.draw(ps)
    end
end

function drawDebug(object)
    if global.debug then
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(255, 0, 0)
        -- love.graphics.rectangle("line", object.x-object.width/2, object.y-object.height/2, object.width, object.height)
        love.graphics.circle("line", object.x, object.y, object.radius)
    end
end

function intersects(a, b)
    return a.x + a.width > b.x and a.y + a.height > b.y and a.x < b.x + b.width and a.y < b.y + b.height
end




function game:draw()
    player:draw()
    for _, enemy in pairs(enemies) do
        enemy:draw()
    end

    g.setColor(240, 240, 240)
    g.print('FPS: '..tostring(love.timer.getFPS()..
        '\nDebug: '..global.debugString), 0, 0)
end

function game:keypressed(key)
    if key == 'escape' then love.event.push('quit') end
    -- if key == 'r' then Gamestate.switch(game) end
    if key == 'up' then player:transformUp() end
    if key == 'down' then player:transformDown() end

    if key == ' ' then 
        enemies[#enemies+1] = Enemy1:new(SW-50, SH/2)
    end
end

return game