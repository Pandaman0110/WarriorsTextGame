Clan = class("Clan") -- creates a classs


function Clan:initialize()
	self.clan_image = num
	self.name = name
	--these should be instances of cats
	self.leader = leader
	self.deputy = deputy
	self.medicine_cat = medicine_cat

	--table of all the cats
	self.cats = {}
end

function Clan:draw(x, y, s)
	if not s then love.graphics.draw(ClanImages[self.clan_image], x, y) end
	if s then love.graphics.draw(ClanImages[self.clan_image], x, y, 0, s, s) end
end

--accessors
function Clan:getImage()
	return ClanImages[self.clan_image]
end

function Clan:getImageNum()
	return self.clan_image
end

function Clan:getName()
	return self.name
end

function Clan:getLeader()
	return self.leader
end

function Clan:getDeputy()
	return self.deputy
end

function Clan:getMedicineCat()
	return self.medicine_cat
end

function Clan:getNumWarriors()
	local num = 0
	for i, cat in pairs (self.cats) do
		if cat ~= nil then
			if cat:getRole() == "Warrior" then num = num + 1 end
		end
	end
	return num
end

function Clan:getWarriors()
	local warriors = {}
	table.insert(warriors, self.leader)
	table.insert(warriors, self.deputy)
	for i, cat in pairs (self.cats) do
		if cat:getRole() == "Warrior" then
			table.insert(warriors, cat)
		end
	end
	return warriors
end

function Clan:getNumApprentices()
	local num = 0
	for i, cat in pairs (self.cats) do
		if cat ~= nil then
			if cat:getRole() == "Apprentice" then num = num + 1 end
		end
	end
	return num
end

function Clan:getApprentices()
	local apprentices = {}
	for i, cat in pairs (self.cats) do
		if cat:getRole() == "Warrior" then
			table.insert(apprentices, cat)
		end
	end
	return apprentices
end

function Clan:getNumKits()
	local num = 0
	for i, cat in pairs (self.cats) do
		if cat ~= nil then
			if cat:getRole() == "Kit" then num = num + 1 end
		end
	end
	return num
end

function Clan:getKits()
	local kits = {}
	for i, cat in pairs (self.cats) do
		if cat:getRole() == "Kit" then
			table.insert(kits, cat)
		end
	end
	return kits
end

function Clan:getNumElders()
	local num = 0
	for i, cat in pairs (self.cats) do
		if cat ~= nil then
			if cat:getRole() == "Elder" then num = num + 1 end
		end
	end
	return num
end

function Clan:getElders()
	local elders = {}
	for i, cat in pairs (self.cats) do
		if cat:getRole() == "Elder" then
			table.insert(elders, cat)
		end
	end
	return elders
end

function Clan:getOther()
	local other = {}
	table.insert(other, self.medicine_cat)
	local elders = self:getElders()
	for i, cat in pairs (elders) do table.insert(other, cat) end
	return other 
end

function Clan:getCats()
	return self.cats
end

function Clan:getNumCats()
	return #self.cats
end

--mutators 
function Clan:setImage(num)
	self.clan_image = num 
end

function Clan:setName(name)
	self.name = name
end

function Clan:setLeader(leader)
	self.leader = leader
end

function Clan:setDeputy(deputy)
	self.deputy = deputy
end

function Clan:setMedicineCat(medicine_cat)
	self.medicine_cat = medicine_cat
end

function Clan:insertCat(cat)
	local c = cat
	local role = c:getRole()
	local found = 0
	if role == "Leader" then table.insert(self.cats, 1, c) end
	if role == "Deputy" then table.insert(self.cats, 2, c) end
	if role == "Medicine Cat" then table.insert(self.cats, 3, c) end
	if role == "Warrior" then table.insert(self.cats, 4, c) end
	if role == "Apprentice" then
		for i, _cat in pairs(self.cats) do
			if _cat:getRole() == "Warrior" then found = i end
		end
		if found == 0 then table.insert(self.cats, 4, c)
		else table.insert(self.cats, found+1, c)
		end
	end
	if role == "Kit" then
		for i, _cat in pairs(self.cats) do
			if _cat:getRole() == "Apprentice" then found = i end
		end
		if found == 0 then 
			for i, _cat in pairs(self.cats) do
				if _cat:getRole() == "Warrior" then found = i end
			end
		end
		if found == 0 then table.insert(self.cats, 4, c)
		else table.insert(self.cats, found+1, c)
		end
	end
	if role == "Elder" then
		for i, _cat in pairs(self.cats) do
			if _cat:getRole() == "Kit" then found = i end
		end
		if found == 0 then
			for i, _cat in pairs(self.cats) do
				if _cat:getRole() == "Apprentice" then found = i end
			end
			if found == 0 then
				for i, _cat in pairs(self.cats) do
					if _cat:getRole() == "Warrior" then found = i end
				end
			end
		end
		if found == 0 then table.insert(self.cats, 4, c)
		else table.insert(self.cats, found+1, c)
		end
	end
end

--grabs a random cat from the clan
--t is a table that contains the roles you dont want
--for example if u only want to choose from warriors you should pass {5}
function Clan:grabRandomCat(t)
	local cat
	local isRole
	if not t then cat = lume.randomchoice(self.cats) end
	if t then
		repeat
			cat = lume.randomchoice(self.cats)
			isRole = false
			for i, role in ipairs(t) do
				if cat:getRole() == role then isRole = true end
			end
		until (isRole == false)
	end
	return cat
end

function Clan:printDetails()
	print (self.name)
	print ("The leader is " .. self.leader:getName())
	print ("The deputy is " .. self.deputy:getName())
	print ("The medicine cat is " .. self.medicine_cat:getName())
	print ("There are " .. self:getNumWarriors() .. " warriors")
	print ("There are " .. self:getNumApprentices() .. " apprentices")
	print ("There are " .. self:getNumKits() .. " kits")
	print ("There are " .. self:getNumElders() .. " elders")
	print (" ")
end

function Clan:printMemberDetails()
	for i, cat in pairs(self.cats) do
		cat:printDetails()
	end
end