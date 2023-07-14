local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"

leveleditor_properties = class("leveleditor_properties", leveleditor_mapmenu)

function leveleditor_properties:enter(from, map_handler, current_map_name)
	leveleditor_mapmenu.initialize(self, from)

	self.from = from

	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.level = love.graphics.newImage("Images/edit_level.png")

	self.buttons = Array:new()

	self.cancel_button = ImageButton:new(640/2 - 80, 272, love.graphics.newImage("Images/cancel.png"), self.buttons)
	self.save_button = ImageButton:new(640/2 + 16, 272, love.graphics.newImage("Images/save.png"), self.buttons)

	self.text_boxes = Array:new() 

	self.level_name_box = TextBox:new(640/2 - 4, 164, 64, 16, 15, self.text_boxes)
	self.level_width_box = TextBox:new(640/2 - 4, 200, 64, 16, 4, self.text_boxes)
	self.level_height_box = TextBox:new(640/2 - 4, 232, 64, 16, 4, self.text_boxes)

	self.old_map_name = current_map_name
	self.old_map = map_handler:getRenderMap()
	self.old_map_w = map_handler:getWidth()
	self.old_map_h = map_handler:getHeight()

	self.level_name_box:setText(current_map_name)
	self.level_width_box:setText(tostring(self.old_map_w))
	self.level_height_box:setText(tostring(self.old_map_h))

	self.active_text_box = 1
end


function leveleditor_properties:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self.active_text_box = nil

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) then
			if _button == self.cancel_button then return gamestate.pop() end
			if _button == self.save_button then 
				local level = {}
				local new_level_name, new_map_w, new_map_h = self.level_name_box:getText(), tonumber(self.level_width_box:getText()), tonumber(self.level_height_box:getText())

				local width_dif = new_map_w - self.old_map_w
				local height_dif = new_map_w - self.old_map_h

				for i = 1, new_map_h do
					for k = 1, new_map_w do
						if self.old_map[new_map_w * (i-1) + k] then
							level[new_map_w * (i-1) + k] = self.old_map[new_map_w * (i-1) + k]
						else
							level[new_map_w * (i-1) + k] = 1
						end
					end
				end

				print(#level, new_map_w, new_map_h)


				fileHandler:deleteLevel(self.old_map_name)
				fileHandler:saveLevel(level, new_map_w, new_map_h, new_level_name)
				return gamestate.pop()
			end
		end
	end

	for i, text_box in self.text_boxes:iterator() do
		if text_box:mouseInside(mx, my) then self.active_text_box = self.text_boxes:find(text_box) end
	end
end

