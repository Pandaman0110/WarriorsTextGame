local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"

leveleditor_mapmenu = class("leveleditor_mapmenu")

function leveleditor_mapmenu:enter(from)

	self.from = from

	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.level = love.graphics.newImage("Images/new_level.png")

	self.buttons = Array:new()

	self.cancel_button = ImageButton:new(640/2 - 80, 272, love.graphics.newImage("Images/cancel.png"), self.buttons)
	self.save_button = ImageButton:new(640/2 + 16, 272, love.graphics.newImage("Images/save.png"), self.buttons)

	self.text_boxes = Array:new() 

	self.level_name_box = TextBox:new(640/2 - 4, 164, 64, 16, 15, self.text_boxes)
	self.level_width_box = TextBox:new(640/2 - 4, 200, 64, 16, 4, self.text_boxes)
	self.level_height_box = TextBox:new(640/2 - 4, 232, 64, 16, 4, self.text_boxes)

	self.current_map_name = current_map_name
	self.old_map = map_handler:getRenderMap()
	self.old_map_w = map_handler:getWidth()
	self.old_map_h = map_handler:getHeight()

	self.level_name_box:setText(current_map_name)
	self.level_width_box:setText(tostring(self.old_map_w))
	self.level_height_box:setText(tostring(self.old_map_h))

	self.active_text_box = 1
end

function leveleditor_mapmenu:keypressed(key)
	if key == "return" then
		self.active_text_box = self.active_text_box + 1
		if self.active_text_box == 4 then self.active_text_box = 1 end
	end

	self.text_boxes:at(self.active_text_box):keypressed(key)

	if self.level_width_box:getText() == "" then self.level_width_box:setText("0") end
	if self.level_height_box:getText() == "" then self.level_height_box:setText("0") end
end

function leveleditor_mapmenu:textinput(text)
	local num = tonumber(text)
	if num ~= nil and (self.active_text_box == 2 or self.active_text_box == 3) then
		if tonumber(self.level_width_box:getText()) > 8192 then 
			self.level_width_box:setText(self.level_width_box:getText():sub(1, -2)) 
			if tonumber(self.level_width_box:getText()) > 8192 then self.level_width_box:setText(8192) end
		elseif tonumber(self.level_height_box:getText()) > 8192 then 
			self.level_height_box:setText(self.level_width_box:getText():sub(1, -2)) 
			if tonumber(self.level_height_box:getText()) > 8192 then self.level_height_box:setText(8192) end
		elseif tonumber(self.level_width_box:getText()) == 0 then
			self.level_width_box:setText(num)
		elseif tonumber(self.level_height_box:getText()) == 0 then
			self.level_height_box:setText(num)
		else
			self.text_boxes:at(self.active_text_box):textinput(text)
		end
	elseif self.active_text_box == 1 then
		self.text_boxes:at(self.active_text_box):textinput(text)
	end
end

function leveleditor_mapmenu:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self.active_text_box = nil

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) then
			if _button == self.cancel_button then return gamestate.pop() end
			if _button == self.save_button then 
				local level = {}
				local new_level_name, new_map_w, new_map_h = self.level_name_box:getText(), self.level_width_box:getText(), self.level_height_box:getText()

				local width_dif = new_map_w - self.old_map_w
				local height_dif = new_map_w - self.old_map_h

				for i = 1, new_map_w * new_map_h do
					if self.old_map[i] then
						level[i] = self.old_map[i]
					else
						level[i] = 1
					end
				end

				fileHandler:deleteLevel(self.level_name_box:getText())
				fileHandler:saveLevel(level, new_map_w, new_map_h, self.current_map_name)
				return gamestate.pop()
			end
		end
	end

	for i, text_box in self.text_boxes:iterator() do
		if text_box:mouseInside(mx, my) then self.active_text_box = self.text_boxes:find(text_box) end
	end
end


function leveleditor_mapmenu:draw()
	self.from:draw()

	love.graphics.draw(self.brown_box, 640/2 - self.brown_box:getWidth()/2, 360/2 - self.brown_box:getHeight()/2)
	love.graphics.draw(self.level, 640/2 - self.level:getWidth()/2, 80)

	for i, button in self.buttons:iterator() do
		button:draw()
	end

	love.graphics.setFont(EBG_R_10)

	love.graphics.print("Name: ", 640/2 - 48, 164, 0, scX())
	love.graphics.print("Width: ", 640/2 - 48, 200, 0, scX())
	love.graphics.print("Height: ", 640/2 - 48, 232, 0, scX())


	for i, text_box in self.text_boxes:iterator() do
		text_box:draw()
	end

	clearTextSettings()
end


