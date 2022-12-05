charactercreate = {}

function charactercreate:init()

	self.textboxes = {}

	local brownBoxImage = love.graphics.newImage("Images/BrownBox.png")
	self.brown_box = TextBox:new(imageCenterX(brownBoxImage), imageCenterY(brownBoxImage), brownBoxImage)
	table.insert(self.textboxes, self.brown_box)
	
end

function charactercreate:update(dt)
	
end

function charactercreate:textinput(t)
	for i, _textBox in ipairs (self.textboxes) do
		if _textBox:isActive() then _textBox:addText(t) end
	end
	print(t)
end

function charactercreate:keypressed(key)
	for i, _textBox in ipairs (self.textboxes) do
		_textBox:keypressed(key)
    end
end

function charactercreate:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _textBox in ipairs (self.textboxes) do
			if _textBox:mouseInside(mx, my) == true then 
				_textBox:setActive(true)
			elseif  _textBox:isActive() then 
				_textBox:setActive(false)
			end
		end
	end
end


function charactercreate:draw()
	for i, _textBox in ipairs(self.textboxes) do
		_textBox:draw()
	end
end