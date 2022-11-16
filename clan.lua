Clan = class("Clan") -- creates a classs


function Clan:initialize()
	self.name = name

	--these should be instances of cats
	self.leader = leader
	self.deputy = deputy
	self.medecine_cat = medecine_cat

	--tables of cats
	self.senior_warriors = {}
	self.warriors = {}
	self.apprentices = {}
	self.kits = {}

	--table of all the cats
	self.cats = {self.leader, self.deputy, self.medecine_cat, self.senior_warriors, self.warriors, self.apprentices, self.kits}
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

function Clan:getSeniorWarriors()
	return self.senior_warriors
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

function Clan:printDetails()
	print ("The leader is " .. self.leader:getName())
	print ("The deputy is " .. self.deputy:getName())
	print ("The medecine cat is " .. self.medecine_cat:getName())
	print ("There are " .. #self.senior_warriors .. " Senior Warriors")
	print ("There are " .. #self.warriors .. " Warriors")
	print ("There are " .. #self.apprentices .. " Apprentices")
	print ("There are " .. #self.kits .. " Kits")
	print (" ")
end

function Clan:printMemberDetails()
	print("Nigger")
	for i, v in ipairs(self.cats) do
		v:printDetails()
	end
	self.leader:printDetails()
	print(type(self.cats[1]))
end