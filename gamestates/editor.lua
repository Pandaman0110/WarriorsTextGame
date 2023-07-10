local pairs, ipairs = pairs, ipairs

editor = class("editor")

local tile_path = "Map/"

function editor:initialize()
	self.buttons = Array:new()

	self.file_button = ImageButton:new(0, 0, love.graphics.newImage("Images/filebutton.png"), self.buttons)
	self.exit_button = ImageButton:new(640 - 64, 0, love.graphics.newImage("Images/exit.png"), self.buttons)
end

function editor:enter(previous)
	self.current_tile = nil

	self.controller = LevelEditorController:new()
	self.map_handler = MapHandler:new(self.controller)

	self:setTileButtons("default")
end

function editor:update(dt)
	local camera_pos = self.controller:getRealPos()

	self.mouse_x, self.mouse_y = love.mouse.getPosition()
	self.mouse_x, self.mouse_y = push:toGame(self.mouse_x, self.mouse_y)

	print(self.mouse_x, self.mouse_y)

	if mx == nil or my == nil then mx, my = -999999, -9999999 end
	local tx, ty = math.floor((self.mouse_x+camera_pos[1]+16)/32 - 9), math.floor((self.mouse_y+camera_pos[2]-8)/32 - 4)

	--print(self.map_handler:validPos(tx, ty))
	print(tx, ty)
	if self.map_handler:validPos(tx, ty) and self.current_tile and love.mouse.isDown(1) then 
		self.map_handler:changeTile(tx, ty, self.current_tile-1)
	end

	self.controller:update(dt)
	self.map_handler:update(dt)
end

function editor:draw()
	self.map_handler:draw()

	self:drawButtons()

	if self.current_tile then 
		local image = self.tile_buttons:at(self.current_tile):getImage()
		love.graphics.draw(image, self.mouse_x - image:getWidth() / 2, self.mouse_y - image:getHeight() / 2)
	end
end

function editor:keypressed(key)
	self.controller:keypressed(key)
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

	if self.map_handler:validPos(tx, ty) and self.current_tile then 
		self.map_handler:changeTile(tx, ty, self.current_tile-1)
	end

	::continue::
end

function editor:mousereleased(x, y, button)


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
end

function filemenu:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.new_button then
				
			end
			if _button == self.load_button then

			end
			if _button == self.save_button then
				fileHandler:saveLevel(self.map_handler:getRenderMap(), "OldForest")
			end
		end
	end

	gamestate.pop()
end

function filemenu:update(dt)
	--self.from:update(dt)
end

function filemenu:draw()
	self.from:draw()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end