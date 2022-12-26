function setupBitser()
	bitser.registerClass(Cat)
	bitser.registerClass(Clan)
end

--pass a table in
--[1 should be all the game data, 2-5 should be the clans]
function createSave(slot, t)
	local success
	local saveData = {}
	table.insert(saveData, slot)
	for i, clan in ipairs (t) do
		table.insert(saveData, clan)
	end
	love.filesystem.remove(slot)
	bitser.dumpLoveFile(slot, saveData)
end

function loadSave(slot)
	local saveData = bitser.loadLoveFile(slot)
	return saveData
end