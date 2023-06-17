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

	clan:setLeader(self:genRandomClanCat("Leader"))

	clan:setDeputy(self:genRandomClanCat("Deputy"))
	clan:setMedicineCat(self:genRandomClanCat("Medicine Cat"))

	clan:insertCat(clan:getLeader())
	clan:insertCat(clan:getDeputy())
	clan:insertCat(clan:getMedicineCat())

	for i = 1, random(4, 8) do
		clan:insertCat(self:genRandomClanCat("Warrior"))
	end

	for i = 1, random(2, 4) do
		local apprentice = self:genRandomClanCat("Apprentice")
		self:apprenticeCat(apprentice, clan:getCatsRole({"Warrior", "Deputy"}):randomChoice())
		clan:insertCat(apprentice)
	end

	for i = 1, lume.random(1, 2) do
		if clan:findParentsKits() == false then break end

		local mom, dad = clan:findParentsKits()
		

		local kits = self:genKits(mom, dad)
		for i, cat in ipairs(kits) do
			clan:insertCat(cat)
		end
	end



	for i = 1, random(1, 3) do
		clan:insertCat(self:genRandomClanCat("Elder"))
	end

	for cat in clan:getCats():iterator() do 
		cat:setClan(clan)
	end

	return clan
end

--TODO get rid of this parents thing, and create the family tree sepertely. start
-- at the top so you dont have to generate any parent and life is easy

function CatGenerator:genRandomClanCat(role, parents)
	local cat = Cat:new()

	if not role then cat:setRole(self:randExRole()) end
	if role then cat:setRole(role) end
	cat:setName(self:genName(cat:getRole()))
	cat:setMoons(self:randMoons(cat:getRole()))
	cat:setGender(self:randGender())
	cat:setPelt(self:randPelt())
	cat:setEyecolor(self:randEyecolor())
	cat:setImage((cat:getPeltNum() * 2) - 1)

	if not parents then 
		cat:setParents(self:genParent(), self:genParent()) 
		self.generated_cats:insert(cat)
		cat:setBody(CatBody:new(cat))
	end
	return cat
end

function CatGenerator:genName(role, name)
	local prefix = self:choosePrefix(name)
	local suffix = self:chooseSuffix(role)

	local final_name = prefix .. suffix

	if prefix[#prefix] == suffix[1] then final_name = prefix .. "-" .. suffix end

	while self:checkDuplicateName(final_name) do
		final_name = self:genName(role, name)
	end

	return final_name
end

function CatGenerator:checkDuplicateName(name)
	for cat in self.generated_cats:iterator() do 
		if cat:getName() == name then 

			return true
		end
	end
	return false
end

function CatGenerator:choosePrefix(name)
	local prefix = ""
	if name then prefix = name else prefix = lume.randomchoice(Prefixes) end
	return prefix 
end

function CatGenerator:chooseSuffix(role)
	local suffix = ""
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

	return suffix
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
		parent = self:genRandomClanCat("cum", true)
		parent:setName("Unknown")
	end
	if unknown == 0 then 
		parent = self:genRandomClanCat("cum", true)	
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
	local kits = Array:new()
	local moons = self:randMoons("Kit")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = self:genRandomClanCat("Kit")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		kits:insert(cat)
	end
	mom:setKits(kits)
	mom:setNursing(true)
	dad:setKits(kits)
	if mom:getMate() ~= dad then self:mateCats(mom, dad) end
	return kits
end

function CatGenerator:genWarriors(mom, dad)
	local warriors = Array:new()
	local moons = self:randMoons("Warrior")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = self:genRandomClanCat("Warrior")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		warriors:insert(cat)
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

function CatGenerator:getCats()
	return self.generated_cats
end