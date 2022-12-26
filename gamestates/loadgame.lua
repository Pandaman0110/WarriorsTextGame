loadgame = {}


--display save details or something
function loadgame:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)
	local _back = love.graphics.newImage("Images/next.png")
	self.back_button = Button:new(32, 300, _back)

	local _view = love.graphics.newImage("Images/StartGame.png")
	self.view_button = Button:new(288, 32, _view)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)

end

function loadgame:enter(previous)
	self.save = nil
	self.save_buttons = {}
	self.saves = {}

	if love.filesystem.getInfo("SaveOne") ~= nil then 
		table.insert(self.saves, bitser.loadLoveFile("SaveOne"))

		local save_1 = love.graphics.newImage("Images/StartGame.png")
		self.save_one = Button:new(32, 32, save_1)

		table.insert(self.save_buttons, self.save_one)
	end
end

function loadgame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		if self.view_button:mouseInside(mx, my) == true then
			local viewing = true
			gamestate.switch(choosecharacter, self.save, viewing) 
		end
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then gamestate.switch(mainmenu) end
				if _button == self.back_button then gamestate.switch(mainmenu) end
			end
		end
		for i, _button in ipairs (self.save_buttons) do
			if _button:mouseInside(mx, my) == true then self.save = self.saves[i] end
		end
	end
end

function loadgame:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	for i, _button in ipairs(self.save_buttons) do
		_button:draw()
	end


	if self.save ~= nil then
		self.view_button:draw()
	end


end

