local drawDetails = false

function love.load(args)
	--this makes sure the person has a save folder
	--if love.filesystem.getInfo("save_names") == nil then
	--	love.filesystem.write("save_names", "example_save\n")
	--elseif love.filesystem.read("saves_names") == nil then
	--	love.filesystem.write("save_names", "example_save\n")
	--end

	love.graphics.setDefaultFilter("nearest", "nearest")

	--third party libraries
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	utf8 = require("utf8")
	bitser = require "libraries/bitser"
	cron = require "libraries/cron"
	sti = require "libraries/sti"
	grid = require "libraries/jumper.grid"
	pathfinder = require "libraries/jumper.pathfinder"

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
	require "Tiles"
	require "Controller"
	require "Timer"

	setupBitser()

	--gamestates
	require "gamestates/mainmenu"
	require "gamestates/startup"
	require "gamestates/options"
	require "gamestates/loadgame"
	require "gamestates/choosecharacter"
	require "gamestates/maingame"
	require "gamestates/play"

	---------------------

	osString = love.system.getOS()
	local gameWidth, gameHeight = 640, 360 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = true, highdpi = true})

	xScale = windowWidth / 640
	yScale = windowHeight / 360

	---------------------
	
	EBG_R_10 = love.graphics.newFont("fonts/EBG_R.ttf", 10 * xScale)
	EBG_R_10:setFilter("nearest", "nearest")

	EBG_R_8 = love.graphics.newFont("fonts/EBG_R.ttf", 8 * xScale)
	EBG_R_8:setFilter("nearest", "nearest")

	EBG_R_20 = love.graphics.newFont("fonts/EBG_R.ttf", 20 * xScale)
	EBG_R_20:setFilter("nearest", "nearest")

	EBG_R_25 = love.graphics.newFont("fonts/EBG_R.ttf", 25 * xScale)
	EBG_R_25:setFilter("nearest", "nearest")

	EBG_I_Large = love.graphics.newFont("fonts/EBG_I.ttf", 15 * xScale)
	EBG_I_Large:setFilter("nearest", "nearest")

	---------------------

	love.keyboard.setKeyRepeat(true)
	gamestate.switch(startup)

	
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	gamestate.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
	if key == "`" then
		if drawDetails == false then drawDetails = true
		elseif drawDetails == true then drawDetails = false end
	end
end

function love.textinput(t)
	gamestate.textinput(t)
end

function love.mousepressed(x, y, button)
	gamestate.mousepressed(x, y, button)
end

function love.update(dt)
	gamestate.update(dt)
end


function love.draw()
	push:start()
		love.graphics.setDefaultFilter("nearest", "nearest")
		gamestate.draw()

		love.graphics.setFont(EBG_R_10)
		textSettings()

   		if drawDetails == true then love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 560, 10, 0, scX()) end

		clear()

	push:finish()
end

