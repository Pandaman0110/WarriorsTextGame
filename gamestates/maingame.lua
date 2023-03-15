maingame = {}

function maingame:init()
end

function maingame:enter(previous, clans, playerclan, playerCat)
	self.buttons = {}

	self.clans = clans
	self.player = Player:new(playerCat, clans)

	self.playerclan = playerclan

	--clock
	self.seconds = 0
	self.secondsAfter = 0
	self.minutes = 0

	self.map = Map:new(self.player, self.clans)
	
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
	local button_pressed = false
	local cat = "empty"

	--this returns what tile you clicked
	--print(math.floor((mx+self.player:getCat():getX()+16)/32 - 9).. "  " .. math.floor((my+self.player:getCat():getY()-8)/32 - 4))

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				button_pressed = true
			end
		end
		if button_pressed ~= true then
			for i, clan in ipairs(self.clans) do
				for i, _cat in ipairs(clan:getCats()) do
					if _cat:getTileX() == tx and _cat:getTileY() == ty then cat = _cat end
				end
			end
		end
	end

	if cat ~= "empty" then print(cat:getName()) else print(cat) end

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