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

--pass a table in
--[1 should be all the game data, 2-5 should be the clans]
function createSave(slot, t, misc)
	local name = slot
	local saveNames = loadSaveNames()

	for i, _name in ipairs (saveNames) do
		if name == _name then
			return false
		end
	end

	love.filesystem.append("save_names", name .. "\n")

	local saveData = {}
	table.insert(saveData, slot)
	for i, clan in ipairs (t) do
		table.insert(saveData, clan)
	end
	love.filesystem.remove(name)
	bitser.dumpLoveFile(name, saveData)
	return true
end

function loadSave(slot)
	local saveData = bitser.loadLoveFile(slot)
	return saveData
end

function loadSaveNames()
	local saveNames = {}
	local directory = love.filesystem.getSaveDirectory()
	--C:\Users\chanc\AppData\Roaming\LOVE\WTG
	
	for line in love.filesystem.lines("save_names") do 
		table.insert(saveNames, line)
	end

	return saveNames
end