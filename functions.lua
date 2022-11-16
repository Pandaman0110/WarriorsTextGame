--generates a random cat
--role is optional, if set it will set the role to whatever
function genRandomCat(role)
	local cat = Cat:new()
	if not role then cat:setRole(randExRole()) end
	if role then cat:setRole(role) end
	cat:setName(genName(cat:getRole()))
	cat:setMoons(randMoons(cat:getRole()))
	cat:setHealth(genHealth(cat:getMoons()))
	cat:setGender(randGender())
	cat:setAppearence(randPelt(cat:getGender()), randEyecolor(), randFurlength())
	cat:setParents(genParent(), genParent())
	return cat
end

--generates a random name
--suffix is optional, if passed it will give the appropriate suffix
--reference the Prefixes and Suffixes tables in data.lua
function genName(suffix)
	local prefix = lume.randomchoice(Prefixes)
	local suffix
	suffix = lume.randomchoice(Suffixes)
	if suffix == "Leader" then
		suffix  = "star"
	elseif suffix == "Apprentice" then
		suffix = "paw"
	elseif suffix == "Kit" then
		suffix = "kit"
	elseif suffix == "Clan" then
		suffix = "clan"
	end
	local name = prefix .. suffix
	return name
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
		moons = lume.random(12, 36)
	elseif role == "Apprentice" then
		moons = lume.random(6, 12)
	elseif role == "Kit" then
		moons = lume.random(0, 6)
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
	while role == "Leader" or role == "Deputy" or role == "Medecine Cat" do
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
		parent = "Unknown"
	end
	if unknown == 0 then 
		parent = genName()
	end
	return parent 
end

function genClan(name)
	local clan = Clan:new()
	if not name then clan:setName(genName("Clan")) end
	if name then clan:setName(name) end
	clan:setLeader(genRandomCat("Leader"))
	clan:setDeputy(genRandomCat("Deputy"))
	clan:setMedecineCat(genRandomCat("Medecine Cat"))
	return clan
end
