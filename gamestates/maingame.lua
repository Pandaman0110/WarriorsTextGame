local pairs, ipairs = pairs, ipairs

maingame = class("maingame")

function maingame:enter(previous, clans, player_cat, cat_generator)
	--clock, 1440 seconds for each in game day means a minute passes in game for every second in real life
	self.game_clock = Timer:new(1440)
	--self.game_clock:toGame(

	self.clans = clans
	self.cat_generator = cat_generator


	-----------------------

	self:setupHandlers(self.game_clock)

	self.cat_handler:getPlayer():setGamePos({10, 5})

	self.randomcat = self.cat_handler:getRandomNonPlayer()


	---------------

	for i, cat in self.cat_handler:iterator() do
		cat:setController(AnimalController:new(cat, self.cat_handler, self.map_handler))
	end



	self.cat_handler:getPlayer():setController(Player:new(self.cat_handler:getPlayer(), self.cat_handler, self.map_handler))


	self.randomcat:move({5,5})
	--self.game_handler:sendCat(self.randomcat, "river_clan_base")

	self.cat_handler:getPlayer():setBehavior(BehaviorTree:new(CatBehaviorTree, self.cat_handler:getPlayer(), self.cat_handler, self.game_handler, self.clock))

	--self.randomcat:setBehavior(BehaviorTree:new(CatBehaviorTree, self.randomcat, self.cat_handler, self.game_handler, self.clock))

	local root = self.cat_handler:getPlayer():getBehavior():getRoot()


	self.cat_handler:getPlayer():getBehavior():tick(.001)


	self.buttons = Array:new()

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.cat_handler:getPlayer():getClaws()], self.buttons)


	self.cat_buttons = Array:new()

	--catbuttons
	
end

function maingame:update(dt)
	--love.profiler.start()
	self.game_clock:update(dt)
	self.cat_handler:update(dt)
	--self.cat_handler:getPlayer():getBehavior():tick(dt)
	self.decal_handler:update(dt)
	self.map_handler:update(dt)
	self.game_handler:update(dt)
	--love.profiler.stop()
end

function maingame:keypressed(key)
	self.cat_handler:getPlayer():getController():keypressed(key)
	self.mouth_button:setImage(Claws[self.cat_handler:getPlayer():getClaws()])

	self.game_clock:keypressed(key)

	if key == "k" then 
		self.cat_handler:getPlayer():getBehavior():tick(.001)
	end
end


function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	local player_pos = self.cat_handler:getPlayer():getRealPos()

	if mx == nil or my == nil then mx, my = -999999, -9999999 end
	local tx, ty = math.floor((mx+player_pos[1]+16)/32 - 9), math.floor((my+player_pos[2]-8)/32 - 4)

	local button_pressed = self:checkButtons(mx, my, button)
	if button_pressed == false then 
		local message = self.cat_handler:getPlayer():getController():mousepressed(tx, ty, button)

		if message ~= nil then 
			self.cat_handler:handleMessage(message)
		end
	end
end

function maingame:draw()
	local offset_x, offset_y, firstTile_x, firstTile_y = self.map_handler:draw()



	self.cat_handler:getPlayer():drawImage(640 / 2 - 18, 360 / 2 - 16)


	self.cat_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	self.decal_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	self.game_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)

	textSettings()
	love.graphics.setFont(EBG_R_20)
	self.game_clock:draw(16, 16)
	clearTextSettings(00)
	self:drawButtons()
end

----------------------------------------------------------------------------------------------

function maingame:drawButtons()
	for i, _button in self.buttons:iterator() do
		_button:draw()
	end
end

function maingame:checkButtons(mx, my, button)
	local button_pressed = false

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my) == true then
			button_pressed = true
			if _button == self.help_button then 
				self.cat_handler:getPlayer():setIntent("help")
				print(self.cat_handler:getPlayer():getIntent())
			end
			if _button == self.combat_button then 
				self.cat_handler:getPlayer():setIntent("combat")
				print(self.cat_handler:getPlayer():getIntent())
			end
		end
	end
	return button_pressed
end

function maingame:setupHandlers(clock)
	self.cat_handler = CatHandler:new(clock)
	for i, clan in self.clans:iterator() do
		self.cat_handler:loadCatsFromClan(clan)
	end
	self.map_handler = MapHandler:new(self.cat_handler:getPlayer(), "default")
	self.decal_handler = DecalHandler:new()
	self.game_handler = GameHandler:new(clock)
end