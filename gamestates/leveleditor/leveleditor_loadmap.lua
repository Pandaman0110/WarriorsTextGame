local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"

leveleditor_loadmap = class("leveleditor_loadmap")

function leveleditor_loadmap:initialize()
	self.brown_box = love.graphics.newImage("Images/medium_brown_box.png")

end

function leveleditor_loadmap:enter(from)
	self.from = from

	self.levels = Array:new()
	local level_names = fileHandler:getLevels()

	local i = 0
	for level_name, level in level_names:iterator() do
		Text:new(level_name, 72, 8 +  16 * i, 32, 16, self.levels)
		i = i + 1
	end
end

function leveleditor_loadmap:mousepressed(x, y, button) 
	local mx, my = push:toGame(x, y)

	for i, text in self.levels:iterator() do
		local level_name = text:getText()
		if text:mouseInside(mx, my) then
			return gamestate.pop(level_name)
		end
	end

	if not mouseInside(mx, my, 128, 0, self.brown_box:getWidth(), self.brown_box:getWidth()) then 
		return gamestate.pop(level_name)
	end
end

function leveleditor_loadmap:draw()
	self.from:draw()

	love.graphics.draw(self.brown_box, 64, 0)

	love.graphics.setFont(EBG_R_10)

	for i, level_name in self.levels:iterator() do
		level_name:draw()
	end

	clearTextSettings()
end