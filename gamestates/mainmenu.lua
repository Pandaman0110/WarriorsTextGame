mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	local startImage = love.graphics.newImage("Images/StartGame.png")
	self.start_game = Button:new(imageCenterX(startImage), imageCenterY(startImage) - 40, startImage)
	local loadImage = love.graphics.newImage("Images/StartGame.png")
	self.load_game = Button:new(imageCenterX(loadImage), imageCenterY(loadImage), loadImage)
	local optionsImage = love.graphics.newImage("Images/StartGame.png")
	self.options = Button:new(imageCenterX(optionsImage), imageCenterY(optionsImage) + 40, optionsImage)

	table.insert(self.buttons, self.start_game)
	table.insert(self.buttons, self.load_game)
	table.insert(self.buttons, self.options)

end

function mainmenu:update(dt)
	
end

function mainmenu:mousepressed(x, y, button)
	--this is because of push and the resolution handiling
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.start_game then gamestate.switch(chooseclan) end
				if _button == self.load_game then gamestate.switch(loadgame) end
				if _button == self.options then gamestate.switch(options) end
			end
		end
	end
end


function mainmenu:draw()

	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 360 / self.background:getHeight())

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end