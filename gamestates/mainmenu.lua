mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	local play = love.graphics.newImage("Images/playbutton.png")
	self.play_button = Button:new(32, 128, play)
	local loadImage = love.graphics.newImage("Images/StartGame.png")
	self.load_game = Button:new(imageCenterX(loadImage), imageCenterY(loadImage), loadImage)
	local options = love.graphics.newImage("Images/optionsbutton.png")
	self.options_button = Button:new(32, 192 + 16, options)

	table.insert(self.buttons, self.play_button)
	table.insert(self.buttons, self.load_game)
	table.insert(self.buttons, self.options_button)
end

function mainmenu:update(dt)
end

function mainmenu:mousepressed(x, y, button)
	--this is because of push and the resolution handiling
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.play_button then gamestate.switch(play) end
				if _button == self.load_game then gamestate.switch(loadgame) end
				if _button == self.options_button then gamestate.switch(options) end
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