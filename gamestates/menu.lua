module(..., package.seeall)

local menu = Gamestate.new()

font50 = g.newImageFont("assets/monofontgray50.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
font100 = g.newImageFont("assets/monofontgray100.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
    
function menu:update(dt)
end

function menu:draw()
	g.setFont(font100)
	g.setColor(240, 240, 240)
    g.printf(tostring('VAGITRON 2000'), 0, 100, SW, "center")

	g.setFont(font50)
	g.setColor(240, 240, 240)
    g.printf(tostring('New Game\nEat a Dick'), 0, SH/2, SW, "center")

end

function menu:keypressed(key)
    if key == 'escape' then love.event.push('quit') end
    if key == ' ' then Gamestate.switch(game) end
end

return menu