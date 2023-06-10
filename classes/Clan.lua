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
	if self.leader then num = num + 1 end
	if self.deputy then num = num + 1 end
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

function Clan:getCatsRandom()
	local cat = lume.randomchoice(self.cats)
	return cat
end

--false return basically means no suitable parents

function Clan:findParentsKits()
	local females = checkDuplicateCats(self:getCatsGender("Female"), self:getCatsRole({"Leader", "Deputy", "Warrior"}))
	local males = checkDuplicateCats(self:getCatsGender("Male"), self:getCatsRole({"Leader", "Deputy", "Warrior"}))
	females = removeDuplicateCats(females, self:getCatsHasKits())
	males = removeDuplicateCats(males, self:getCatsHasKits())

	if isEmpty(females) or isEmpty(males) then return false end

	local mom = lume.randomchoice(females)
	local dad = lume.randomchoice(males)

	return mom, dad
end

function Clan:findParents()

end

--returns all the cats of a certain gender in the clan

function Clan:getCatsGender(gender)
	local cats = {}
	for i, cat in ipairs(self.cats) do
		if cat:getGender() == gender then table.insert(cats, cat) end
	end
	return cats
end

--returns all the cats with the given roles

function Clan:getCatsRole(t)
	local cats = {}
	local roles = t
	for i, cat in ipairs(self.cats) do 
		for i, role in ipairs(roles) do
			if cat:getRole() == role then table.insert(cats, cat) end
		end
	end
	return cats
end

function Clan:getRandomRole(t)
	local cat = lume.randomchoice(self:getCatsRole(t))
	return cat
end

function Clan:getRandomGender(gender)
	local cat = lume.randomchoice(self:getCatsGender(genderg))
	return cat
end

function Clan:getCatsHasKits()
	local cats = {}
	for i, cat in ipairs(self.cats) do
		if cat:hasKits() then table.insert(cats, cat) end
	end
	return cats
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
	print("-------------------------")
end

function Clan:printMemberDetails()
	for i, cat in pairs(self.cats) do
		cat:printDetails()
	end
	print("-------------------------")
end