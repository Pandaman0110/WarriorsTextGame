options = {}

function options:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = Array:new()

	self.stretched_button = ImageButton:new(32, 32, love.graphics.newImage("Images/StartGame.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)
end

function options:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	options:checkButtons(mx, my, button)
end

function options:draw()
	love.graphics.draw(self.background, 0, 0)
	self:drawButtons()
end

----------------------------------------------------------------------------------------------

function options:drawButtons()
	for _button in self.buttons:iterator() do
		_button:draw()
	end
end

function options:checkButtons(mx, my, button)
	if button == 1 then
		for _button in self.buttons:iterator() do
			if _button:mouseInside(mx, my) == true then
				if _button == self.stretched_button then optionsHandler:switchStretched()
				end
				if _button == self.next_button then gamestate.switch(mainmenu) end
			end
		end
	end
end