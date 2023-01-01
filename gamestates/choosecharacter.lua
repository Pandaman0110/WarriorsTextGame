--put a help button somewhere
choosecharacter = {}

function choosecharacter:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.buttons = {}

	local _back = love.graphics.newImage("Images/back.png")
	self.back_button = Button:new(32, 312, _back)
	local _next = love.graphics.newImage("Images/next.png")
	self.next_button = Button:new(544, 312, _next)

	local _left = love.graphics.newImage("Images/ArrowLeft.png")
	self.left_button = Button:new(392, 32, _left)
	local _right = love.graphics.newImage("Images/ArrowRight.png")
	self.right_button = Button:new(576, 32, _right)

	table.insert(self.buttons, self.next_button)
	table.insert(self.buttons, self.back_button)
	table.insert(self.buttons, self.left_button)
	table.insert(self.buttons, self.right_button)

end

function choosecharacter:enter(previous, save, viewing)
	self.save = nil
	if save then self.save = save end
	if viewing then self.viewing = true else self.viewing = false end

	self.clans = {}

	local clan1
	local clan2
	local clan3
	local clan4

	if not self.save then 
		clan1 = genClan("Thunder")
		clan2 = genClan("River")
		clan3 = genClan("Wind")
		clan4 = genClan("Shadow")
	elseif self.save then
		clan1 = self.save[2]
		clan2 = self.save[3]
		clan3 = self.save[4]
		clan4 = self.save[5]
	end

	table.insert(self.clans, clan1)
	table.insert(self.clans, clan2)
	table.insert(self.clans, clan3)
	table.insert(self.clans, clan4)

	for i, clan in pairs(self.clans) do
		local _button = ObjectButton:new(32, 32 + 64 * (i-1), clan)
		table.insert(self.buttons, _button)
	end

	self.playerClan = clan1
	self:tableSetup()
	self:catButtons()
end


function choosecharacter:update(dt)
end

function choosecharacter:mousepressed(x, y, button) 
	local mx, my = push:toGame(x, y)

	if button == 1 then 
		for i, _button in ipairs (self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if i <= 2 then 
					if _button == self.next_button then gamestate.switch(maingame) end
					if _button == self.back_button then gamestate.switch(mainmenu) end
				else 
					if _button == self.left_button then 
						self.catListPage = self.catListPage - 1 
						if self.catListPage == 0 then self.catListPage = self.pages  end
					end
					if _button == self.right_button then 
						self.catListPage = self.catListPage + 1
						if self.catListPage == self.pages + 1 then self.catListPage = 1 end
					end
					if i > 4 then 
						local clan = _button:getObject()
						self.playerClan = clan
						self:tableSetup()
					end
					self:catButtons()
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
	local num = self.catListPage

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

	--local str = self.catListRoles[num]
	--local strlen = string.len(str)
	--strlen = 8 - strlen

	--love.graphics.print("Page ".."1", 460 + strlen * 4, 32, 0, scX())

	love.graphics.print("Page "..num, 470, 32, 0, scX())

	clear()

	for i, _button in ipairs(self.cat_buttons) do
		local cat = _button:getObject()
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

function choosecharacter:catButtons()
	self.cat_buttons = {}
	for i, cat in ipairs(self.catListTables[self.catListPage]) do
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

function choosecharacter:tableSetup()
	self.catListPage = 1
	self.catListRoles = {}
	self.catListTables = {}
	self.pages = 0
	self.pages = self.pages + (math.floor(self.playerClan:getNumCats() / 10))
	if self.playerClan:getNumCats() % 10 ~= 0 then self.pages = self.pages + 1 end
	print(self.pages)

	for i = 1, self.pages do
		local t = {}
		table.insert(self.catListTables, t)
		for k = 1, 10 do
			table.insert(self.catListTables[i], self.playerClan:getCats()[k+(10*(i-1))])
		end
	end
end