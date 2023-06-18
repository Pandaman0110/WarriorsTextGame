local pairs, ipairs = pairs, ipairs

maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, player_cat, cat_generator)
	--clock, 1440 seconds for each in game day means a minute passes in game for every second in real life
	self.game_clock = Timer:new(1440)
	--self.game_clock:toGame(

	self.clans = clans
	self.cat_generator = cat_generator
	self.player = player_cat

	self.buttons = Array:new()

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.player:getClaws()], self.buttons)


	-----------------------

	self.player:setGamePos({10, 5})

	self:setupHandlers(self.game_clock)

	local randomcat = self.cat_handler:findNonPlayer()

	for i, cat in self.cat_handler:iterator() do
		cat:setController(AnimalController:new(cat, self.cat_handler, self.map_handler:getCollisionMap()))
	end

	local temp1 = {}
	local temp2 = {}

	self.player:setController(Player:new(self.player, self.cat_handler, self.map_handler:getCollisionMap())) 

	randomcat:moveto({5,5})
	self.game_handler:sendCat(randomcat, "river_clan_base")

	self.behavior_tree = BehaviorTree:new(CatBehaviorTree, randomcat)
end

function maingame:update(dt)
	--love.profiler.start()
	self.game_clock:update(dt)
	self.cat_handler:update(dt)
	self.decal_handler:update(dt)
	self.map_handler:update(dt)
	self.game_handler:update(dt)
	--love.profiler.stop()
end

function maingame:keypressed(key)
	self.player:getController():keypressed(key)
	self.mouth_button:setImage(Claws[self.player:getClaws()])

	self.game_clock:keypressed(key)
end


function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	local player_pos = self.player:getRealPos()

	if mx == nil or my == nil then mx, my = -999999, -9999999 end
	local tx, ty = math.floor((mx+player_pos[1]+16)/32 - 9), math.floor((my+player_pos[2]-8)/32 - 4)

	local button_pressed = self:checkButtons(mx, my, button)
	if button_pressed == false then 
		local message = self.player:getController():mousepressed(tx, ty, button)

		if message ~= nil then 
			self.cat_handler:handleMessage(message)
		end
	end
end

function maingame:draw()
	local offset_x, offset_y, firstTile_x, firstTile_y = self.map_handler:draw()

	self.player:drawImage(640 / 2 - 18, 360 / 2 - 16)
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

	if button == 1 then
		for i, _button in self.buttons:iterator() do
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

function maingame:setupHandlers(clock)
	self.map_handler = MapHandler:new(self.player, self.cat_handler)
	self.cat_handler = CatHandler:new(clock)
	self.decal_handler = DecalHandler:new()
	self.game_handler = GameHandler:new(clock)
	for i, clan in self.clans:iterator() do
		self.cat_handler:loadCatsFromClan(clan)
	end
end