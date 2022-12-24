loadgame = {}

function loadgame:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)
	local _back = love.graphics.newImage("Images/next.png")
	self.back_button = Button:new(32, 300, _back)

	local save_1 = love.graphics.newImage("Images/StartGame.png")
	self.save_one = Button:new(32, 32, save_1)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)
	table.insert(self.buttons, self.save_one)
end

function loadgame:enter()
	--firest index is the save name
	--next index is the clan, for now
	self.save = {}
end

function loadgame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then gamestate.switch(mainmenu) end
				if _button == self.back_button then gamestate.switch(mainmenu) end
				if _button == self.save_one then
					info = love.filesystem.getInfo("SaveOne")
					if info ~= nil then
						self.save = bitser.loadLoveFile("SaveOne")
					end
				end
			end
		end
	end
end

function loadgame:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	if isEmpty(self.save) ~= true then
		local saveName = self.save[1]
		local clan = self.save[2]
		clan:draw(imageCenterX(clan:getImage()), 64)
		textSettings()
		love.graphics.setFont(EBG_R_20)
		love.graphics.print(saveName, 285, 32, 0, scX())
		clear()
	end
end

