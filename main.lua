function love.load(args)
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	timer = require "libraries/timer"
	Slab = require "libraries/Slab"
	require "conf"
	require "clan"
	require "functions"
	require "gamestates/mainmenu"
	require "gamestates/startup"

	---------------------

	local gameWidth, gameHeight = 1920, 1080 --fixed game resolution
	local windowWidth, windowHeight = love.window.getDesktopDimensions()	
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})
	love.graphics.setDefaultFilter("nearest", "nearest")

	---------------------

	Slab.Initialize(args)

	gamestate.switch(startup)
	
end

function love.keypressed(key)
	gamestate.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
end

function love.update(dt)
	timer.update(dt)
	Slab.Update(dt)
	gamestate.update(dt)
end


function love.draw()
	push:start()
		gamestate.draw()
		Slab.Draw()
	push:finish()
end

