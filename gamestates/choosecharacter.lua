--put a help button somewhere
local pairs, ipairs = pairs, ipairs

choosecharacter = {}


function choosecharacter:enter(previous, save)
	self.background = love.graphics.newImage("Images/BrownBackground.png")

	self.cat_generator = CatGenerator:new()

	self:createButtons()
	self:setupSaving()

	self.save = nil
	if save then self.save = save end

	self:clanButtons(true)

	if self.save ~= nil then self.playerClan = self.save["Player"]:getClan()
	else self.playerClan = self.clans:at(1) end

	self:catPagesSetup()
	self:catButtons()

	if self.save ~= nil then self.currentCat = self.save["Player"]
	else self.currentCat = self.cat_buttons:at(1):getObject() end
end

function choosecharacter:leave()
	collectgarbage("collect")
end

function choosecharacter:update(dt)
	self:updateSaveText(dt)
end

function choosecharacter:keypressed(key)
	self.save_name_button:keypressed(key)
end

function choosecharacter:mousepressed(x, y, button) 
	local mx, my = push:toGame(x, y)

	self:checkButtons(mx, my, button)
end

function choosecharacter:draw()
	love.graphics.draw(self.background, 0, 0)

	self:drawButtons()
	self:drawClanButtons()
	self:drawSaveText()
	self:drawCurrentClan()
	self:drawCurrentCat()
	self:drawCatButtons()
end

----------------------------------------------------------------------------------------------

function choosecharacter:createButtons()
	self.buttons = Array:new()

	self.back_button = ImageButton:new(32, 312, love.graphics.newImage("Images/back.png"), self.buttons)
	self.next_button = ImageButton:new(544, 312, love.graphics.newImage("Images/next.png"), self.buttons)
	self.left_button = ImageButton:new(392, 32, love.graphics.newImage("Images/ArrowLeft.png"), self.buttons)
	self.right_button = ImageButton:new(576, 32, love.graphics.newImage("Images/ArrowRight.png"), self.buttons)

	if not save then  
		self.save_button = ImageButton:new(112, 312, love.graphics.newImage("Images/save.png"), self.buttons)
		self.regen_button = ImageButton:new(144, 256, love.graphics.newImage("Images/regen.png"), self.buttons)
	end
end

function choosecharacter:catPagesSetup()
	self.catListPage = 1
	self.catListRoles = Array:new()
	self.catListTables = Array:new()
	self.pages = 0
	self.pages = self.pages + (math.floor(self.playerClan:getNumCats() / 10))
	if self.playerClan:getNumCats() % 10 ~= 0 then self.pages = self.pages + 1 end

	for i = 1, self.pages do
		local t = Array:new()
		self.catListTables:insert(t)
		for k = 1, 10 do
			self.catListTables:at(i):insert(self.playerClan:getCats():at(k+(10*(i-1))))
		end
	end
end

function choosecharacter:drawSaveText()
	textSettings()
	love.graphics.setFont(EBG_R_10)	

	love.graphics.print(self.savingText, 192, 296, 0, scX())
	self.save_name_button:draw()

	clearTextSettings()
end

function choosecharacter:drawButtons()
	for _button in self.buttons:iterator() do
		_button:draw()
	end
end

function choosecharacter:drawClanButtons()
	for _button in self.clan_buttons:iterator() do
		_button:draw()
	end
end

function choosecharacter:drawCurrentClan()
	local textX = 232
	self.playerClan:draw(112, 32, 2)

	textSettings()
	love.graphics.setFont(EBG_R_20)

	love.graphics.print(self.playerClan:getName(), textX, 32, 0, scX()) 

	love.graphics.setFont(EBG_R_10)

	love.graphics.print("The leader is " .. self.playerClan:getLeader():getName(), textX, 64, 0, scX())
	love.graphics.print("The deputy is " .. self.playerClan:getDeputy():getName(), textX, 80, 0, scX())
	love.graphics.print("The medicine cat is " .. self.playerClan:getMedicineCat():getName(), textX, 96, 0, scX())
	love.graphics.print("There are " .. self.playerClan:getNumCats() .. " cats", textX, 112, 0, scX())

	clearTextSettings()
end

function choosecharacter:drawCurrentCat()
	local textX = 232
	self.currentCat:drawImage(126, 176, 2)

	textSettings()

	love.graphics.setFont(EBG_R_20)

	love.graphics.print(self.currentCat:getName(), textX, 152, 0, scX())

	love.graphics.setFont(EBG_R_10)

	love.graphics.print(self.currentCat:getRole(), textX, 184, 0, scX())
	love.graphics.print(self.currentCat:getMoons().." moons old", textX, 200, 0, scX())
	love.graphics.print(self.currentCat:getGender(), textX, 216, 0, scX())
	love.graphics.print("Mom... "..self.currentCat:getMom():getName(), textX, 232, 0, scX())
	love.graphics.print("Dad... "..self.currentCat:getDad():getName(), textX, 248, 0, scX())

	if self.currentCat:getRole() == "Kit" then
		local str = ""
		for i, kit in ipairs (self.currentCat:getMom():getKits()) do 
			local kits = self.currentCat:getMom():getKits()
			if i == #kits then str = str .. kit:getName()
			else str = str .. kit:getName() .. ", " end
		end
		love.graphics.print("Littermates... ".. str, textX, 264, 0, scX())
	end

	local k = 0
	if self.currentCat:getMate() then love.graphics.print("Mate... " .. self.currentCat:getMate():getName(), textX, 264 + k * 16, 0, scX()) k = k + 1 end
	if self.currentCat:getMentor() then love.graphics.print("Mentor... " .. self.currentCat:getMentor():getName(), textX, 264 + k * 16 , 0, scX()) k = k + 1 end
	if self.currentCat:getApprentice() then love.graphics.print("Apprentice... " .. self.currentCat:getMentor():getName(), textX, 264 + k * 16, 0, scX()) k = k + 1 end
	if self.currentCat:hasKits() then 
		local str = ""
		for i, kit in ipairs (self.currentCat:getKits()) do 
			local kits = self.currentCat:getMom():getKits()
			if i == #kits then str = str .. kit:getName()
			else str = str .. kit:getName() .. ", " end
		end
		love.graphics.print("Kits... ".. str, textX, 264 + k * 16, 0, scX())
		k = k + 1
	end
end

function choosecharacter:catButtons()
	self.cat_buttons = Array:new()
	local i = 1
	for cat in self.catListTables:at(self.catListPage):iterator() do
		local cat_button
		if i > 5 then
			local k = i - 5
			cat_button = ObjectButton:new(512, 80 + 32 * (k-1), cat, cat:getImage(), self.cat_buttons)
			cat_button:setWidth(120)
			cat_button:setHeight(32)
		else
			cat_button = ObjectButton:new(392, 80 + 32 * (i-1), cat, cat:getImage(), self.cat_buttons)
			cat_button:setWidth(120)
			cat_button:setHeight(32)
		end
		i = i + 1
	end
end

function choosecharacter:drawCatButtons()
	love.graphics.setFont(EBG_R_20)

	love.graphics.print("Page ".. self.catListPage .. " / " .. self.pages, 460, 32, 0, scX())

	clearTextSettings()

	local i = 1 
	for _button in self.cat_buttons:iterator() do
		local cat = _button:getObject()
		textSettings()
		love.graphics.setFont(EBG_R_10)
		if i > 5 then
			local k = i - 5
			love.graphics.print(cat:getName(), 560, 88 + 32 * (k-1), 0, scX())
			clearTextSettings()
			cat:drawImage(512, 80 + 32 * (k-1))
		else  
			love.graphics.print(cat:getName(), 440, 88 + 32 * (i-1), 0, scX())
			clearTextSettings()
			cat:drawImage(392, 80 + 32 * (i-1))
		end
		i = i + 1
	end
end

function choosecharacter:clanButtons(first)
	self.clans = Array:new()
	self.clan_buttons = Array:new()

	local clan1
	local clan2
	local clan3
	local clan4

	if first then 
		if not self.save then 
			clan1 = self.cat_generator:genClan("Thunder")
			clan2 = self.cat_generator:genClan("River")
			clan3 = self.cat_generator:genClan("Wind")
			clan4 = self.cat_generator:genClan("Shadow")
		elseif self.save then
			clan1 = self.save["Clans"][1]
			clan2 = self.save["Clans"][2]
			clan3 = self.save["Clans"][3]
			clan4 = self.save["Clans"][4]
		end
	else
		clan1 = self.cat_generator:genClan("Thunder")
		clan2 = self.cat_generator:genClan("River")
		clan3 = self.cat_generator:genClan("Wind")
		clan4 = self.cat_generator:genClan("Shadow")
	end


	self.clans:insert(clan1)
	self.clans:insert(clan2)
	self.clans:insert(clan3)
	self.clans:insert(clan4)

	for clan in self.clans:iterator() do
		local _button = ObjectButton:new(32, 32 + 64 * (self.clans:find(clan)-1), clan, clan:getImage(), self.clan_buttons)
	end
end

function choosecharacter:checkButtons(mx, my, button)
	if button == 1 then 
		for  _button in self.buttons:iterator() do
			if _button:mouseInside(mx, my) == true then
				if _button == self.next_button then 
					self.currentCat:setIsPlayer(true) 
					gamestate.switch(maingame, self.clans, self.currentCat, self.cat_generator) 
				end
				if _button == self.back_button then gamestate.switch(mainmenu) end
				if _button == self.save_button then 
					self.saving = not(self.saving)
					if self.saving == true then 
						self.save_name_button:activate()
						self.savingText = "Enter save name, and press save button again to save"
					end
					if self.saving == false and not(self.save_name_button:isEmpty()) then 
						local saveName = self.save_name_button:getText()
						self.currentCat:setIsPlayer("true")
						local success = saveHandler:createSave(saveName, 1, self.currentCat,  self.clans)
						self.currentCat:setIsPlayer("false")

						if success == false then
							self.savingText = "Duplicate name, save not created"
							self.save_name_button:deactivate()
						elseif success == true then
							self.savingText = ""
							self.save_name_button:deactivate()
						end
					end
				end
				if _button == self.regen_button then
					self:clanButtons()
					self.playerClan = self.clans:at(1)
					self:catPagesSetup()
				end
				if _button == self.left_button then 
					self.catListPage = self.catListPage - 1 
					if self.catListPage == 0 then self.catListPage = self.pages  end
				end
				if _button == self.right_button then 
					self.catListPage = self.catListPage + 1
					if self.catListPage == self.pages + 1 then self.catListPage = 1 end
				end
				self:catButtons()
				self.currentCat = self.cat_buttons:at(1):getObject()
			end
		end
		for _button in self.cat_buttons:iterator() do
			if _button:mouseInside(mx, my) == true then
				self.currentCat = _button:getObject()
			end
		end
		for _button in self.clan_buttons:iterator() do
			if _button:mouseInside(mx, my) == true then 
				local clan = _button:getObject()
				self.playerClan = clan
				self:catPagesSetup()
				self:catButtons()
				self.currentCat = self.cat_buttons:at(1):getObject()
			end
		end
	end
end

function choosecharacter:updateSaveText(dt)
	if self.savingText == "Duplicate name, save not created" then
		self.savingTextTimer = self.savingTextTimer + dt
		if self.savingTextTimer > 3 then 
			self.savingTextTimer = 0
			self.savingText = ""
		end
	end
end

function choosecharacter:setupSaving()
	self.saving = false
	self.savingText = ""
	self.savingTextTimer = 0
	self.save_name_button = TextBox:new(192, 312, 20, nil)
end