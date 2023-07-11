local pairs, ipairs = pairs, ipairs

editor = class("editor")

local tile_path = "Map/"


function editor:initialize()
	self.buttons = Array:new()

	self.file_button = ImageButton:new(0, 0, love.graphics.newImage("Images/filebutton.png"), self.buttons)
	self.exit_button = ImageButton:new(640 - 64, 0, love.graphics.newImage("Images/exit.png"), self.buttons)

	self.save_warning = love.graphics.newImage("Images/unsaved_changes.png")
end

function editor:enter(previous)
	self.current_tile = nil

	if fileHandler:getLevels():size() == 0 then 
		self:createPlaceHolderLevel()
	end

	self.current_map = fileHandler:getRandomLevel()

	self.controller = LevelEditorController:new()
	self.map_handler = MapHandler:new(self.controller, fileHandler:getRandomLevel())

	self.orignal_map = self.map_handler:getRenderMap()


	self.unsaved_changes = false
	self.changes = Stack:new()

	self:setTileButtons("default")
end

function editor:resume(state, action, map)
	self.current_map = map
	if action == "saved" or "load" then 
		self:loadMap()
	end
end


function editor:update(dt)
	local camera_pos = self.controller:getRealPos()

	self.mouse_x, self.mouse_y = love.mouse.getPosition()
	self.mouse_x, self.mouse_y = push:toGame(self.mouse_x, self.mouse_y)

	if mx == nil or my == nil then mx, my = -999999, -9999999 end
	local tx, ty = math.floor((self.mouse_x+camera_pos[1]+16)/32 - 9), math.floor((self.mouse_y+camera_pos[2]-8)/32 - 4)


	if self.map_handler:validPos(tx, ty) and self.current_tile and love.mouse.isDown(1) and self.map_handler:getTile(tx, ty) ~= self.current_tile then 
		self.unsaved_changes = true
		local tile = self.map_handler:getTile(tx, ty)

		if self.changes:size() == 0 then 
			self.changes:push({tx, ty, tile})
		elseif self.changes:peek()[1] ~= tx or self.changes:peek()[2] ~= ty then
			self.changes:push({tx, ty, tile})
		end

		self.map_handler:changeTile(tx, ty, self.current_tile)
	end

	self.controller:update(dt)
	self.map_handler:update(dt)


	if self.changes:size() == 0 then self.unsaved_changes = false end
end

function editor:draw()
	self.map_handler:draw()

	self:drawButtons()

	if self.current_tile then 
		local image = self.tile_buttons:at(self.current_tile):getImage()
		love.graphics.draw(image, self.mouse_x - image:getWidth() / 2, self.mouse_y - image:getHeight() / 2)
	end

	if self.unsaved_changes then 
		love.graphics.draw(self.save_warning, 640 - 48, 48)
	end
end

function editor:keypressed(key)
	local action = self.controller:keypressed(key)
	if action == "undo" then
		local change = self.changes:pop()
		if change then self.map_handler:changeTile(change[1], change[2], change[3])
		end
	end
	if action == "save" then 
		fileHandler:saveLevel(self.map_handler:getRenderMap(), self.current_map)
		self:loadMap(self.current_map)
	end
end

function editor:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	local camera_pos = self.controller:getRealPos()
	--someone needs to fix this shit 
	if mx == nil or my == nil then mx, my = -999999, -9999999 end
	local tx, ty = math.floor((mx+camera_pos[1]+16)/32 - 9), math.floor((my+camera_pos[2]-8)/32 - 4)

	if button == 2 then self.current_tile = nil goto continue end

	for i, _button in self.tile_buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			self.current_tile = self.tile_buttons:find(_button)
		end
	end

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.file_button then
				gamestate.push(filemenu, self.map_handler)
				self.current_tile = nil
			end
			if _button == self.exit_button then
				gamestate.switch(mainmenu)
			end
		end
	end

	::continue::
end


function editor:drawButtons()
	for i, button in self.buttons:iterator() do
		button:draw()
	end

	for i, button in self.tile_buttons:iterator() do
		button:draw()
	end
end

function editor:updateButtons(dt)
	for i, button in self.buttons:iterator() do
		button:update(dt)
	end

	for i, button in self.tile_buttons:iterator() do
		button:update(dt)
	end
end

function editor:setTileButtons(tile_set)
	self.tile_buttons = Array:new()

	local tiles = fileHandler:loadTileSet(tile_set)

	for i, tile_image in ipairs(tiles) do
		if i > 5 then
			local k = i - 5
			local cat_button = ImageButton:new(32, 360 - 156 + 32 * (k-1), tile_image, self.tile_buttons)
		else
			local cat_button = ImageButton:new(0, 360 - 156 + 32 * (i-1), tile_image, self.tile_buttons)
		end
		i = i + 1
	end
end


function editor:loadMap()
	self.unsaved_changes = false 
	self.map_handler = MapHandler:new(self.controller, self.current_map)
	self.orignal_map = self.map_handler:getRenderMap()
	self.changes:clear()
end

function editor:createPlaceHolderLevel()
	local level = {}
	for i = 1, 32 do 
		level[i] = {}
		for k = 1, 32 do
			level[i][k] = 1
		end
	end

	fileHandler:saveLevel(level, "default")
end


filemenu = class("filemenu")

function filemenu:initialize()
	self.buttons = Array:new()

	self.new_button = ImageButton:new(0, 32, love.graphics.newImage("Images/filenewbutton.png"), self.buttons)
	self.load_button = ImageButton:new(0, 64, love.graphics.newImage("Images/fileloadbutton.png"), self.buttons)
	self.save_button = ImageButton:new(0, 96, love.graphics.newImage("Images/filesavebutton.png"), self.buttons)
end

function filemenu:enter(from, map_handler)
	self.from = from
	self.map_handler = map_handler
	self.action = nil
end

function filemenu:mousepressed(x, y, button)
	self.action = nil
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.new_button then
				self.action = "new"
				return gamestate.push(newmap)
			end
			if _button == self.load_button then
				self.action = "load"
				return gamestate.push(loadmap)
			end
			if _button == self.save_button then
				fileHandler:saveLevel(self.map_handler:getRenderMap(), "OldForest")
				self.action = "saved"
			end
		end
	end

	return gamestate.pop(self.action)
end

function filemenu:resume(state, map)
	return gamestate.pop(self.action, map)
end

function filemenu:update(dt)
	self.from:update(dt)
end

function filemenu:draw()
	self.from:draw()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end


newmap = class("newmap")

function newmap:initialize()
	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.new_level = love.graphics.newImage("Images/new_level.png")

	self.buttons = Array:new()

	self.cancel_button = ImageButton:new(640/2 - 80, 272, love.graphics.newImage("Images/cancel.png"), self.buttons)
	self.create_button = ImageButton:new(640/2 + 16, 272, love.graphics.newImage("Images/create.png"), self.buttons)

	self.text_boxes = Array:new() 

	self.level_name_box = TextBox:new(640/2 - 4, 164, 64, 16, 15, self.text_boxes)
	self.level_width_box = TextBox:new(640/2 - 4, 200, 64, 16, 4, self.text_boxes)
	self.level_height_box = TextBox:new(640/2 - 4, 232, 64, 16, 4, self.text_boxes)

	self.active_text_box = 1
end

function newmap:enter(from)
	self.from = from
end

function newmap:keypressed(key)
	if self.active_text_box then self.text_boxes:at(self.active_text_box):keypressed(key) end

	if key == "return" then
		self.active_text_box = self.active_text_box + 1
		if self.active_text_box == 4 then self.active_text_box = nil end
	end
end

function newmap:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self.active_text_box = nil

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) then
			if _button == self.cancel_button then return gamestate.pop() end
			if _button == self.create_button then 
				local level = {}
				local w, h = self.level_width_box:getText(), self.level_height_box:getText()
				for i = 1, h do 
					level[i] = {}
					for k = 1, w do
						level[i][k] = 1
					end
				end
				fileHandler:saveLevel(level, self.level_name_box:getText())
				return gamestate.pop()
			end
		end
	end

	for i, text_box in self.text_boxes:iterator() do
		if text_box:mouseInside(mx, my) then self.active_text_box = self.text_boxes:find(text_box) end
	end
end


function newmap:draw()
	self.from:draw()

	love.graphics.draw(self.brown_box, 640/2 - self.brown_box:getWidth()/2, 360/2 - self.brown_box:getHeight()/2)
	love.graphics.draw(self.new_level, 640/2 - self.new_level:getWidth()/2, 80)

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






loadmap = class("loadmap")

function loadmap:initialize()
	self.brown_box = love.graphics.newImage("Images/medium_brown_box.png")

end

function loadmap:enter(from)
	self.from = from

	self.levels = Array:new()
	local level_names = fileHandler:getLevels()

	local i = 0
	for level_name, level in level_names:iterator() do
		Text:new(level_name, 72, 8 +  16 * i, 32, 16, self.levels)
		i = i + 1
	end
end

function loadmap:mousepressed(x, y, button) 
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

function loadmap:draw()
	self.from:draw()

	love.graphics.draw(self.brown_box, 64, 0)

	love.graphics.setFont(EBG_R_10)

	for i, level_name in self.levels:iterator() do
		level_name:draw()
	end

	clearTextSettings()
end