loadgame = class("loadgame")


--[[TODO]]

--display save details or something
function loadgame:initialize()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = Array:new()

	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)
	self.delete_button = ImageButton:new(112, 312, love.graphics.newImage("Images/next.png"), self.buttons)
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
	for _button in self.buttons:iterator() do
		_button:draw()
	end
end

function loadgame:drawSaveButtons()
	for _button in self.save_buttons:iterator() do
		_button:draw()
	end
end

function loadgame:checkButtons(mx, my, button)
	for _button in self.buttons:iterator() do
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
	for _button in self.save_buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			self.save = _button:getObject() 
		end
	end
end

function loadgame:saveButtons()
	self.save = nil
	self.save_buttons = Array:new()
	
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