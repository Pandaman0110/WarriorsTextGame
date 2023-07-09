local pairs, ipairs = pairs, ipairs

editor = class("editor")

function editor:initialize()
	self.buttons = Array:new()

	self.file_button = ImageButton:new(0, 0, love.graphics.newImage("Images/filebutton.png"), self.buttons)
end

function editor:enter(previous)
	
end

function editor:keypressed(key)

end

function editor:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			if _button == self.file_button then
				gamestate.push(filemenu)

			end
		end
	end
end

function editor:draw()
	self:drawButtons()
end

function editor:drawButtons()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end

function editor:updateButtons(dt)
	for i, button in self.buttons:iterator() do
		button:update(dt)
	end
end



filemenu = class("filemenu")

function filemenu:initialize()
	self.buttons = Array:new()

	self.new_button = ImageButton:new(0, 32, love.graphics.newImage("Images/filenewbutton.png"), self.buttons)
	self.load_button = ImageButton:new(0, 64, love.graphics.newImage("Images/fileloadbutton.png"), self.buttons)
	self.save_button = ImageButton:new(0, 96, love.graphics.newImage("Images/filesavebutton.png"), self.buttons)
end

function filemenu:enter(from)
	self.from = from
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

			end
		end
	end

	gamestate.pop()
end

function filemenu:draw()
	self.from:draw()
	for i, button in self.buttons:iterator() do
		button:draw()
	end
end