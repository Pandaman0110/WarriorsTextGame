maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, playerclan, playerCat)
	self.buttons = {}

	self.clans = clans
	self.cats = {}

	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			table.insert(self.cats, cat)
		end
	end

	self.player = Player:new(playerCat, self.cats)
	self.playerclan = playerclan

	--clock
	self.seconds = 0
	self.secondsAfter = 0
	self.minutes = 0

	self.map = Map:new(self.player, self.cats)

	print(self.player:getAnimal():getClaws())

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.player:getAnimal():getClaws()], self.buttons)
end

function maingame:update(dt)
	--clock
	self.seconds = self.seconds + dt
	self.secondsAfter = math.floor(self.seconds % 60)
	self.minutes = math.floor(self.seconds / 60)

	self.map:update(dt)
end

function maingame:keypressed(key)
	local player_cat = self.player:getAnimal()
	if key == 'c' then 
		player_cat:switchClaws(Claws[self.player:getAnimal():getClaws()])
		self.mouth_button:setImage(Claws[self.player:getAnimal():getClaws()])
	end

end


function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	if mx == nil or my == nil then mx, my = -99, -99 end
	local tx, ty = math.floor((mx+self.player:getAnimal():getX()+16)/32 - 9), math.floor((my+self.player:getAnimal():getY()-8)/32 - 4)
	local button_pressed = false --buttons

	print(mx .. "  " .. my)
	--this returns what tile you clicked
	--print(math.floor((mx+self.player:getCat():getX()+16)/32 - 9).. "  " .. math.floor((my+self.player:getCat():getY()-8)/32 - 4))

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				button_pressed = true
				if _button == self.help_button then self.player:getAnimal():setIntent("help") end
				if _button == self.combat_button then self.player:getAnimal():setIntent("combat") end
			end
		end
		if button_pressed ~= true then
			for i, cat in ipairs(self.cats) do
				if cat:getTileX() == tx and cat:getTileY() == ty then end
			end
		end
	end

end

function maingame:draw()
	self.map:draw()

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	textSettings()
	love.graphics.setFont(EBG_R_20)
	self:drawTime(10, 10)
	clear()
end

function maingame:drawTime(x, y)
	if self.minutes < 10 and self.secondsAfter < 10 then love.graphics.print("0"..self.minutes..":0"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter >= 10 then love.graphics.print("0"..self.minutes..":"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter < 10 then love.graphics.print("0"..self.minutes..":0"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter >= 10 then love.graphics.print("0"..self.minutes..":"..self.secondsAfter, x, y, 0, scX()) end
end
