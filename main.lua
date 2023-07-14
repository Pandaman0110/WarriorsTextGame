local drawDetails = false
local console = false

function love.load()
	local success = love.filesystem.createDirectory("saves")
	assert(success, "failed to create saves directory")
	success = love.filesystem.createDirectory("levels")
	assert(success, "failed to create levels directory")
	success = love.filesystem.createDirectory("tilesets")
	assert(success, "failed to create tilesets directory")


	love.graphics.setDefaultFilter("nearest", "nearest")

	--third party libraries
	utf8 = require "utf8"
	lume = require "libraries/lume"
	class = require "libraries/middleclass"
	push = require "libraries/push"
	gamestate = require "libraries/gamestate"
	bitser = require "libraries/bitser"
	grid = require "libraries/jumper.grid"
	pathfinder = require "libraries/jumper.pathfinder"
	bresenham = require "libraries/bresenham"
	

	love.profiler = require "libraries/profile"

	require "conf" 

	---misc files
	require	"misc/buttons"
	require "misc/functions"
	require "misc/saving"

	--classes
	require "classes/Tree/CompositeNode"
	require "classes/Tree/DecoratorNode"
	require "classes/Tree/LeafNode"
	require "classes/Tree/Node"
	require "classes/Tree/Tree"
	require "classes/AnimalAi"
	require "classes/CatGenerator"
	require "classes/CatHandler"
	require "classes/Cats"
	require "classes/Clan"
	require "classes/Controller"
	require "classes/Editor"
	require "classes/GameHandler"
	require "classes/Handler"
	require "classes/Location"
	require "classes/Map"
	require "classes/Medical"
	require "classes/Relationship"
	require "classes/Timer"

	--gamestates
	require "gamestates/choosecharacter"
	require "gamestates/leveleditor/leveleditor"
	require "gamestates/leveleditor/leveleditor_editmenu"
	require "gamestates/leveleditor/leveleditor_filemenu"
	require "gamestates/leveleditor/leveleditor_loadmap"
	require "gamestates/leveleditor/leveleditor_mapmenu"
	require "gamestates/leveleditor/leveleditor_newmap"
	require "gamestates/leveleditor/leveleditor_properties"
	require "gamestates/loadgame"
	require "gamestates/maingame"
	require "gamestates/mainmenu"
	require "gamestates/options"
	require "gamestates/play"
	require "gamestates/startup"
	require "gamestates/warning"

	--gamedata
	require "gamedata/data"
	require "gamedata/behaviordata"
	---------------------

	osString = love.system.getOS()
	local gameWidth, gameHeight = 640, 360 --fixed game resolution
	windowWidth, windowHeight = love.window.getDesktopDimensions()
	--windowWidth, windowHeight = 1280, 720
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = true, highdpi = true})

	xScale = windowWidth / 640
	yScale = windowHeight / 360

	---------------------

	fileHandler = FileHandler:new()
	fileHandler:setupBitser()


	local tile_set = {[0] = "grass", "rock"}

	optionsHandler = OptionsHandler:new()

	--------------------- 

	EBG_R_10 = love.graphics.newFont("fonts/EBG_R.ttf", 10 * xScale, "normal")
	EBG_R_10:setFilter("linear", "nearest")

	EBG_R_8 = love.graphics.newFont("fonts/EBG_R.ttf", 8 * xScale, "normal")
	EBG_R_8:setFilter("linear", "nearest")

	EBG_R_20 = love.graphics.newFont("fonts/EBG_R.ttf", 20 * xScale, "normal")
	EBG_R_20:setFilter("linear", "nearest")

	EBG_R_25 = love.graphics.newFont("fonts/EBG_R.ttf", 25 * xScale, "normal")
	EBG_R_25:setFilter("linear", "nearest")

	EBG_I_Large = love.graphics.newFont("fonts/EBG_I.ttf", 15 * xScale, "normal")
	EBG_I_Large:setFilter("linear", "nearest")

	PIXEL_FONT = love.graphics.newFont("fonts/EBG_I.ttf", 7, "mono")
	PIXEL_FONT:setFilter("linear", "nearest")

	---------------------

	love.mouse.setCursor(love.mouse.newCursor("Images/cursor_catpaw.png", 7, 7))

	---------------------

	love.keyboard.setKeyRepeat(true)
	gamestate.switch(startup)

	love.frames = 0
	love.frame_timer = 10

end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	gamestate.keypressed(key)
	if key == "escape" then 
		love.event.quit()
	end
	if key == "f2" then
		drawDetails = not drawDetails
	end
	if key == "`" then
		console = not drawDetails
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
	--love.checkPerformance(dt)

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

function love.checkPerformance(dt)
	love.frames = love.frames + 1
	--love.frame_timer = love.frame_timer - dt
	--if love.frames % 1000 == 0 then 
	if love.frame_timer < 0 then 
		love.report = love.profiler.report(10)
		love.profiler.reset()
		print(love.report or "Please wait...")
		love.frames = 0
		love.frame_timer = 10
	end
end