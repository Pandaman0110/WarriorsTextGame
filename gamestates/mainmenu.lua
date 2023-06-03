local pairs, ipairs = pairs, ipairs

mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	self.play_button = ImageButton:new(32, 72, love.graphics.newImage("Images/playbutton.png"), self.buttons)
	self.level__editor_button = ImageButton:new(32, 152, love.graphics.newImage("Images/leveleditor.png"), self.buttons)
	self.options_button = ImageButton:new(32, 232, love.graphics.newImage("Images/optionsbutton.png"), self.buttons)

	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
end

function mainmenu:mousepressed(x, y, button)
	--this is because of push and the resolution handiling
	local mx, my = push:toGame(x, y)

	self:checkButtons(mx, my, button)
end


function mainmenu:draw()
	self:drawBackground()
	self:drawButtons()
end

----------------------------------------------------------------------------------------------

function mainmenu:checkButtons(mx, my, button)
	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.play_button then gamestate.switch(play) end
				if _button == self.load_game then gamestate.switch(loadgame) end
				if _button == self.options_button then gamestate.switch(options) end
				if _button == self.level__editor_button then gamestate.switch(leveleditor) end
			end
		end
	end
end

function mainmenu:drawButtons()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end

function mainmenu:drawBackground()
	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 360 / self.background:getHeight())
end