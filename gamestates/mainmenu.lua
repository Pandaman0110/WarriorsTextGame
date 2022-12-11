mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

	self.buttons = {}
	local startImage = love.graphics.newImage("Images/StartGame.png")
	self.start_game = Button:new(imageCenterX(startImage), imageCenterY(startImage), startImage)

	table.insert(self.buttons, self.start_game)

end

function mainmenu:update(dt)
	
end

function mainmenu:mousepressed(x, y, button)
	--this is because of push and the resolution handiling
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.start_game then gamestate.switch(chooseclan) end
			end
		end
	end
end


function mainmenu:draw()

	love.graphics.draw(self.background, 0, 0, 0, 640 / self.background:getWidth(), 480 / self.background:getHeight())

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end