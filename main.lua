function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")

	--third party libraries
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	timer = require "libraries/timer"
	utf8 = require("utf8")

	---misc files
	require "conf"
	require "catfunctions"
	require "data"
	require "buttons"
	require "functions"
	require "saving"

	--classes
	require "Cats"
	require "Clan"

	--gamestates
	require "gamestates/mainmenu"
	require "gamestates/startup"
	require "gamestates/charactercreate"
	require "gamestates/chooseclan"
	require "gamestates/options"

	---------------------

	local gameWidth, gameHeight = 640, 360 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = true, highdpi = true})

	xScale = windowWidth / 640
	yScale = windowHeight / 360

	---------------------
	
	EBG_R_10 = love.graphics.newFont("fonts/EBG_R.ttf", 10 * xScale)
	EBG_R_10:setFilter("nearest", "nearest")

	EBG_R_20 = love.graphics.newFont("fonts/EBG_R.ttf", 20 * xScale)
	EBG_R_20:setFilter("nearest", "nearest")

	EBG_I_Large = love.graphics.newFont("fonts/EBG_I.ttf", 15 * xScale)
	EBG_I_Large:setFilter("nearest", "nearest")

	---------------------

	love.keyboard.setKeyRepeat(true)
	gamestate.switch(startup)

end

function love.keypressed(key)
	gamestate.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
end

function love.textinput(t)
	gamestate.textinput(t)
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
		love.graphics.setDefaultFilter("nearest", "nearest")
		gamestate.draw()
	push:finish()
end

