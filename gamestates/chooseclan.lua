chooseclan = {}

function chooseclan:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local thunderclan = love.graphics.newImage("Images/ThunderclanSymbol.png")
	self.thunder_clan = Button:new(32, 32, thunderclan)
	local riverclan = love.graphics.newImage("Images/RiverclanSymbol.png")
	self.river_clan = Button:new(128 + 64, 32, riverclan)
	local shadowclan = love.graphics.newImage("Images/ShadowclanSymbol.png")
	self.shadow_clan = Button:new(256 + 96, 32, shadowclan)
	local windclan = love.graphics.newImage("Images/WindclanSymbol.png")
	self.wind_clan = Button:new(384 + 128, 32, windclan)

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)

	table.insert(self.buttons, self.thunder_clan)
	table.insert(self.buttons, self.river_clan)
	table.insert(self.buttons, self.shadow_clan)
	table.insert(self.buttons, self.wind_clan)
	table.insert(self.buttons, self.next_button)


	self.choice = ""
end

function chooseclan:update(dt)

end

function chooseclan:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.thunder_clan then self.choice = "Thunder" end
				if _button == self.river_clan then self.choice = "River" end
				if _button == self.shadow_clan then self.choice = "Shadow" end
				if _button == self.wind_clan then self.choice = "Wind" end
				if _button == self.next_button and self.choice ~= "" then gamestate.switch(charactercreate, self.choice) end
			end
		end
	end
end


function chooseclan:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	if self.choice == "Thunder" then love.graphics.draw(self.thunder_clan:getImage(), 128 + 64, 240) end
	if self.choice == "River" then love.graphics.draw(self.river_clan:getImage(), 128 + 64, 240) end
	if self.choice == "Shadow" then love.graphics.draw(self.shadow_clan:getImage(), 128 + 64, 240) end
	if self.choice == "Wind" then love.graphics.draw(self.wind_clan:getImage(), 128 + 64, 240) end

	textSettings()
	love.graphics.setFont(EBG_R_20)
	if self.choice ~= "" then love.graphics.printf(self.choice .. "Clan", 320, 280, 500, "left" , 0, scX()) end
	clear()


end
