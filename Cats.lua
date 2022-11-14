--This file contains the base class for all cats, "Cat",  and all subclasses, Leader, Deputy, Elder, Warrior, Apprentice, Kit, and Queen


local Cat = class('Cat')

function Cat:initialize(name, health, gender, moons, eyecolor, pelt, fur_length, dad, mom)
	self.name = name
	self.health = 20
	self.gender = gender
	self.moons = moons
	self.eyecolor = eyecolor
	self.pelt = pelt
	self.fur_length = fur_length
	self.dad = dad 
	self.mom = mom
end
