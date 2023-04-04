mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	self.play_button = ImageButton:new(32, 128, love.graphics.newImage("Images/playbutton.png"), self.buttons)
	self.options_button = ImageButton:new(32, 192 + 16, love.graphics.newImage("Images/optionsbutton.png"), self.buttons)
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