options = {}

function options:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	self.stretched_button = ImageButton:new(32, 32, love.graphics.newImage("Images/StartGame.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)
end

function options:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.stretched_button then optionsHandler:switchStretched()
				end
				if _button == self.next_button then gamestate.switch(mainmenu) end
			end
		end
	end
end

function options:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end