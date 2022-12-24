chooseclan = {}

function chooseclan:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)
	local _back = love.graphics.newImage("Images/next.png")
	self.back_button = Button:new(32, 300, _back)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)

	self.clans = {}

	local clan1 = genClan("Thunder")
	local clan2 = genClan("River")
	local clan3 = genClan("Wind")
	local clan4 = genClan("Shadow")

	table.insert(self.clans, clan1)
	table.insert(self.clans, clan2)
	table.insert(self.clans, clan3)
	table.insert(self.clans, clan4)

	for i, clan in pairs(self.clans) do
		local _button = ObjectButton:new(160 * (i-1) + 32, 32, clan)
		table.insert(self.buttons, _button)
	end

	self.choice = nil
end

function chooseclan:update(dt)

end

function chooseclan:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button and self.choice ~= nil then gamestate.switch(charactercreate, self.clans, self.choice) end
				if _button == self.back_button and self.choice ~= nil then gamestate.switch(mainmenu) end
				if i > 2 then self.choice = _button:getObject() end
			end
		end
	end
end


function chooseclan:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	--if self.choice == self.clans[1] then love.graphics.draw(self.thunder_clan:getImage(), 128 + 64, 240) end
	--if self.choice == self.clans[2] then love.graphics.draw(self.river_clan:getImage(), 128 + 64, 240) end
	--if self.choice == self.clans[3] then love.graphics.draw(self.wind_clan:getImage(), 128 + 64, 240) end
	--if self.choice == self.clans[4] then love.graphics.draw(self.shadow_clan:getImage(), 128 + 64, 240) end

	if self.choice ~= nil then self.choice:draw(128 + 64, 240) end

	textSettings()
	love.graphics.setFont(EBG_R_20)
	if self.choice ~= nil then love.graphics.printf(self.choice:getName(), 320, 280, 500, "left" , 0, scX()) end
	clear()


end
