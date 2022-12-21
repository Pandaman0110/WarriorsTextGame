--generates a random cat
--role is optional, if set it will set the role to whatever
--rec is stop stack overflow from infinite recursion, dont touch it unless you know what that means
function genRandomCat(role, rec)
	local cat = Cat:new()
	if not role then cat:setRole(randExRole()) end
	if role then cat:setRole(role) end
	cat:setName(genName(cat:getRole()))
	cat:setMoons(randMoons(cat:getRole()))
	cat:setHealth(genHealth(cat:getMoons()))
	cat:setGender(randGender())
	cat:setAppearence(randPelt(cat:getGender()), randEyecolor(), randFurlength())
	if not rec then cat:setParents(genParent(), genParent()) end
	return cat
end

--generates a random clan
function genClan(name)
	local clan = Clan:new()
	local usedNames = {}
	if not name then clan:setName(genName("Clan")) end
	if name then clan:setName(genName("Clan", name)) end
	clan:setLeader(genRandomCat("Leader"))
	clan:setDeputy(genRandomCat("Deputy"))
	clan:setMedecineCat(genRandomCat("Medicine Cat"))
	for i = 1, lume.round(lume.random(2, 4)) do
		clan:insertSeniorWarrior(genRandomCat("Senior Warrior"))
	end
	for i = 1, lume.round(lume.random(4, 8)) do
		clan:insertWarrior(genRandomCat("Warrior"))
	end
	for i = 1, lume.round(lume.random(2, 4)) do
		local apprentice = genRandomCat("Apprentice")
		apprenticeCat(apprentice, clan:grabRandomCat({2, 4, 5}))
		clan:insertApprentice(apprentice)
	end
	for i = 1, lume.round(lume.random(1, 2)) do
		local mom = clan:grabRandomCat({1, 2, 4, 5})
		local dad = clan:grabRandomCat({1, 2, 4, 5})
		while mom:getGender() ~= "Female" or mom:hasKits() do mom = clan:grabRandomCat({1, 2, 4, 5}) end
		while dad:getGender() ~= "Male" or dad:hasKits() do dad = clan:grabRandomCat({1, 2, 4, 5}) end
		local kits = genKits(mom, dad)
		for i, v in ipairs (kits) do
			clan:insertKit(v)
		end
	end
	return clan
end


--generates a random name
--suffix is optional, if passed it will give the appropriate suffix
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
	local _name = prefix .. suffix
	return _name
end

--moon is required, generates a random health value based on the age of the cat
function genHealth(moons)
	local health
	if moons >= 0 and moons < 6 then
		health = lume.random(1, 5)
	end
	if moons >= 6 then
		health = lume.random(10, 20)
	end
	return lume.round(health)
end

--generates a random age based on the role of the cat
function randMoons(role)
	local moons
	if role == "Warrior" then
		moons = lume.random(13, 36)
	elseif role == "Apprentice" then
		moons = lume.random(6, 12)
	elseif role == "Kit" then
		moons = lume.random(0, 5)
	else
		moons = lume.random(36, 180)
	end

	return lume.round(moons)
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
	local pelt = lume.randomchoice(Pelts)
	if gender == "male" then
		while pelt == "White tortieshell" do
			pelt = lume.randomchoice(Pelts)
		end
	end
	return pelt
end

--generates a random eyecolor
--refernece Eyecolors table in data.lua
function randEyecolor()
	local eyecolor = lume.randomchoice(Eyecolors)
	return eyecolor
end

--generates a random furlength
--reference Furlengths table in data.lua
function randFurlength()
	local fur_length = lume.randomchoice(Furlengths)
	return fur_length
end

--generates a random parent
--between Unknown and a random name
function genParent()
	local parent
	local unknown = lume.round(lume.random(0, 1))
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
function printTableCats(table, names)
	for i, v in ipairs(table) do
		if not names then v:printDetails() end
		if names then print(v:getName()) end
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
	for i = 1, lume.round(lume.weightedchoice({[1] = 1, [2] = 2, [3] = 2})) do
		local cat = genRandomCat("Kit")
		cat:setParents(mom, dad)
		cat:setMoons(moons)
		table.insert(kits, cat)
	end
	mom:setKits(kits)
	dad:setKits(kits)
	if mom:getMate() ~= dad then mateCats(mom, dad) end
	return kits
end


