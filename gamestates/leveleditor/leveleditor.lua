local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"


leveleditor = class("leveleditor")

function leveleditor:initialize()
	self.buttons = Array:new()

	self.file_button = ImageButton:new(0, 0, love.graphics.newImage("Images/filebutton.png"), self.buttons)
	self.edit_button = ImageButton:new(64, 0, love.graphics.newImage("Images/editbutton.png"), self.buttons)
	self.exit_button = ImageButton:new(640 - 64, 0, love.graphics.newImage("Images/exit.png"), self.buttons)

	self.save_warning = love.graphics.newImage("Images/unsaved_changes.png")
end

function leveleditor:enter(previous)
	self.current_tile = nil

	self.current_map = fileHandler:getRandomLevel()

	if not self.current_map then 
		self:createPlaceHolderLevel()
	end

	self.controller = LevelEditorController:new()
	self.map_handler = MapHandler:new(self.controller, fileHandler:getRandomLevel())

	self.original = self.map_handler:getRenderMap()


	self.unsaved_changes = false
	self.changes = Stack:new()

	self:setTileButtons("default")
end

function leveleditor:resume(state, action, map)
	print(map)
	if action == "load" then self.current_map = map end
	if action == "saved" or "load" then 
		self:loadMap()
	end
end


function leveleditor:update(dt)
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

function leveleditor:draw()
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

function leveleditor:keypressed(key)
	local action = self.controller:keypressed(key)
	if action == "undo" then
		local change = self.changes:pop()
		if change then self.map_handler:changeTile(change[1], change[2], change[3])
		end
	end
	if action == "save" then 
		fileHandler:saveLevel(self.map_handler:getRenderMap(), self.map_handler:getWidth(), self.map_handler:getHeight(), self.current_map)
		self:loadMap(self.current_map)
	end
	if key == "l" then print(self.current_map) end
end

function leveleditor:mousepressed(x, y, button)
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
				gamestate.push(leveleditor_filemenu, self.map_handler, self.current_map)
				
			end
			if _button == self.edit_button then 
				gamestate.push(leveleditor_editmenu, self.map_handler, self.current_map)
				
			end
			if _button == self.exit_button then
				gamestate.switch(mainmenu)
			end
			self.current_tile = nil
		end
	end

	::continue::
end


function leveleditor:drawButtons()
	for i, button in self.buttons:iterator() do
		button:draw()
	end

	for i, button in self.tile_buttons:iterator() do
		button:draw()
	end
end

function leveleditor:updateButtons(dt)
	for i, button in self.buttons:iterator() do
		button:update(dt)
	end

	for i, button in self.tile_buttons:iterator() do
		button:update(dt)
	end
end

function leveleditor:setTileButtons(tile_set)
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


function leveleditor:loadMap()
	self.unsaved_changes = false 
	self.map_handler = MapHandler:new(self.controller, self.current_map)
	self.original = self.map_handler:getRenderMap()
	self.changes:clear()
end

function leveleditor:createPlaceHolderLevel()
	local level = {}
	for i = 1, 32 * 32 do 
		level[i] = 1
	end
	self.current_map = "default"
	fileHandler:saveLevel(level, 32, 32, self.current_map)
end