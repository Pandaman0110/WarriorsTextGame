FileHandler = class("Handler")

local save_directory = "saves/"
local levels_directory = "levels/"

function FileHandler:initialize()
end

function FileHandler:saveOptions()
	bitser.dumpLoveFile("options.txt", optionsHandler)
end

function FileHandler:loadOptions()
	return bitser.loadLoveFile("options.txt")
end

function FileHandler:saveLevel(level, level_name)
	local path = levels_directory .. level_name ".txt"
	assert(not love.filesystem.getInfo(path), "attempt to overwrite level at location: " .. path) 
	local level = bitser.dumps(level)
	love.filesystem.write(path, level)
end

function FileHandler:saveGame(game_save, save_name)
	local path = save_directory .. save_name .. ".txt"
	assert(not love.filesystem.getInfo(path), "attempt to overwrite level at location: " .. path) 
	local game_save = bitser.dumps(game_save)
	love.filesystem.write(path, game_save)
end

function FileHandler:deleteLevel(level_name)
	love.filesystem.remove(levels_directory .. level_name .. ".txt")
end

function FileHandler:deleteSave(save_name)
	love.filesystem.remove(save_directory .. save_name .. ".txt")
end

function FileHandler:loadLevel(level_name)
	local path = levels_directory .. level_name
	local level = love.filesystem.read(path)
	return bitser.loads(level)
end

function FileHandler:loadSaveGame(save_name)
	local path = save_directory .. save_name
	local game_save = love.filesystem.read(path)
	return bitser.loads(game_save)
end

function FileHandler:getSaves()
	local save_names = love.filesystem.getDirectoryItems(save_directory)
	local saves = Map:new()

	for save_name in pairs(save_names) do
		saves:insert(save_name, self:loadSaveGame(save_name))
	end
	return saves
end

function FileHandler:getLevels()
	local level_names = love.filesystem.getDirectoryItems(levels_directory)
	local levels = Map:new()

	for level_name in pairs(level_names) do
		levels:insert(level_name, self:loadSaveGame(level_name))
	end
	return levels
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
	bitser.registerClass(Controller) 
	bitser.registerClass(Player) 
	bitser.registerClass(FileHandler)
	bitser.registerClass(OptionsHandler)
end

