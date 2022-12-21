Clan = class("Clan") -- creates a classs


function Clan:initialize()
	self.name = name

	--these should be instances of cats
	self.leader = leader
	self.deputy = deputy
	self.medecine_cat = medecine_cat

	--tables of cats
	self.warriors = {}
	self.apprentices = {}
	self.kits = {}

	--table of all the cats
	self.cats = {}
end

--accessors
function Clan:getName()
	return self.name
end

function Clan:getLeader()
	return self.leader
end

function Clan:getDeputy()
	return self.deputy
end

function Clan:getMedecineCat()
	return self.medecine_cat
end

function Clan:getWarriors()
	return self.warriors
end

function Clan:getApprentices()
	return self.apprentices
end

function Clan:getKits()
	return self.kits
end

function Clan:getCats()
	return self.cats
end

--mutators 
function Clan:setName(name)
	self.name = name
end

function Clan:setLeader(leader)
	self.leader = leader
end

function Clan:setDeputy(deputy)
	self.deputy = deputy
end

function Clan:setMedecineCat(medecine_cat)
	self.medecine_cat = medecine_cat
end

function Clan:insertWarrior(cat)
	table.insert(self.warriors, cat)
end

function Clan:insertApprentice(cat)
	table.insert(self.apprentices, cat)
end

function Clan:insertKit(cat)
	table.insert(self.kits, cat)
end

function Clan:updateCats()
	table.insert(self.cats, self.leader)
	table.insert(self.cats, self.deputy)
	table.insert(self.cats, self.medecine_cat)
	for i, cat in ipairs(self.warriors) do
		table.insert(self.cats, cat)
	end
	for i, cat in ipairs(self.apprentices) do
		table.insert(self.cats, cat)
	end
	for i, cat in ipairs(self.kits) do
		table.insert(self.cats, cat)
	end
end

--grabs a random cat from the clan
--t is a table that contains indexs to cats you want
--for example if u only want to choose from warriors you should pass {5}
function Clan:grabRandomCat(t)
	local cat
	local index
	if not t then index = lume.round(lume.random(1, 7)) end
	if t then index = lume.randomchoice(t) end
	if index <= 3 then
		cat = self.cats[index]
	elseif index >= 4 then
		cat = lume.randomchoice(self.cats[index])
	end
	return cat
end

function Clan:printDetails()
	print (self.name)
	print ("The leader is " .. self.leader:getName())
	print ("The deputy is " .. self.deputy:getName())
	print ("The medicine cat is " .. self.medecine_cat:getName())
	print ("There are " .. #self.warriors .. " warriors")
	print ("There are " .. #self.apprentices .. " apprentices")
	print ("There are " .. #self.kits .. " kits")
	print (" ")
end

function Clan:printMemberDetails()
	for i = 1, 3 do self.cats[i]:printDetails() end
	for i = 3, 6 do 
		printTableCats(self.cats[i])
	end
end