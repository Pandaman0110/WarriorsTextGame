local function n(file)
	local path
	if not file then path = "catSave" end
	if file then path = file end
	love.filesystem.append(path, "\n")
end

function saveCat(c)
	local cat = c

	path = love.filesystem.newFile("catSave")
	path:open("a")

	i = love.filesystem.lines(path:getFilename())

	path:write(cat:getImageNum()..'\n')
	path:write(cat:getName()..'\n')
	path:write(cat:getRole()..'\n')
	path:write(cat:getGender()..'\n')
	path:write(cat:getMoons()..'\n')
	path:write(cat:getHealth()..'\n')
	path:write(cat:getEyecolor()..'\n')
	path:write(cat:getPelt()..'\n')
	path:write(cat:getFurlength()..'\n')
	path:write(cat:getDad():getName()..'\n')
	path:write(cat:getMom():getName()..'\n')
	path:write(#cat:getKits()..'\n')
	if #cat:getKits() > 0 then
		for i, kit in ipairs(cat:getKits()) do
			path:write(kit:getName()..'\n')
		end
	end

end
