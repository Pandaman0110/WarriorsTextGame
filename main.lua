function love.load()
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	timer = require "libraries/timer"
	require "conf"
	require "clan"
	require "gamestates/mainmenu"
	require "gamestates/startup"

	---------------------

	local gameWidth, gameHeight = 1920, 1080 --fixed game resolution
	local windowWidth, windowHeight = love.window.getDesktopDimensions()	
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

	---------------------

	gamestate.switch(startup)
	
end

function love.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
end

function love.update(dt)
	gamestate:update(dt)
end


function love.draw()
	push:start()
		gamestate:draw()
	push:finish()
end

