loadgame = {}


--display save details or something
function loadgame:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _back = love.graphics.newImage("Images/back.png")
	self.back_button = Button:new(32, 312, _back)
	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(544, 312, _next)

	local _view = love.graphics.newImage("Images/StartGame.png")
	self.view_button = Button:new(288, 32, _view)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)
end

function loadgame:enter(previous)
	self.save = nil
	self.save_buttons = {}
	self.saves = {}
	self.userdirectory = love.filesystem.getSaveDirectory()
	
	for i, save in ipairs (self.directoryFiles) do
		print(save)
	end

	--[[
	if love.filesystem.getInfo("SaveOne") ~= nil then 
		table.insert(self.saves, bitser.loadLoveFile("SaveOne"))

		local save_1 = love.graphics.newImage("Images/StartGame.png")
		self.save_one = Button:new(32, 32, save_1)

		table.insert(self.save_buttons, self.save_one)
	end
	--[[
	local one = love.grahics.newImage("Images/numbers/one.png")
	local two = love.grahics.newImage("Images/numbers/two.png")
	local three = love.grahics.newImage("Images/numbers/three.png")
	local four = love.grahics.newImage("Images/numbers/four.png")
	local five = love.grahics.newImage("Images/numbers/five.png")
	local six = love.grahics.newImage("Images/numbers/six.png")
	local seven = love.grahics.newImage("Images/numbers/seven.png")
	local eight = love.grahics.newImage("Images/numbers/eight.png")
	local nine = love.grahics.newImage("Images/numbers/nine.png")
	local ten = love.grahics.newImage("Images/numbers/ten.png")

	self.one_button
	self.two_button
	self.three_button
	self.four_button
	self.five_button
	self.six_button
	self.seven_button
	self.eight_button
	self.nine_button
	self.ten_button
	--]]
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

