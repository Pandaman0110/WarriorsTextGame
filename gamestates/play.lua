play = {}

function play:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	self.new_button = ImageButton:new(32, 72, love.graphics.newImage("Images/newbutton.png"), self.buttons)
	self.load_button = ImageButton:new(32, 152, love.graphics.newImage("Images/loadbutton.png"), self.buttons)
	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
end

function play:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self:checkButtons(mx, my, button)
end

function play:draw()
	self:drawBackground()
	self:drawButtons()
end

----------------------------------------------------------------------------------------------

function play:checkButtons(mx, my, button)
	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.new_button then gamestate.switch(choosecharacter) end
				if _button == self.load_button then gamestate.switch(loadgame) end
				if _button == self.back_button then gamestate.switch(mainmenu) end
			end
		end
	end
end

function play:drawBackground()
	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 360 / self.background:getHeight())
end

function play:drawButtons()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end