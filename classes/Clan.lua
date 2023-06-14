Clan = class("Clan") -- creates a classs


function Clan:initialize()
	self.clan_image = num
	self.name = name
	--these should be instances of cats
	self.leader = leader
	self.deputy = deputy
	self.medicine_cat = medicine_cat

	--table of all the cats
	self.cats = Array:new()
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
	for cat in self.cats:iterator() do
		if cat ~= nil then
			if cat:getRole() == "Warrior" then num = num + 1 end
		end
	end
	return num
end

function Clan:getWarriors()
	local warriors = Array:new()
	warriors:insert(self.leader)
	warriors:insert(self.deputy)

	for cat in self.cats:iterator() do
		if cat:getRole() == "Warrior" then
			warriors:insert(cat)
		end
	end
	return warriors
end

function Clan:getNumApprentices()
	return self:getApprentices():size()
end

function Clan:getApprentices()
	local apprentices = Array:new()
	for cat in self.cats:iterator() do
		if cat:getRole() == "Warrior" then
			apprentices:insert(cat)
		end
	end
	return apprentices
end

function Clan:getNumKits()
	return self:getKits():size()
end

function Clan:getKits()
	local kits = Array:new()
	for cat in self.cats:iterator() do
		if cat:getRole() == "Kit" then
			kits:insert(cat)
		end
	end
	return kits
end

function Clan:getNumElders()
	return self:getElders():size()
end

function Clan:getElders()
	local elders = Array:new()
	for cat in self.cats:iterator() do
		if cat:getRole() == "Elder" then
			elders:insert(cat)
		end
	end
	return elders
end

function Clan:getCats()
	return self.cats
end

function Clan:iterator(index)
	return self.cats:iterator(index)
end

function Clan:getNumCats()
	return self.cats:size()
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

function Clan:getCatsRole(...)
	for i, role in pairs(...) do
		assert(Roles:contains(role), "invalid role: " .. role)
	end
	local cats = Array:new()
	for cat in self.cats:iterator() do
		for i, role in pairs(...) do
			if cat:getRole() == role then cats:insert(cat) end
		end
	end
	return cats
end

function Clan:printNumRole(...)
	for i, role in pairs(...) do
		assert(Roles:contains(role), "invalid role: " .. role)

		local num_cats = 0
		for cat in self.cats:iterator() do
			if cat:getRole() == role then num_cats = num_cats + 1 end
		end

		print("There are " .. num_cats .. " " .. role .. " in " .. self.name)
	end
end

function Clan:getNumRole(...)
	local num_cats_for_role = Array:new()

	for i, role in pairs(...) do
		assert(Roles:contains(role), "invalid role: " .. role)

		local num_cats = 0
		for cat in self.cats:iterator() do
			if cat:getRole() == role then num_cats = num_cats + 1 end
		end

		num_cats_for_role:insert(num_cats)

	end
	return num_cats_for_role
end

function Clan:insertCat(cat)
	local cat_role = cat:getRole()

	--turn role into numeric value and calculate
	local offset = 0

	for role in Roles:iterator() do
		if cat_role == role then
			for num in self:getNumRole(Roles:getRange(1, Roles:find(role))):iterator() do
				offset = offset + num
			end
		end
	end

	self.cats:insert(cat, offset+1)
end

function Clan:getCatsRandom()
	return self.cats:randomChoice()
end

--false return basically means no suitable parents

function Clan:findParentsKits()
	local females = matchCats(self:getCatsGender("Female"), self:getCatsRole({"Leader", "Deputy", "Warrior"}))
	local males = matchCats(self:getCatsGender("Male"), self:getCatsRole({"Leader", "Deputy", "Warrior"}))

	females = removeDuplicateCats(females, self:getCatsWithKits())
	males = removeDuplicateCats(males, self:getCatsWithKits())

	if females:isEmpty() or males:isEmpty() then return false end

	local mom = females:randomChoice()
	local dad = males:randomChoice()

	return mom, dad
end

function Clan:getCats()
	return self.cats
end

function Clan:getCatsGender(gender)
	local cats = Array:new()
	for cat in self.cats:iterator() do
		if cat:getGender() == gender then cats:insert(cat) end
	end
	return cats
end

function Clan:getCatsWithKits()
	local cats = Array:new()
	for cat in self.cats:iterator() do
		if cat:hasKits() then cats:insert(cat) end
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