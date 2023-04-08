FileHandler = class("Handler")

function FileHandler:initialize(file)
	self.file = file
	self.data = {}
end

function FileHandler:checkFileExists()
	if love.filesystem.getInfo(self.file) == nil then return false
	else return true end
end

function FileHandler:saveFile()
	bitser.dumpLoveFile(self.file, self.data)
end

function FileHandler:loadFile()
	local data = bitser.loadLoveFile(self.file)
	return data
end

function FileHandler:loadData()
	local data = self:loadFile()
	for i, item in pairs(data) do
		self.data[i] = data[i]
	end
end

function FileHandler:print()
	for i, data in pairs(self.data) do
		print(i .. " = " .. tostring(data))
	end
end

function FileHandler:getName(item)
	for i, _item in pairs (self.data) do
		if _item == item then return i end
	end
	return false
end

OptionsHandler = class("OptionsHandler", FileHandler)

function OptionsHandler:initialize()
	FileHandler.initialize(self, "options")
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
	self:apply()
end

function OptionsHandler:switchStretched()
	self.data["Stretched"] = not self.data["Stretched"]
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
	bitser.registerClass(Ai)
	bitser.registerClass(FileHandler)
	bitser.registerClass(OptionsHandler)
	bitser.registerClass(SaveHandler)
end

