maingame = {}

function maingame:init()
	self.buttons = {}
end

function maingame:enter(previous, clans, playerclan, playerCat)
	self.clans = clans
	self.player = Player:new()
	self.player:setCat(playerCat)
	self.playerclan = playerclan

	--clock
	self.seconds = 0
	self.secondsAfter = 0
	self.minutes = 0

	self.c1 = cron.every(1, function() self.seconds = self.seconds + 1 end)

	self.map = Map:new(self.player)
	
end

function maingame:update(dt)
	--clock
	self.secondsAfter = math.floor(self.seconds % 60)
	self.minutes = math.floor(self.seconds / 60)

	self.c1:update(dt)

	self.map:update(dt)

	--print(self.player:getCat():getTileX() .. self.player:getCat():getTileY())
	
end

function maingame:mousepressed(x, y, button)
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