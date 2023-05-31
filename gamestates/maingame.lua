local pairs, ipairs = pairs, ipairs

maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, playerCat)
	self.clans = clans

	self.cats = {}
	self.controllers = {}
	self.buttons = {}

	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			table.insert(self.cats, cat)
		end
	end

	self.player = Player:new(playerCat, self.cats, nil, self.controllers)

	--clock
	self.clock = Timer:new()

	self.buttons = {}

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.player:getAnimal():getClaws()], self.buttons)


	self.map = Map:new(self.player)
	
	
end

function maingame:update(dt)
	self.clock:update(dt)

	self:updateCats(dt)
	self:updateControllers(dt)

	self.map:update(dt)
end

function maingame:keypressed(key)
	local player_cat = self.player:getAnimal()
	if key == 'c' then 
		player_cat:switchClaws(Claws[self.player:getAnimal():getClaws()])
		self.mouth_button:setImage(Claws[self.player:getAnimal():getClaws()])
	end
	if key == 'n' then
	end
end


function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	if mx == nil or my == nil then mx, my = -99, -99 end
	local tx, ty = math.floor((mx+self.player:getAnimal():getX()+16)/32 - 9), math.floor((my+self.player:getAnimal():getY()-8)/32 - 4)

	--this returns what tile you clicked
	--print(math.floor((mx+self.player:getCat():getX()+16)/32 - 9).. "  " .. math.floor((my+self.player:getCat():getY()-8)/32 - 4))

	local result = self:checkButtons(mx, my, button)
	if result == false then self.player:mousepressed(tx, ty, button) end
end

function maingame:draw()
	local offset_x, offset_y, firstTile_x, firstTile_y = self.map:draw()

	self:drawButtons()

	self.player:getAnimal():drawImage(640 / 2 - 18, 360 / 2 - 16)
	self:drawCats(offset_x, offset_y, firstTile_x, firstTile_y)

	textSettings()
	love.graphics.setFont(EBG_R_20)
	self.clock:drawTime(16, 16)
	clear()
end

----------------------------------------------------------------------------------------------

function maingame:drawButtons()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end

function maingame:updateCats(dt)
	for i, cat in ipairs(self.cats) do
		cat:update(dt)
	end
end

function maingame:drawCats(offset_x, offset_y, firstTile_x, firstTile_y)
	for i, cat in ipairs(self.cats) do
		if i == 1 then goto continue end
		cat:draw(offset_x, offset_y, firstTile_x, firstTile_y)
		::continue::
	end
end

function maingame:updateControllers(dt)
	for i, controller in ipairs(self.controllers) do
		controller:update(dt)
	end
end

function maingame:checkButtons(mx, my, button)
	local button_pressed = false

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				button_pressed = true
				if _button == self.help_button then self.player:getAnimal():setIntent("help") end
				if _button == self.combat_button then self.player:getAnimal():setIntent("combat") end
			end
		end
	end
	return button_pressed
end