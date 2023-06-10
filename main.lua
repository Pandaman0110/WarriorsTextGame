local drawDetails = false

function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")

	--third party libraries
	utf8 = require "utf8"
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	bitser = require "libraries/bitser"
	cron = require "libraries/cron"
	sti = require "libraries/sti"
	grid = require "libraries/jumper.grid"
	pathfinder = require "libraries/jumper.pathfinder"
	love.profiler = require "libraries/profile"

	require "conf" 

	---misc files
	require	"misc/buttons"
	require "misc/data"
	require "misc/functions"
	require "misc/saving"

	--classes
	require "classes/CatGenerator"
	require "classes/Cats"
	require "classes/Clan"
	require "classes/Controller"
	require "classes/Editor"
	require "classes/Handler"
	require "classes/Medical"
	require "classes/Relationship"
	require "classes/Tiles"
	require "classes/Timer"

	--gamestates
	require "gamestates/choosecharacter"
	require "gamestates/leveleditor"
	require "gamestates/loadgame"
	require "gamestates/maingame"
	require "gamestates/mainmenu"
	require "gamestates/options"
	require "gamestates/play"
	require "gamestates/startup"


	---------------------

	osString = love.system.getOS()
	local gameWidth, gameHeight = 640, 360 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = true, highdpi = true})

	xScale = windowWidth / 640
	yScale = windowHeight / 360

	---------------------
	
	saveHandler = SaveHandler:new()
	--saveHandler:print()

	optionsHandler = OptionsHandler:new()
	--optionsHandler:print()

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
	gamestate.switch(choosecharacter)

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
	--love.checkPerformance()

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

		clearTextSettings()

	push:finish()
end

function love.checkPerformance()
	love.frames = love.frames + 1
	if love.frames % 1000 == 0 then 
		love.report = love.profiler.report(10)
		love.profiler.reset()
		print(love.report or "Please wait...")
	end
end