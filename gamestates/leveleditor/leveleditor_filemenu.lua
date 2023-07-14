local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"


leveleditor_filemenu = class("leveleditor_filemenu")

function leveleditor_filemenu:initialize()
	self.buttons = Array:new()

	self.new_button = ImageButton:new(0, 32, love.graphics.newImage("Images/file_newbutton.png"), self.buttons)
	self.load_button = ImageButton:new(0, 64, love.graphics.newImage("Images/file_loadbutton.png"), self.buttons)
	self.save_button = ImageButton:new(0, 96, love.graphics.newImage("Images/file_savebutton.png"), self.buttons)
end

function leveleditor_filemenu:enter(from, map_handler, current_map)
	self.from = from
	self.map_handler = map_handler
	self.current_map = current_map
	self.action = nil
end

function leveleditor_filemenu:mousepressed(x, y, button)
	self.action = nil
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.new_button then
				self.action = "new"
				return gamestate.push(leveleditor_newmap)
			end
			if _button == self.load_button then
				self.action = "load"
				return gamestate.push(leveleditor_loadmap)
			end
			if _button == self.save_button then
				fileHandler:saveLevel(self.map_handler:getRenderMap(), self.map_handler:getWidth(), self.map_handler:getHeight(), self.current_map)
				self.action = "saved"
			end
		end
	end

	return gamestate.pop(self.action)
end

function leveleditor_filemenu:resume(state, map)
	return gamestate.pop(self.action, map)
end

function leveleditor_filemenu:update(dt)
	self.from:update(dt)
end

function leveleditor_filemenu:draw()
	self.from:draw()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end