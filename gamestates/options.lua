options = {}

function options:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local stretched = love.graphics.newImage("Images/StartGame.png")
	self.stretched_button = Button:new(20, 20, stretched)

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)

	table.insert(self.buttons, self.stretched_button)
	table.insert(self.buttons, self.next_button)

end

function options:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.stretched_button then push:switchStretched() end
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
