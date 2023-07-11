local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"

leveleditor_newmap = class("leveleditor_newmap")

function leveleditor_newmap:initialize()
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

function leveleditor_newmap:enter(from)
	self.from = from
end

function leveleditor_newmap:keypressed(key)
	if self.active_text_box then self.text_boxes:at(self.active_text_box):keypressed(key) end

	if key == "return" then
		self.active_text_box = self.active_text_box + 1
		if self.active_text_box == 4 then self.active_text_box = nil end
	end
end

function leveleditor_newmap:mousepressed(x, y, button)
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


function leveleditor_newmap:draw()
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


