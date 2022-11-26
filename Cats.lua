--This file contains the base class for all cats, "Cat",  and all subclasses, Leader, Deputy, Elder, Warrior, Apprentice, Kit, and Queen

Cat = class("Cat")

function Cat:initialize()
	--self.cat_image =  love.graphics.newImage("")
	self.name = name
	self.role = role
	self.gender = gender
	self.moons = moons
	self.health = health
	self.eyecolor = eyecolor
	self.pelt = pelt
	self.fur_length = fur_length
	self.dad = dad
	self.mom = mom
	self.kits = {}
	self.mate = mate
	self.mentor = mentor 
	self.apprentice = apprentice
end

--accessors
function Cat:getName()
	return self.name
end

function Cat:getRole()
	return self.role
end

function Cat:getHealth()
	return self.health
end

function Cat:getGender()
	return self.gender 
end

function Cat:getMoons()
	return self.moons
end

function Cat:getAppearence()
	return self.eyecolor, self.pelt, self.fur_length
end

function Cat:getDad()
	return self.dad
end

function Cat:getMom()
	return self.mom 
end

function Cat:getParents()
	return self.mom, self.dad
end

function Cat:getMate()
	return self.mate
end

function Cat:getMentor()
	return self.mentor
end

function Cat:getApprentice()
	return self.mentor
end

function Cat:getKits()
	return self.kits
end

--mutators
function Cat:setName(name)
	self.name = name 
end

function Cat:setRole(role)
	self.role = role
end

function Cat:setHealth(health)
	self.health = health
end

function Cat:setGender(gender)
	self.gender = gender 
end

function Cat:setMoons(moons)
	self.moons = moons 
end

function Cat:setAppearence(eyecolor, pelt, fur_length)
	self.eyecolor = eyecolor
	self.pelt = pelt 
	self.fur_length = fur_length
end

function Cat:setDad(dad)
	self.dad = dad 
end

function Cat:setMom(mom)
	self.mom = mom
end

function Cat:setParents(mom, dad)
	self.mom = mom
	self.dad = dad
end

function Cat:setMate(mate)
	self.mate = mate
end

function Cat:setMentor(mentor)
	self.mentor = mentor 
end

function Cat:setApprentice(apprentice)
	self.apprentice = apprentice
end

function Cat:setKits(kits)
	self.kits = kits
end

-- other functions
function Cat:printDetails()
	print("Name: " .. self.name)
	print("Role: " .. self.role)
	print("Gender: " .. self.gender)
	print("Moons: " .. self.moons)
	print("Health: " .. self.health)
	print("Eyecolor: " .. self.eyecolor)
	print("Pelt: " .. self.pelt)
	print("Fur Length: " .. self.fur_length)
	if self.mate then print("Mate: " .. self.mate:getName()) end
	if self.mentor then print("Mentor: " .. self.mentor:getName()) end
	if self.apprentice then print("Apprentice: " .. self.apprentice:getName()) end
	if self.dad then print("Dad: " .. self.dad:getName()) end
	if self.mom then print("Mom: " .. self.mom:getName()) end
	if lume.isarray(self.kits) then print("Kits") printTableCats(self.kits, "names") end
	print(" ")
end

