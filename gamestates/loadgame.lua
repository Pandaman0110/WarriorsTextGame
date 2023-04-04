loadgame = {}


--display save details or something
function loadgame:init()
end

function loadgame:enter(previous)
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)

	self.save = nil
	self.save_buttons = {}
	self.saves = {}
	self.save_names = loadSaveNames()
	
	for i, name in ipairs (self.save_names) do
		local save_button
		local save = loadSave(name)
		table.insert(self.saves, save)

		if i > 5 then
			local k  = i - 5
			save_button = ObjectButton:new(96, 32 + 32 * (k - 1), self.saves[i], SaveNumbers[i], self.save_buttons)
		else 
			save_button = ObjectButton:new(32, 32 + 32 * (i - 1), self.saves[i], SaveNumbers[i], self.save_buttons)
		end
	end
end

function loadgame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then
					if self.save == nil then break
					else 
						local game_phase = self.save[2]
						if game_phase == 1 then gamestate.switch(choosecharacter, self.save)
						elseif game_phase == 2 then gamestate.switch(maingame, self.save)
						end
					end
				end
				if _button == self.back_button then gamestate.switch(mainmenu) end
			end
		end
		for i, _button in ipairs (self.save_buttons) do
			if _button:mouseInside(mx, my) == true then
				self.save = _button:getObject() 
			end
		end
	end
end

function loadgame:draw()
	local name, game_phase, player, clans
	if self.save ~= nil then
		name = self.save[1]
		game_phase = self.save[2]
		player = self.save[3]
		clans = self.save[4]
	end

	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	for i, _button in ipairs(self.save_buttons) do 
		_button:draw()
	end

	if self.save ~= nil then
		textSettings()
		love.graphics.setFont(EBG_R_25)

		love.graphics.printf(name, 0, 32, 1920, "center", 0, scX())

		love.graphics.setFont(EBG_R_20)

		love.graphics.print(player:getName(), 160 + 106, 80, 0, scX())

		clear()

		player:drawImage(160, 80, 2)
	end

end
