local pairs, ipairs = pairs, ipairs
local tile_path = "Map/"

leveleditor_newmap = class("leveleditor_newmap", leveleditor_mapmenu)


function leveleditor_newmap:enter(from)
	leveleditor_mapmenu.initialize(self, from)

	self.from = from

	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.level = love.graphics.newImage("Images/new_level.png")

	self.buttons = Array:new()

	self.cancel_button = ImageButton:new(640/2 - 80, 272, love.graphics.newImage("Images/cancel.png"), self.buttons)
	self.create_button = ImageButton:new(640/2 + 16, 272, love.graphics.newImage("Images/create.png"), self.buttons)

	self.text_boxes = Array:new() 

	self.level_name_box = TextBox:new(640/2 - 4, 164, 64, 16, 15, self.text_boxes)
	self.level_width_box = TextBox:new(640/2 - 4, 200, 64, 16, 4, self.text_boxes)
	self.level_height_box = TextBox:new(640/2 - 4, 232, 64, 16, 4, self.text_boxes)

	self.level_width_box:setText("0")
	self.level_height_box:setText("0")

	self.active_text_box = 1
end

function leveleditor_newmap:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self.active_text_box = nil

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) then
			if _button == self.cancel_button then return gamestate.pop() end
			if _button == self.create_button then 
				local w, h = self.level_width_box:getText(), self.level_height_box:getText()
				local level = {}

				for i = 1, w * h do
					level[i] = 1
				end

				fileHandler:saveLevel(level, w, h, self.level_name_box:getText())
				return gamestate.pop()
			end
		end
	end

	for i, text_box in self.text_boxes:iterator() do
		if text_box:mouseInside(mx, my) then self.active_text_box = self.text_boxes:find(text_box) end
	end
end
