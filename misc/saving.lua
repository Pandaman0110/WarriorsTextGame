FileHandler = class("Handler")

local save_directory = "saves/"
local levels_directory = "levels/"
local tile_set_directory = "tilesets/"

function FileHandler:initialize()
end

function FileHandler:delete(dir)
	love.filesystem.remove(dir)
end

function FileHandler:saveLevel(map, row_width, column_width, level_name)
	local path = levels_directory .. level_name .. ".txt"
	--[[
	if love.filesystem.getInfo(path) then 
		return gamestate.push(warning, "attempt to overwrite level at location: " .. path .. "\nContinue?")
	end 
	]]
	local level = {map, row_width, column_width}

	level = bitser.dumps(level)

	assert(love.filesystem.write(path, level), "failure to write: " .. level_name .. " to path: " .. path)
end

function FileHandler:saveGame(game_save, save_name)
	local path = save_directory .. save_name .. ".txt"
	assert(not love.filesystem.getInfo(path), "attempt to overwrite level at location: " .. path) 
	game_save = bitser.dumps(game_save)
	love.filesystem.write(path, game_save)
end

function FileHandler:saveOptions()
	bitser.dumpLoveFile("options.txt", optionsHandler)
end

function FileHandler:saveTileSet(tile_set, tile_set_name)
	local path = tile_set_directory .. tile_set_name .. ".txt"
	assert(not love.filesystem.getInfo(path), "attempt to overwrite tileset at location: " .. path) 
	local tile_set = bitser.dumps(tile_set)
	love.filesystem.write(path, tile_set)
end

function FileHandler:deleteLevel(level_name)
	love.filesystem.remove(levels_directory .. level_name .. ".txt")
end

function FileHandler:deleteSave(save_name)
	love.filesystem.remove(save_directory .. save_name .. ".txt")
end

function FileHandler:loadLevel(level_name)
	local path = levels_directory .. level_name .. ".txt"
	level_name = love.filesystem.read(path)
	level = bitser.loads(level_name)
	return level[1], level[2], level[3]
end

function FileHandler:loadSaveGame(save_name)
	local path = save_directory .. save_name .. ".txt"
	local game_save = love.filesystem.read(path)
	return bitser.loads(game_save)
end

function FileHandler:loadOptions()
	return bitser.loadLoveFile("options.txt")
end

function FileHandler:loadTileSet(tile_set_name)
	local path = tile_set_directory .. tile_set_name .. ".txt"
	local tile_names = love.filesystem.read(path)
	local tile_names = bitser.loads(tile_names)
	local tile_set = {}
	for i, tile_name in pairs (tile_names) do
		tile_set[#tile_set + 1] = love.graphics.newImage("Images/tiles/" .. tile_name .. ".png")
	end
	return tile_set
end

function FileHandler:getSaves()
	local save_names = love.filesystem.getDirectoryItems(save_directory)
	local saves = Map:new()

	for i, save_name in pairs(save_names) do
		save_name = string.gsub(save_name, "%.txt", "")
		saves:insert(save_name, self:loadSaveGame(save_name))
	end
	return saves
end

function FileHandler:getLevels()
	local level_names = love.filesystem.getDirectoryItems(levels_directory)
	local levels = Map:new()

	for i, level_name in pairs(level_names) do
		level_name = string.gsub(level_name, "%.txt", "")
		local level, width, height = self:loadLevel(level_name)
		levels:insert(level_name, {level, width, height})
	end

	return levels
end

function FileHandler:getRandomLevel()
	local name = love.filesystem.getDirectoryItems(levels_directory)[1]
	if name then name = string.gsub(name, "%.txt", "") end
	return name
end








OptionsHandler = class("OptionsHandler")

function OptionsHandler:initialize()
	self.data = fileHandler:loadOptions()
	--if not self.data then 
	--	self:applyDefaults()
	--	self:saveFile()
	--else 
	--	self:apply() 
	--end
end

function OptionsHandler:isStretched() 
	return self.data["Stretched"]
end

function OptionsHandler:applyDefaults()
	self.data["Stretched"] = true
	xScale = windowWidth / 640
	yScale = windowHeight / 360
	self:apply()
end

function OptionsHandler:switchStretched()
	self.data["Stretched"] = not self.data["Stretched"]
	xScale = windowWidth / 640
	yScale = windowHeight / 360
	self:apply() 
end

function OptionsHandler:apply()
	push:switchStretched(self.data["Stretched"])
	fileHandler:saveOptions()
end

function FileHandler:setupBitser()
	bitser.registerClass(Cat)
	bitser.registerClass(Clan)
	bitser.registerClass(Animal)
	bitser.registerClass(Map)
	bitser.registerClass(Decal)
	bitser.registerClass(Timer)
	bitser.registerClass(Button)
	--bitser.registerClass(Controller) 
	--bitser.registerClass(Player) 
	bitser.registerClass(FileHandler)
	bitser.registerClass(OptionsHandler)
end

