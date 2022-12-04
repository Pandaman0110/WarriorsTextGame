mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}
	local startImage = love.graphics.newImage("Images/StartGame.png")
	self.start_game = Button:new(imageCenterX(startImage), imageCenterY(startImage), startImage)

	table.insert(self.buttons, self.start_game)
end

function mainmenu:update(dt)
	
end

function mainmenu:mousepressed(x, y, button)
	if button == 1 then
		print("mouse was pressed")

		print(x)
		print(y)

		print(self.buttons[1]:getX())
		print(self.buttons[1]:getY())
		for i, _button in ipairs(self.buttons) do
			if mouseInside(x, y, _button:getX(), _button:getY(), _button:getWidth(), _button:getHeight()) == 1 then
				print(mouseInside(x, y, _button:getX(), _button:getY(), _button:getWidth(), _button:getHeight()))
				if _button == self.start_game then gamestate.switch(startup) end
			end
		end
	end
end


function mainmenu:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, v in ipairs(self.buttons) do
		v:draw()
	end
end