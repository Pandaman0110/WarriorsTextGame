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