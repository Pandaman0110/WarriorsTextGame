--generates a random cat
--role is optional, if set it will set the role to whatever
--rec is stop stack overflow from infinite recursion, dont touch it unless you know what that means
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
	end
	if name then 
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
	for i = 1, lume.round(lume.random(4, 12)) do
		clan:insertCat(genRandomCat("Warrior"))
	end
	for i = 1, lume.round(lume.random(2, 4)) do
		local apprentice = genRandomCat("Apprentice")
		apprenticeCat(apprentice, clan:grabRandomCat({"Medicine Cat", "Leader", "Apprentice", "Kit"}))
		clan:insertCat(apprentice)
	end
	for i = 1, lume.round(lume.random(1, 2)) do
		local mom = clan:grabRandomCat({"Medicine Cat", "Apprentice", "Kit"})
		local dad = clan:grabRandomCat({"Medicine Cat", "Apprentice", "Kit"})
		while mom:getGender() ~= "Female" or mom:hasKits() do mom = clan:grabRandomCat({"Medicine Cat", "Apprentice", "Kit"}) end
		while dad:getGender() ~= "Male" or dad:hasKits() do dad = clan:grabRandomCat({"Medicine Cat", "Apprentice", "Kit"}) end
		local kits = genKits(mom, dad)
		for i, cat in ipairs (kits) do
			clan:insertCat(cat)
		end
	end
	for i = 1, lume.round(lume.random(1, 2)) do
		clan:insertCat(genRandomCat("Elder"))
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
		moons = lume.random(49, 120)
	elseif role == "Deputy" then
		moons = lume.random(49, 120)
	elseif role == "Medicine Cat" then
		moons = lume.random(49, 120)
	elseif role == "Warrior" then
		moons = lume.random(13, 120)
	elseif role == "Apprentice" then
		moons = lume.random(6, 12)
	elseif role == "Kit" then
		moons = lume.random(0, 5)
	elseif role == "Elder" then
		moons = lume.random (121, 180)
	else moons = lume.random (49, 120)
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
	local pelt = math.floor(lume.random(1,3.99))
	return pelt
end

--generates a random eyecolor
--refernece Eyecolors table in data.lua
function randEyecolor()
	local eyecolor = math.floor(lume.random(1,3.99))
	return eyecolor
end

--generates a random furlength
--reference Furlengths table in data.lua
function randFurlength()
	local fur_length = math.floor(lume.random(1,3.99))
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
	for i = 1, lume.weightedchoice({[1] = 1, [2] = 2, [3] = 2}) do
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

