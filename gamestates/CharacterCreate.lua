charactercreate = {}

function charactercreate:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	--buttons
	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)
	local _back = love.graphics.newImage("Images/next.png")
	self.back_button = Button:new(30, 300, _back)


	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)
end

function charactercreate:enter(previous, clan)
	self.playerClanName = clan
	self.playerClan = genClan(self.playerClanName)
	print(self.playerClan:getNumCats())
	self.playerClan:printDetails()

	self.cat_buttons = {}


	for i, kit in pairs(self.playerClan:getKits()) do
		local cat_button = InvisibleButton:new(10, 40 * i, 120, 40, kit)
		table.insert(self.cat_buttons, cat_button)
	end

	self.currentCat = self.playerClan:getKits()[1]
end

function charactercreate:update(dt)

end


function charactercreate:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then gamestate.switch() end
				if _button == self.back_button then gamestate.switch(chooseclan) end
			end
		end
		for i, cat_button in ipairs(self.cat_buttons) do
			if cat_button:mouseInside(mx, my) == true then
				self.currentCat = cat_button:getObject()
			end
		end 
	end
end


function charactercreate:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	for i, kit in pairs(self.playerClan:getKits()) do
		textSettings()
		love.graphics.setFont(EBG_R_10)
		love.graphics.print(kit:getName(), 50, 8 + (40 * i), 0, scX())
		clear()
		kit:draw(10, 40 * i)
	end

	local cat = self.currentCat
	love.graphics.draw(cat:getImage(), imageCenterX(cat:getImage()) - 75, 120, 0 , 2, 2)

	textSettings()
	love.graphics.setFont(EBG_R_20)
	love.graphics.printf(cat:getName(), 320, 100, 500, "left", 0, scX())

	love.graphics.setFont(EBG_R_10)
	love.graphics.printf(cat:getMoons().." moons old", 320, 130, 500, "left", 0, scX())
	love.graphics.printf(cat:getGender(), 320, 145, 500, "left", 0, scX())
	love.graphics.printf(cat:getHealth().." health", 320, 160, 500, "left", 0, scX())

	local str = ""
	for i, kit in ipairs (cat:getMom():getKits()) do 
		local kits = cat:getMom():getKits()
		if i == #kits then str = str .. kit:getName()
		else str = str .. kit:getName() .. ", " end
	end
	love.graphics.printf("Siblings... ".. str, 320, 175, 500, "left", 0, scX())

	clear()
end