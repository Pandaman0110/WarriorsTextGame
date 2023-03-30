play = {}

function play:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}

	local new = love.graphics.newImage("Images/newbutton.png")
	self.new_button = Button:new(32, 128, new)
	local load = love.graphics.newImage("Images/loadbutton.png")
	self.load_button = Button:new(32, 192+16, load)
	local _back = love.graphics.newImage("Images/back.png")
	self.back_button = Button:new(32, 312, _back)

	table.insert(self.buttons, self.new_button)
	table.insert(self.buttons, self.load_button)
	table.insert(self.buttons, self.back_button)
end 

function play:enter(previous)
end

function play:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

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

function play:update(dt)

end

function play:draw()
	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 360 / self.background:getHeight())

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end