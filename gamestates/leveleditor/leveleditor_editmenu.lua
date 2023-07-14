local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"


leveleditor_editmenu = class("leveleditor_editmenu")

function leveleditor_editmenu:initialize()
	self.buttons = Array:new()

	self.new_button = ImageButton:new(64, 32, love.graphics.newImage("Images/edit_propertiesbutton.png"), self.buttons)
end

function leveleditor_editmenu:enter(from, map_handler, current_map)
	self.from = from
	self.map_handler = map_handler
	self.current_map = current_map
	self.action = nil
end

function leveleditor_editmenu:mousepressed(x, y, button)
	self.action = nil
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.new_button then
				if not self.current_map then 
					self.action = "new"
					return gamestate.push(leveleditor_newmap)
				else
					self.action = "properties"
					return gamestate.push(leveleditor_properties, self.map_handler, self.current_map)
				end
			end
		end
	end

	return gamestate.pop(self.action)
end

function leveleditor_editmenu:resume(state, map)
	return gamestate.pop(self.action, map)
end

function leveleditor_editmenu:update(dt)
end

function leveleditor_editmenu:draw()
	self.from:draw()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end