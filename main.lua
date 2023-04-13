local drawDetails = false

function love.load(args)
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
	love.profiler = require "libraries/profile"

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
	
	saveHandler = SaveHandler:new()
	saveHandler:print()

	optionsHandler = OptionsHandler:new()
	optionsHandler:print()

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

	love.profiler.start()
	love.frames = 0
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

	if key == "g" then 
		local cat1, cat2 = genRandomCat("Elder"), genRandomCat("Warrior")
		cat1:setGender("Female")
		cat2:setGender("Male")
	end
end

function love.textinput(t)
	gamestate.textinput(t)
end

function love.mousepressed(x, y, button)
	-- if the player is in the mode with the black boxes this stuff is important
	-- it doenst lock the mouse inside of the game area, but if they click outside of it sets the click to the closest area in the game
	local mx, my = x, y

	local xOff, yOff = push:getOffset()

	if mx > windowWidth - xOff then mx = windowWidth - xOff end
	if mx < 0 + xOff then mx = 0 + xOff end 
	if my > windowHeight - yOff then my = windowHeight - yOff end
	if my < 0 + yOff then my = 0 + yOff end

	gamestate.mousepressed(mx, my, button)
end

function love.update(dt)
	love.frames = love.frames + 1
	if love.frames % 1000 == 0 then 
		love.report = love.profiler.report(10)
		love.profiler.reset()
		print(love.report or "Please wait...")
	end

	gamestate.update(dt)
end


function love.draw()
	push:start()
		love.graphics.setDefaultFilter("nearest", "nearest")
		gamestate.draw()

		love.graphics.setFont(EBG_R_10)
		textSettings()

   		if drawDetails == true then 
   			love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 560, 10, 0, scX()) 
   			--love.graphics.print(love.report or "Please wait...", 10, 10, 0, scX())
   		end

		clear()

	push:finish()
end

