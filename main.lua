Class = require('lib.hump.class')
Gamestate = require('lib.hump.gamestate')
-- menu = require('gamestates.menu')
game = require('gamestates.game')

function love.load()
    love.mouse.setVisible(false)
    g = love.graphics
    keyDown = love.keyboard.isDown

	-- global.effect = g.newPixelEffect [[
	-- 		extern Image target_image;
	-- 		extern number s; // from 0 to 1
	-- 		vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pc )
	-- 		{
	-- 		    vec4 pixel_from = Texel(texture, tc);
	-- 		    vec4 pixel_to = Texel(target_image, tc);
	-- 		    // you don't have to add the individual channels here
	-- 		    return (1.0 - s) * pixel_from + s * pixel_to;
	-- 		    // you could also write:
	-- 		    // return (1.0 - s) * Texel(texture,tx) + s * Texel(target_image, tc);
	-- 		}
	--     ]]

    Gamestate.registerEvents()
    Gamestate.switch(game)
end
