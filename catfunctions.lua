--choose a whole number from a to b inclusive
local function random(a, b)
	local num = math.floor(lume.random(a, b+.9999))
	return num
end

--generates a random cat
--role is optional
--rec is stop stack overflow

function genRandomCat(role, rec)
	local cat = Cat:new()
	if not role then cat:setRole(randExRole()) end
	if role then cat:setRole(role) end
	cat:setName(genName(cat:getRole()))
	cat:setMoons(randMoons(cat:getRole()))
	cat:setGender(randGender())
	cat:setPelt(randPelt(cat:getGender()))
	cat:setEyecolor(randEyecolor())
	cat:setFurlength(randFurlength())
	cat:setImage(cat:getPeltNum())

	if not rec then cat:setParents(genParent(), genParent()) end
	return cat
end

--generates a random clan
function genClan(name)
	local clan = Clan:new()
	local usedNames = {}

	if not name then 
		clan:setName(genName("Clan")) 
		clan:setImage(lume.round(lume.random(1, 4)))
	else 
		if name == "Thunder" then clan:setImage(1) end
		if name == "River" then clan:setImage(2) end
		if name == "Wind" then clan:setImage(3) end
		if name == "Shadow" then clan:setImage(4) end
		clan:setName(genName("Clan", name))
	end

	clan:setLeader(genRandomCat("Leader"))
	clan:setDeputy(genRandomCat("Deputy"))
	clan:setMedicineCat(genRandomCat("Medicine Cat"))

	clan:insertCat(clan:getLeader())
	clan:insertCat(clan:getDeputy())
	clan:insertCat(clan:getMedicineCat())

	for i = 1, random(4, 8) do
		clan:insertCat(genRandomCat("Warrior"))
	end

	for i = 1, random(2, 4) do
		local apprentice = genRandomCat("Apprentice")
		apprenticeCat(apprentice, clan:getRandomRole({"Warrior", "Deputy"}))
		clan:insertCat(apprentice)
	end

	for i = 1, lume.random(1, 2) do
		if clan:findParentsKits() == false then break end
		local mom, dad = clan:findParentsKits()

		local kits = genKits(mom, dad)
		for i, cat in ipairs (kits) do
			clan:insertCat(cat)
		end
	end

	for i = 1, random(1, 3) do
		clan:insertCat(genRandomCat("Elder"))
	end

	for i, cat in ipairs(clan:getCats()) do
		cat:setClan(clan)
	end

	return clan
end


--generates a random name
--reference the Prefixes and Suffixes tables in data.lua
function genName(role, name)
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

	local _name
	if prefix[#prefix] == suffix[1] then
		_name = prefix .. "-" .. suffix
	else
		_name = prefix .. suffix
	end

	return _name
end

--generates a random age based on the role of the cat
function randMoons(role)
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
function randRole() 
	local role = lume.randomchoice(Roles)
	return role
end

--generates a role ex
function randExRole()
	local role = lume.randomchoice(Roles)
	while role == "Leader" or role == "Deputy" or role == "Medicine Cat" do
		role = lume.randomchoice(Roles)
	end
	return role
end

--chooses a random gender between male and female
function randGender()
	local gender = {"Male", "Female"}
	local catGender = lume.randomchoice(gender)
	return catGender
end

--generates a random pelt
--gender is required if u want correct pelts
function randPelt(gender)
	local pelt = random(1, 3)
	return pelt
end

--generates a random eyecolor
--refernece Eyecolors table in data.lua
function randEyecolor()
	local eyecolor = random(1, 3)
	return eyecolor
end

--generates a random furlength
--reference Furlengths table in data.lua
function randFurlength()
	local fur_length = random(1, 3)
	return fur_length
end

--generates a random parent
--between Unknown and a random name
function genParent()
	local parent
	local unknown = random(0, 1)
	if unknown == 1 then
		parent = genRandomCat("cum", true)
		parent:setName("Unknown")
	end
	if unknown == 0 then 
		parent = genRandomCat("cum", true)	
	end
	return parent 
end

--prints the table of cats passed in
function printTableCats(table)
	for i, cat in ipairs(table) do
		cat:printDetails()
	end
end

function printTableCatsNames(table)
	for i, cat in ipairs(table) do
		cat:printName()
	end
end

function mateCats(mom, dad)
	mom:setMate(dad)
	dad:setMate(mom)
end

function apprenticeCat(apprentice, mentor)
	apprentice:setMentor(mentor)
	mentor:setApprentice(apprentice)
end

--generates a litter of cats for two cats
--pass the actual mom and dad cat objects in
function genKits(mom, dad)
	local kits = {}
	local moons = randMoons("Kit")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = genRandomCat("Kit")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		table.insert(kits, cat)
	end
	mom:setKits(kits)
	mom:setNursing(true)
	dad:setKits(kits)
	if mom:getMate() ~= dad then mateCats(mom, dad) end
	return kits
end

function genWarriors(mom, dad)
	local warriors = {}
	local moons = randMoons("Warrior")
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 1}) do
		local cat = genRandomCat("Warrior")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		table.insert(warriors, cat)
	end
	mom:setKits(warriors)
	dad:setKits(warriors)
	if mom:getMate() ~= dad then mateCats(mom, dad) end
	return warriors
end 

--t1 is a table of cats
--t2 is a table of tables of cat
--creates a new table between the two with only cats in both tables
function checkDuplicateCats(t1, t2)
	local dupe = false
	local cats = {}

	for i, cat1 in ipairs(t1) do
		for k, cat2 in ipairs(t2) do
			if cat1 == cat2 then dupe = true end
		end
		if dupe == true then table.insert(cats, cat1) end
		dupe = false
	end

	return cats 
end

--removes any cats in the second table from the first, returns a new table

function removeDuplicateCats(t1, t2)
	local dupe = false
	local cats = {}

	for i, cat1 in ipairs(t1) do
		for k, cat2 in ipairs(t2) do
			if cat1 == cat2 then dupe = true end 
		end
		if dupe ~= true then table.insert(cats, cat1) end
		dupe = false
	end

	return cats
end