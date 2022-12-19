charactercreate = {}

function charactercreate:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	--buttons
	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 400, _next)

	table.insert(self.buttons, self.next_button)
end

function charactercreate:enter(previous, clan)
	self.playerClanName = clan
	self.playerClan = genClan(self.playerClanName)
	self.playerClan:printDetails()
end

function charactercreate:update(dt)

end


function charactercreate:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then gamestate.switch() end
			end
		end
	end

	self.playerClan:getLeader():getName()
end


function charactercreate:draw()
	clear()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	love.graphics.setFont(EBG_R)
	

	love.graphics.pop()
		love.graphics.setColor(110/255, 38/255, 14/255)
		love.graphics.print(self.playerClan:getLeader():getName(), 30 / xScale, 30 / yScale)
	love.graphics.push()
end