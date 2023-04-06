function setupBitser()
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
end

    -- Save Instructions --

--[[ 

[1] slot is the name of the save. t is a table
[2] is game phase. for now 1 will be character select and 2 can be game in progress
[3] should be the player cat
[4] should be the clans in a table
]]--

function createSave(name, phase, player, clans, misc)
	local save_names = loadSaveNames()

	for i, _name in ipairs (save_names) do
		if name == _name then
			return false
		end
	end

	love.filesystem.append("save_names", name .. "\n")

	local saveData = {}

	table.insert(saveData, name)
	table.insert(saveData, phase) 
	table.insert(saveData, player) 
	table.insert(saveData, clans)

	bitser.dumpLoveFile(name, saveData)

	return true
end

function loadSave(slot)
	local saveData = bitser.loadLoveFile(slot)
	return saveData
end

function loadSaveNames()
	local save_names = {}
	local directory = love.filesystem.getSaveDirectory()
	--C:\Users\chanc\AppData\Roaming\LOVE\WTG
	
	for line in love.filesystem.lines("save_names") do 
		table.insert(save_names, line)
	end

	return save_names
end

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
	local data = bitser.loadLoveFile("options")
	return data
end

function FileHandler:print()
	for i, data in pairs(self.data) do
		print(i .. " = " .. tostring(data))
	end
end

OptionsHandler = class("OptionsHandler", FileHandler)

function OptionsHandler:initialize()
	FileHandler.initialize(self, "options")
	if not self:checkFileExists() then 
		self:applyDefaults()
		self:saveFile()
	else 
		self:loadData() 
	end
end

function OptionsHandler:isStretched() 
	return self.data["Stretched"]
end

function OptionsHandler:loadData()
	local data = self:loadFile()
	self.data["Stretched"] = data["Stretched"]
	self:apply()
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
	FileHandler.initialize(self, "save_names")
	if not checkFileExists() then 
		self:saveFile()
	else
		self:loadData()
	end
end

function SaveHandler:add(name)
	table.insert(self.data, name)
end

function SaveHandler:loadData()
	local data = self:loadFile()
	for i, saveName in pairs(data) do 
		table.insert(self.data, saveName)
	end
end

--maybe where the names are the keys and the save tables are the values
--dump the whole son of a bitch 

function SaveHandler:createSave(name, phase, player, clans, misc)
	if not checkDuplicateSave(name) then return false end

	local saveData = {}

	table.insert(saveData, name)
	table.insert(saveData, phase) 
	table.insert(saveData, player) 
	table.insert(saveData, clans)

	bitser.dumpLoveFile(name, saveData)

	return true
end

function SaveHandler:checkDuplicateSave(name)
	for i, save in pairs(self.data) do
		if name == i then return false end
	end
	return true
end