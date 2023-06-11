--generates a random cat
--role is optional


--rec is stop stack overflow
--fnd a better soltoion than this stupid fucking parameter

CatGenerator = class("CatGenerator")

function CatGenerator:initialize()
	self.generated_clans = Array:new()
	self.generated_cats = Array:new()
end

function CatGenerator:genClan(name)
	self.generated_clans:insert(Clan:new())
	local clan = self.generated_clans:peek()

	local usedNames = {}

	if not name then 
		clan:setName(self:genName("Clan")) 
		clan:setImage(lume.round(lume.random(1, 4)))
	else 
		if name == "Thunder" then clan:setImage(1) end
		if name == "River" then clan:setImage(2) end
		if name == "Wind" then clan:setImage(3) end
		if name == "Shadow" then clan:setImage(4) end
		clan:setName(self:genName("Clan", name))
	end

	clan:setLeader(self:genRandomCat("Leader"))
	clan:setDeputy(self:genRandomCat("Deputy"))
	clan:setMedicineCat(self:genRandomCat("Medicine Cat"))

	clan:insertCat(clan:getLeader())
	clan:insertCat(clan:getDeputy())
	clan:insertCat(clan:getMedicineCat())

	for i = 1, random(4, 8) do
		clan:insertCat(self:genRandomCat("Warrior"))
	end

	for i = 1, random(2, 4) do
		local apprentice = self:genRandomCat("Apprentice")
		self:apprenticeCat(apprentice, clan:getRandomRole({"Warrior", "Deputy"}))
		clan:insertCat(apprentice)
	end

	for i = 1, lume.random(1, 2) do
		if clan:findParentsKits() == false then break end
		local mom, dad = clan:findParentsKits()

		local kits = self:genKits(mom, dad)
		for i, cat in ipairs (kits) do
			clan:insertCat(cat)
		end
	end

	for i = 1, random(1, 3) do
		clan:insertCat(self:genRandomCat("Elder"))
	end

	for i, cat in ipairs(clan:getCats()) do
		cat:setClan(clan)
	end

	return clan
end

function CatGenerator:genRandomCat(role, rec)
	self.generated_cats:insert(Cat:new())
	local cat = self.generated_cats:peek()

	if not role then cat:setRole(self:randExRole()) end
	if role then cat:setRole(role) end
	cat:setName(self:genName(cat:getRole()))
	cat:setMoons(self:randMoons(cat:getRole()))
	cat:setGender(self:randGender())
	cat:setPelt(self:randPelt())
	cat:setEyecolor(self:randEyecolor())
	cat:setImage((cat:getPeltNum() * 2) - 1)

	if not rec then cat:setParents(self:genParent(), self:genParent()) end

	cat:setBody(CatBody:new(cat))

	return cat
end

function CatGenerator:genName(role, name)
	local prefix
	if not name then prefix = lume.randomchoice(Prefixes) end
	if name then prefix = name end

	local suffix
	if role == "Leader" then
		suffix  = "star"
	elseif role == "Apprentice" then
		suffix = "paw"
	elseif role == "Kit" then
		suffix = "kit"
	elseif role == "Clan" then
		suffix = "Clan"
	else 
		suffix = lume.randomchoice(Suffixes)
	end

	local final_name = ""

	if prefix[#prefix] == suffix[1] then
		final_name = prefix .. "-" .. suffix
	else
		final_name = prefix .. suffix
	end

	for cat in self:getGeneratedCatsIterator() do
		if cat:getName() == final_name then 
			if name then self:genName(role, name)
			elseif not name then self:genName(role) end
		end
	end

	return final_name
end

--generates a random name
--reference the Prefixes and Suffixes tables in data.lua

--generates a random age based on the role of the cat
function CatGenerator:randMoons(role)
	local moons
	if role == "Leader" then
		moons = random(36, 96)
	elseif role == "Deputy" then
		moons = random(36, 96)
	elseif role == "Medicine Cat" then
		moons = random(24, 96)
	elseif role == "Warrior" then
		moons = random(12, 96)
	elseif role == "Apprentice" then
		moons = random(6, 12)
	elseif role == "Kit" then
		moons = random(0, 5)
	elseif role == "Elder" then
		moons = random(88, 120)
	else moons = random(36, 120)
	end
	return moons
end

--generates a random role, reference the Roles table in data.lua
function CatGenerator:randRole() 
	local role = lume.randomchoice(Roles)
	return role
end

--generates a role ex
function CatGenerator:randExRole()
	local role = lume.randomchoice(Roles)
	while role == "Leader" or role == "Deputy" or role == "Medicine Cat" do
		role = lume.randomchoice(Roles)
	end
	return role
end

--chooses a random gender between male and female
function CatGenerator:randGender()
	local gender = {"Male", "Female"}
	local catGender = lume.randomchoice(gender)
	return catGender
end

function CatGenerator:randPelt()
	local pelt = random(1, #Pelts)

	
	return pelt
end

function CatGenerator:randEyecolor()
	local eyecolor = random(1, 3)
	return eyecolor
end

function CatGenerator:genParent()
	local parent
	local unknown = random(0, 1)
	if unknown == 1 then
		parent = self:genRandomCat("cum", true)
		parent:setName("Unknown")
	end
	if unknown == 0 then 
		parent = self:genRandomCat("cum", true)	
	end
	return parent 
end

function CatGenerator:mateCats(mom, dad)
	mom:setMate(dad)
	dad:setMate(mom)
end

function CatGenerator:apprenticeCat(apprentice, mentor)
	apprentice:setMentor(mentor)
	mentor:setApprentice(apprentice)
end

--generates a litter of cats for two cats
--pass the actual mom and dad cat objects in
function CatGenerator:genKits(mom, dad)
	local kits = {}
	local moons = self:randMoons("Kit")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = self:genRandomCat("Kit")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		table.insert(kits, cat)
	end
	mom:setKits(kits)
	mom:setNursing(true)
	dad:setKits(kits)
	if mom:getMate() ~= dad then self:mateCats(mom, dad) end
	return kits
end

function CatGenerator:genWarriors(mom, dad)
	local warriors = {}
	local moons = self:randMoons("Warrior")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = self:genRandomCat("Warrior")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		table.insert(warriors, cat)
	end
	mom:setKits(warriors)
	dad:setKits(warriors)
	if mom:getMate() ~= dad then mateCats(mom, dad) end
	return warriors
end 

function CatGenerator:getGeneratedClansIterator(index)
	return self.generated_clans:iterator(index)
end

function CatGenerator:getGeneratedCatsIterator(index)
	return self.generated_cats:iterator(index)
end

function CatGenerator:printGeneratedClans()
 	for clan in self.generated_clans:iterator() do
 		print(clan:getName())
 	end
end

function CatGenerator:printGeneratedCats()
 	for cat in self.generated_cats:iterator() do
 		print(cat:getName())
 	end
end