--put a help button somewhere
--put the selected cat somewhere
--put a scrolling list page thingy so the player can see all the cats
choosecharacter = {}

function choosecharacter:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(480, 300, _next)
	local _back = love.graphics.newImage("Images/next.png")
	self.back_button = Button:new(32, 300, _back)

	local _left = love.graphics.newImage("Images/ArrowLeft.png")
	self.left_button = Button:new(392, 32, _left)
	local _right = love.graphics.newImage("Images/ArrowRight.png")
	self.right_button = Button:new(576, 32, _right)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)
	table.insert(self.buttons, self.left_button)
	table.insert(self.buttons, self.right_button)

	self.clans = {}

	local clan1 = genClan("Thunder")
	local clan2 = genClan("River")
	local clan3 = genClan("Wind")
	local clan4 = genClan("Shadow")

	table.insert(self.clans, clan1)
	table.insert(self.clans, clan2)
	table.insert(self.clans, clan3)
	table.insert(self.clans, clan4)

	for i, clan in pairs(self.clans) do
		local _button = ObjectButton:new(32, 32 + 64 * (i-1), clan)
		table.insert(self.buttons, _button)
	end

	self.playerClan = clan1

	self.catListNum = 1
	self.catListRoles = {"Kits", "Warriors", "Apprentices", "Other"}
	self.catListTables = {clan1:getKits(), clan1:getWarriors(), clan1:getApprentices(), clan1:getOther()}

	self.cat_buttons = {}

	for i, cat in ipairs(self.catListTables[self.catListNum]) do
		local cat_button
		if i > 5 then
			local k = i - 5
			cat_button = InvisibleButton:new(512, 80 + 40 * (k-1), 120, 32, cat)
		else
			cat_button = InvisibleButton:new(392, 80 + 40 * (i-1), 120, 32, cat)
		end
		table.insert(self.cat_buttons, cat_button)
	end

	self.currentCat = clan1:getKits()[1]
end

function choosecharacter:update(dt)
end

function choosecharacter:mousepressed(x, y, button) 
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if i <= 2 then 
					if _button == self.next_button then gamestate.switch(charactercreate) end
					if _button == self.back_button then gamestate.switch(mainmenu) end
				else 
					if _button == self.left_button then 
						self.catListNum = self.catListNum - 1 
						if self.catListNum == 0 then self.catListNum = 4 end
					end
					if _button == self.right_button then 
						self.catListNum = self.catListNum + 1
						if self.catListNum == 5 then self.catListNum = 1 end
					end
					if i > 4 then 
						local clan = _button:getObject()
						self.playerClan = clan
						self.catListTables = {clan:getKits(), clan:getWarriors(), clan:getApprentices(), clan:getOther()}
					end

					self.cat_buttons = {}

					for i, cat in pairs(self.catListTables[self.catListNum]) do
						local cat_button
						if i > 5 then
							local k = i - 5
							cat_button = InvisibleButton:new(512, 80 + 32 * (k-1), 120, 32, cat)
						else
							cat_button = InvisibleButton:new(392, 80 + 32 * (i-1), 120, 32, cat)
						end
						table.insert(self.cat_buttons, cat_button)
					end

					self.currentCat = self.cat_buttons[1]:getObject()
				end
			end
		end
		for i, _button in ipairs (self.cat_buttons) do
			if _button:mouseInside(mx, my) == true then
				self.currentCat = _button:getObject()
			end
		end
	end
end

function choosecharacter:update(dt)
end
	
function choosecharacter:draw()	
	local cat = self.currentCat
	local clan = self.playerClan
	local textX = 232
	local num = self.catListNum

	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	--all the images right here
	clan:draw(112, 32, 2)
	cat:draw(126, 176, 2)

	--printing current clan text
	textSettings()
	love.graphics.setFont(EBG_R_20)

	love.graphics.print(clan:getName(), textX, 32, 0, scX()) 

	love.graphics.setFont(EBG_R_10)

	love.graphics.print("The leader is " .. clan:getLeader():getName(), textX, 64, 0, scX())
	love.graphics.print("The deputy is " .. clan:getDeputy():getName(), textX, 80, 0, scX())
	love.graphics.print("The medicine cat is " .. clan:getMedicineCat():getName(), textX, 96, 0, scX())
	love.graphics.print("There are " .. clan:getNumCats() .. " cats", textX, 112, 0, scX())

	--current cat text
	love.graphics.setFont(EBG_R_20)

	love.graphics.print(cat:getName(), textX, 152, 0, scX())

	love.graphics.setFont(EBG_R_10)

	love.graphics.print(cat:getRole(), textX, 184, 0, scX())
	love.graphics.print(cat:getMoons().." moons old", textX, 200, 0, scX())
	love.graphics.print(cat:getGender(), textX, 216, 0, scX())
	love.graphics.print(cat:getHealth().." health", textX, 232, 0, scX())
	love.graphics.print("Mom and dad... "..cat:getMom():getName().." and "..cat:getDad():getName(), textX, 248, 0, scX())

	if cat:getRole() == "Kit" then
		local str = ""
		for i, kit in ipairs (cat:getMom():getKits()) do 
			local kits = cat:getMom():getKits()
			if i == #kits then str = str .. kit:getName()
			else str = str .. kit:getName() .. ", " end
		end
		love.graphics.print("Littermates... ".. str, textX, 264, 0, scX())
	end

	local k = 0
	if cat:getMate() then love.graphics.print("Mate... " .. cat:getMate():getName(), textX, 264 + k * 16, 0, scX()) k = k + 1 end
	if cat:getMentor() then love.graphics.print("Mentor... " .. cat:getMentor():getName(), textX, 264 + k * 16 , 0, scX()) k = k + 1 end
	if cat:getApprentice() then love.graphics.print("Apprentice... " .. cat:getMentor():getName(), textX, 264 + k * 16, 0, scX()) k = k + 1 end
	if cat:hasKits() then 
		local str = ""
		for i, kit in ipairs (cat:getKits()) do 
			local kits = cat:getMom():getKits()
			if i == #kits then str = str .. kit:getName()
			else str = str .. kit:getName() .. ", " end
		end
		love.graphics.print("Kits... ".. str, textX, 264 + k * 16, 0, scX())
		k = k + 1
	end

	--catlist text

	love.graphics.setFont(EBG_R_20)

	local str = self.catListRoles[num]
	local strlen = string.len(str)
	strlen = 8 - strlen

	love.graphics.print(str, 460 + strlen * 4, 32, 0, scX())

	clear()

	for i, _button in ipairs(self.cat_buttons) do
		local cat = _button:getObject()
		print(cat:getName())
		textSettings()
		love.graphics.setFont(EBG_R_10)
		if i > 5 then
			local k = i - 5
			love.graphics.print(cat:getName(), 560, 88 + 32 * (k-1), 0, scX())
			clear()
			cat:draw(512, 80 + 32 * (k-1))
		else  
			love.graphics.print(cat:getName(), 440, 88 + 32 * (i-1), 0, scX())
			clear()
			cat:draw(392, 80 + 32 * (i-1))
		end
	end
end