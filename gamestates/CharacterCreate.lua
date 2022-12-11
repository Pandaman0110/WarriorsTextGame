charactercreate = {}

function charactercreate:init()




	--buttons
	self.buttons = {}
	local nextButtonImage = love.graphics.newImage("Images/Next.png")
	self.nextBox = Button:new(imageCenterX(nextButtonImage) + 16, imageCenterY(nextButtonImage) +  150, nextButtonImage)
	table.insert(self.buttons, self.nextBox)

	--textboxes
	self.textboxes = {}
	local nameBoxImage = love.graphics.newImage("Images/BrownBox.png")
	self.nameBox = TextBox:new(imageCenterX(nameBoxImage), imageCenterY(nameBoxImage), nameBoxImage)
	table.insert(self.textboxes, self.nameBox)

	
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

		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.nextBox then gamestate.switch() end
			end
		end

		for i, _textBox in ipairs (self.textboxes) do
			if _textBox:mouseInside(mx, my) == true then _textBox:setActive(true) 
			elseif  _textBox:isActive() then _textBox:setActive(false) end
		end
	end
end


function charactercreate:draw()
	for i, _textBox in ipairs(self.textboxes) do
		_textBox:draw()
	end

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

end