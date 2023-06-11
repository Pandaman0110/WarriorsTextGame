local pairs, ipairs = pairs, ipairs

maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, player_cat, cat_generator)
	--clock, 1440 seconds for each in game day means a minute passes in game for every second in real life
	self.game_clock = Timer:new(1440)
	--self.game_clock:toGame()	

	self:setupHandlers(self.game_clock, clans)
	self.cat_generator = cat_generator

	self.player = player_cat

	self.buttons = {}

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.player:getClaws()], self.buttons)


	-----------------------


	self.player:setPos(10, 5)
	self.map = Map:new(self.player)


	for cat in self.cat_handler:getCatIterator() do
		cat:setController(Ai:new(cat, self.cat_handler, self.map:getCollisionMap()))
	end

	local temp1 = {}
	local temp2 = {}
	

	self.player:setController(Player:new(self.player, self.cat_handler, self.map:getCollisionMap()))

	local randomcat = self.cat_handler:findNonPlayer()

	randomcat:move(5, 5)

	self.relationships_handler:newRelationship(self.player:getName(), randomcat:getName())
	self.relationships_handler:printCatRelationships(self.player:getName())

end

function maingame:update(dt)
	self.game_clock:update(dt)

	self:updateCats(dt)
	self:updateDecals(dt)

	self.map:update(dt)
end

function maingame:keypressed(key)
	self.player:getController():keypressed(key)
	self.mouth_button:setImage(Claws[self.player:getClaws()])

	self.game_clock:keypressed(key)
end


function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	if mx == nil or my == nil then mx, my = -99, -99 end
	local tx, ty = math.floor((mx+self.player:getX()+16)/32 - 9), math.floor((my+self.player:getY()-8)/32 - 4)

	--this returns what tile you clicked
	--print(math.floor((mx+self.player:getCat():getX()+16)/32 - 9).. "  " .. math.floor((my+self.player:getCat():getY()-8)/32 - 4))

	local button_pressed = self:checkButtons(mx, my, button)
	if button_pressed == false then 
		local message = self.player:getController():mousepressed(tx, ty, button)

		if message ~= nil then 
			self.cat_handler:handleMessage(message)
		end
		--if result then
		--	if result["Bleed"] then 
		--		self.decal_handler:createDecal(tx, ty, random(1, 3))
		--	end
		--end
	end
end

function maingame:draw()
	local offset_x, offset_y, firstTile_x, firstTile_y = self.map:draw()

	self:drawButtons()

	self.player:drawImage(640 / 2 - 18, 360 / 2 - 16)
	self:drawCats(offset_x, offset_y, firstTile_x, firstTile_y)
	self:drawDecals(offset_x, offset_y, firstTile_x, firstTile_y)

	textSettings()
	love.graphics.setFont(EBG_R_20)
	self.game_clock:draw(16, 16)
	clearTextSettings(00)
end

----------------------------------------------------------------------------------------------

function maingame:drawButtons()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end
end

function maingame:updateCats(dt)
	self.cat_handler:update(dt)
end

function maingame:updateDecals(dt)
	self.decal_handler:update(dt)
end

function maingame:drawDecals(offset_x, offset_y, firstTile_x, firstTile_y)
	self.decal_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
end

function maingame:drawCats(offset_x, offset_y, firstTile_x, firstTile_y)
	self.cat_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
end

function maingame:checkButtons(mx, my, button)
	local button_pressed = false

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				button_pressed = true
				if _button == self.help_button then 
					self.player:setIntent("help")
					print(self.player:getIntent())
				 end
				if _button == self.combat_button then 
					self.player:setIntent("combat")
					print(self.player:getIntent())
				end
			end
		end
	end
	return button_pressed
end

function maingame:setupHandlers(clocks, clans)
	self.clan_handler = ClanHandler:new(clock)
	self.clan_handler:loadClans(clans)

	self.cat_handler = CatHandler:new(clock)

	for clan in self.clan_handler:getClanIterator() do
		self.cat_handler:loadCatsfromClan(clan)
	end


	self.relationships_handler = RelationshipHandler:new()

	for cat_1 in self.cat_handler:getCatIterator() do
		for cat_2 in self.cat_handler:getCatIterator() do
			local cat_1_name, cat_2_name = cat_1:getName(), cat_2:getName()
			local same_name = (cat_1_name ~= cat_2_name)
			assert(same_name, "attempt to create a duplicate relationship between: " .. cat_1_name .. " and " .. cat_2_name)
			if same_name then self.relationships_handler:newRelationship(cat_1_name, cat_2_name) end
		end
	end

	self.decal_handler = DecalHandler:new()
end