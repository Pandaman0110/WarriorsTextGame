local pairs, ipairs = pairs, ipairs

maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, player_cat)
	--clock
	self.clock = Timer:new()

	self.cat_handler = CatHandler:new(clans, self.clock)
	self.decal_handler = DecalHandler:new()

	self.player = player_cat

	self.buttons = {}

	self.buttons = {}

	-- buttons
	self.help_button = ImageButton:new(480, 320, love.graphics.newImage("Images/help.png"), self.buttons)
	self.combat_button = ImageButton:new(480, 340, love.graphics.newImage("Images/combat.png"), self.buttons)
	self.mouth_button = ImageButton:new(440, 322, Claws[self.player:getClaws()], self.buttons)


	-----------------------


	self.player:setPos(10, 5)

	self.map = Map:new(self.player)

	for i, cat in ipairs(self.cat_handler:getCats()) do
		cat:setController(Ai:new(cat, self.cat_handler, self.map:getCollisionMap()))
	end

	self.player:setController(Player:new(self.player, self.cat_handler, self.map:getCollisionMap()))



	local randomcat = self.cat_handler:randomCat()

	randomcat:move(5, 5)
end

function maingame:update(dt)
	self.clock:update(dt)

	self:updateCats(dt)
	self:updateDecals(dt)

	self.map:update(dt)
end

function maingame:keypressed(key)
	self.player:getController():keypressed(key)
	self.mouth_button:setImage(Claws[self.player:getClaws()])
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
			self.cat_handler:readMessage(message)
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
	self.cat_handler:update(dt)
end

function maingame:updateDecals(dt)
	self.decal_handler:update(dt)
end

function maingame:drawDecals(offset_x, offset_y, firstTile_x, firstTile_y)
	self.decal_handler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
end

function maingame:drawCats(offset_x, offset_y, firstTile_x, firstTile_y)
	for i = 2, #self.cat_handler:getCats() do
		local cat = self.cat_handler:getCats()[i]
		cat:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	end
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