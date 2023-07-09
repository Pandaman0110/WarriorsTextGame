FileHandler = class("Handler")

local save_directory = "saves/"
local levels_directory = "levels/"

function FileHandler:initialize()
end

function FileHandler:saveLevel(level, level_name)
	local path = levels_directory .. level_name
	assert(not love.filesystem.getInfo(path), "attempt to overwrite level at location: " .. path) 
	local level = bitser.dumps(level)
	love.filesystem.write(path, level)
end

function FileHandler:saveGame(game_save, save_name)
	local path = save_directory .. save_name
	assert(not love.filesystem.getInfo(path), "attempt to overwrite level at location: " .. path) 
	local game_save = bitser.dumps(game_save)
	love.filesystem.write(path, game_save)
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

	for save_name in pairs(save_names)
		saves:insert(save_name, self:loadSaveGame(save_name))
	end
	return saves
end

function FileHandler:getLevels()
	local level_names = love.filesystem.getDirectoryItems(levels_directory)
	local levels = Map:new()

	for level_name in pairs(level_names)
		levels:insert(level_name, self:loadSaveGame(level_name))
	end
	return levels
end


LevelHandler = class("LevelHandler", FileHandler)

function LevelHandler:initialize()
	FileHandler.initialize(self)
end


OptionsHandler = class("OptionsHandler", FileHandler)

function OptionsHandler:initialize()
	FileHandler.initialize(self, "options.txt")
	if not self:checkFileExists() then 
		self:applyDefaults()
		self:saveFile()
	else 
		self:loadData()
		self:apply() 
	end
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
	self:saveFile()
end

SaveHandler = class("SaveHandler", FileHandler)

function SaveHandler:initialize()
	FileHandler.initialize(self, "savegames")
	self:setupBitser()
	if self:checkFileExists() then 
		self:loadData()
	end
end

function SaveHandler:getNumSaves()
	return #self.data 
end

function SaveHandler:addSave(name, saveData)
	self.data[name] = saveData
end

function SaveHandler:loadSave(name)
	return self.data[name]
end

function SaveHandler:getSaves()
	return self.data
end

--maybe where the names are the keys and the save tables are the values
--dump the whole son of a bitch 

function SaveHandler:createSave(name, phase, player, clans, misc)
	if not self:checkDuplicateSave(name) then return false end

	local saveData = {}

	saveData["Phase"] = phase 
	saveData["Player"] = player
	saveData["Clans"] = clans

	self:addSave(name, saveData)
	self:saveFile()

	return true
end

function SaveHandler:deleteSave(name)
	self.data[name] = nil
	self:saveFile()
end


function SaveHandler:checkDuplicateSave(name)
	for i, save in pairs(self.data) do
		if name == i then return false end
	end
	return true
end

function SaveHandler:setupBitser()
	bitser.registerClass(Cat)
	bitser.registerClass(Clan)
	bitser.registerClass(Animal)
	bitser.registerClass(Map)
	bitser.registerClass(Decal)
	bitser.registerClass(Timer)
	bitser.registerClass(Button)
	bitser.registerClass(Controller) 
	bitser.registerClass(Player) 
	--bitser.registerClass(Controller)
	bitser.registerClass(FileHandler)
	bitser.registerClass(OptionsHandler)
	bitser.registerClass(SaveHandler)
end

