maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, playerclan, playerCat)
	self.buttons = {}

	-- buttons
	local _help = love.graphics.newImage("Images/help.png")
	self.help_button = Button:new(480, 320, _help)
	local _combat = love.graphics.newImage("Images/combat.png")
	self.combat_button = Button:new(480, 340, _combat)
	local _mouthbox = love.graphics.newImage("Images/mouthbox.png")
	self.mouth_button = Button:new(440, 322, _mouthbox)

	table.insert(self.buttons, self.help_button)
	table.insert(self.buttons, self.combat_button)
	table.insert(self.buttons, self.mouth_button)

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
end

function maingame:update(dt)
	--clock
	self.seconds = self.seconds + dt
	self.secondsAfter = math.floor(self.seconds % 60)
	self.minutes = math.floor(self.seconds / 60)

	self.map:update(dt)
end

function maingame:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)
	local tx, ty = math.floor((mx+self.player:getCat():getX()+16)/32 - 9), math.floor((my+self.player:getCat():getY()-8)/32 - 4)
	local button_pressed = false --buttons

	--this returns what tile you clicked
	--print(math.floor((mx+self.player:getCat():getX()+16)/32 - 9).. "  " .. math.floor((my+self.player:getCat():getY()-8)/32 - 4))

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				button_pressed = true
				if _button == self.help_button then self.player:getCat():setIntent("help") end
				if _button == self.combat_button then self.player:getCat():setIntent("combat") end
			end
		end
		if button_pressed ~= true then
			for i, cat in ipairs(self.cats) do
				if cat:getTileX() == tx and cat:getTileY() == ty then cat = _cat end
			end
		end
	end

	print(self.player:getCat():getIntent())
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
