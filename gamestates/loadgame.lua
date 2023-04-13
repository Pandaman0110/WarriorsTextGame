loadgame = {}


--display save details or something
function loadgame:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)
	self.delete_button = ImageButton:new(112, 312, love.graphics.newImage("Images/next.png"), self.buttons)
end

function loadgame:enter(previous)
	self:saveButtons()

	self.name = nil
	self.game_phase = nil
	self.player = nil
	self.clans = nil
end

function loadgame:update(dt)
	self:updateCurrentSave(dt)
end

function loadgame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	self:checkButtons(mx, my, button)
end

function loadgame:draw()
	love.graphics.draw(self.background, 0, 0)

	self:drawButtons()
	self:drawSaveButtons()
	self:drawSave()
end

----------------------------------------------------------------------------------------------

function loadgame:drawButtons()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end

function loadgame:drawSaveButtons()
	for i, _button in ipairs(self.save_buttons) do 
		_button:draw()
	end
end

function loadgame:drawSave()
	if self.save ~= nil then
		textSettings()
		love.graphics.setFont(EBG_R_25)

		love.graphics.printf(saveHandler:getName(self.save), 0, 32, windowWidth, "center", 0, scX())

		love.graphics.setFont(EBG_R_20)

		love.graphics.print(self.player:getName(), 160 + 106, 80, 0, scX())

		clear()

		self.player:drawImage(160, 80, 2)
	end
end

function loadgame:updateCurrentSave(dt)
	if self.save ~= nil then
		self.name = saveHandler:getName(self.save)
		self.game_phase = self.save["Phase"]
		self.player = self.save["Player"]
		self.clans = self.save["Clans"]
	end
end

function loadgame:checkButtons(mx, my, button)
	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then
					if self.save == nil then break
					else 
						local game_phase = self.save["Phase"]
						if game_phase == 1 then gamestate.switch(choosecharacter, self.save)
						elseif game_phase == 2 then gamestate.switch(maingame, self.save)
						end
					end
				end
				if _button == self.back_button then gamestate.switch(mainmenu) end
				if _button == self.delete_button then 
					saveHandler:deleteSave(saveHandler:getName(self.save))
					self:saveButtons()
				end
			end
		end
		for i, _button in ipairs (self.save_buttons) do
			if _button:mouseInside(mx, my) == true then
				self.save = _button:getObject() 
			end
		end
	end
end

function loadgame:saveButtons()
	self.save = nil
	self.save_buttons = {}
	
	local i = 1

	for name, save in pairs (saveHandler:getSaves()) do
		local save_button

		if i > 5 then
			local k  = i - 5
			save_button = ObjectButton:new(96, 32 + 64 * (k - 1), save, SaveNumbers[i], self.save_buttons)
		else 
			save_button = ObjectButton:new(32, 32 + 64 * (i - 1), save, SaveNumbers[i], self.save_buttons)
		end
		i = i + 1
	end
end