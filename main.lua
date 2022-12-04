function love.load(args)
	--third party libraries
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	timer = require "libraries/timer"

	---misc files
	require "conf"
	require "catfunctions"
	require "data"
	require "buttons"
	require "functions"

	--classes
	require "Cats"
	require "Clan"

	--gamestates
	require "gamestates/mainmenu"
	require "gamestates/startup"
	require "gamestates/CharacterCreate"

	---------------------

	local gameWidth, gameHeight = 1920, 1080 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()	
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, canvas = false, pixelperfect = true, stretched = true})
	love.graphics.setDefaultFilter("nearest", "nearest")

	---------------------


	gamestate.switch(startup)

end

function love.keypressed(key)
	gamestate.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
	if key == "o" then
	end
	if key == "l" then
		testClan = genClan()
		testClan:printMemberDetails()
	end
end

function love.mousepressed(x, y, button)
	gamestate.mousepressed(x, y, button)
end

function love.update(dt)
	timer.update(dt)
	gamestate.update(dt)
end


function love.draw()
	push:start()
		gamestate.draw()
	push:finish()
end

