function love.load(args)
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

	--classes
	require "Cats"
	require "Clan"

	--gamestates
	require "gamestates/mainmenu"
	require "gamestates/startup"
	require "gamestates/charactercreate"
	require "gamestates/chooseclan"

	---------------------

	EBG_R = love.graphics.newFont("fonts/EBG_R.ttf", 16)
	EBG_I_Large = love.graphics.newFont("fonts/EBG_I.ttf", 40)

	EBG_R:setFilter("nearest", "nearest")
	EBG_I_Large:setFilter("nearest", "nearest")

	local gameWidth, gameHeight = 640, 480 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, canvas = false, pixelperfect = true, stretched = true})
	love.graphics.setDefaultFilter("nearest", "nearest")

	xScale = 1920 / windowWidth
	yScale = 1080 / windowHeight

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

