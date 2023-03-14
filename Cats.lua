--This file contains the base class for all cats, "Cat"

Cat = class("Cat")

function Cat:initialize()
	-- all this shit has to do with movement and stuff
	self.tileX = 2
	self.tileY = 2
	self.x = self.tileX*32 - 32 --this is so it draws in the correct places, lua arrays start at 1 or something
	self.y = self.tileX*32 - 32
	self.prevX = 0
	self.prevY = 0
	self.destX = 0
	self.destY = 0
	self.speed = .5 --you can just play with this
	self.movetimer = 0 -- this is used to control how fast the cat moves in conjuction with the speed
	self.t = 0 --this is used for doing the movement animation
	self.ismoving = false --self explanatory
	self.direction = "south" --not sure what the fuck im gonna use this for yet

	self.cat_image = cat_image
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
	self._isPlayer = false

	--medical shit
	self.blood = 100
	--check if bleeding light == .2 , medium = .4, heavy = .5

	self.bleeding = .2
end

function Cat:drawImage(x, y, s)
	if not s then love.graphics.draw(CatImages[self.cat_image], x + 2, y + 4) end
	if s then love.graphics.draw(CatImages[self.cat_image], x, y, 0, s, s) end
end

function Cat:draw()
	love.graphics.draw(CatImages[self.cat_image], self.x + 2, self.y + 4)
end

--[[
tile position is gotten by getTileX() or getTileY()
or getPos(). i know this doesnt make sense someone else can go in an fix it
]]--


--accessors
function Cat:getBlood()
	return self.blood 
end

function Cat:getBleeding()
	return self.bleeding 
end

function Cat:getSpeed() 
	return self.speed
end

function Cat:isPlayer()
	return self._isPlayer
end

function Cat:getX()
	return self.x 
end

function Cat:getY()
	return self.y 
end

function Cat:getTileX()
	return self.tileX 
end

function Cat:getTileY()
	return self.tileY 
end

function Cat:getDestX()
	return self.destX
end

function Cat:getDestY()
	return self.destX
end

function Cat:getPos()
	return self.tileX, self.tileY 
end

function Cat:getPixelPos()
	return self.x, self.y
end

function Cat:getMoveTimer()
	return self.movetimer
end

function Cat:isMoving()
	return self.ismoving
end

function Cat:getDest()
	return self.destX, self.destY 
end

function Cat:getImage()
	return CatImages[self.cat_image]
end

function Cat:getImageNum()
	return self.cat_image
end

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

function Cat:getEyecolor()
	return Eyecolors[self.eyecolor]
end

function Cat:getPelt()
	return Pelts[self.pelt]
end

function Cat:getPeltNum()
	return self.pelt 
end

function Cat:getFurlength()
	return FurLengths[self.fur_length]
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

function Cat:getDirection()
	return self.direction 
end

--mutators
function Cat:setBlood(blood)
	self.blood = blood 
end

function Cat:setBleeding(speed)
	self.bleeding = speed 
end

function Cat:setSpeed(speed) 
	self.speed = speed 
end

function Cat:setIsPlayer(isplayer) 
	self._isPlayer = isplayer
end

function Cat:setX(x)
	self.x = x 
end

function Cat:setY(y)
	self.y = y 
end

--put the tile positon here
function Cat:setPos(x, y)
	self.tileX = x 
	self.tileY = y 
end

function Cat:setPixelPos(x, y)
	self.x = x 
	self.y = y 
end

function Cat:setDest(x, y)
	self.destX = x
	self.destY = y
end

function Cat:setIsMoving(bool)
	self.ismoving = bool
end

function Cat:setMoveTimer(movetimer)
	self.movetimer = self.movetimer
end

function Cat:setTileX(x)
	self.tileX = x
end

function Cat:setTileY(y)
	self.tileY = y
end

function Cat:setImage(num)
	self.cat_image = num
end

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

function Cat:setEyecolor(eyecolor)
	self.eyecolor = eyecolor
end

function Cat:setPelt(pelt)
	self.pelt = pelt
end

function Cat:setFurlength(fur_length)
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

function Cat:setDirection(direction)
	self.direction = direction 
end

-- other functions
function Cat:age()
	self.moons = self.moons + 1
end

function Cat:hasKits()
	local hasKits
	if next(self.kits) == nil then
		hasKits = false
	else hasKits = true end
	return hasKits
end

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

function Cat:moveCat(x, y, heading)  -- you probably have no reason to use this 
	if self.ismoving == false then
		self.ismoving = true 
		self:getInput(x, y, heading)
	end
end

function Cat:getInput(x, y, heading) -- or this
	self.prevX = self.tileX * 32 - 32
	self.prevY = self.tileY * 32 - 32
	self.tileX = self.tileX + x 
	self.tileY = self.tileY + y
	self.destX = self.tileX * 32 - 32
	self.destY = self.tileY * 32 - 32
	self.direction = heading
end

function Cat:update(dt)  --just make sure to update the cats
	local direction = self.direction
	local rate_of_change = 32 / (16 * self.speed)  --all this shit is just dealing with the animations and stuff like that.

	if self.ismoving == true then
		self.movetimer = self.movetimer + dt

		self.t = self.t + (rate_of_change * dt)
		if self.t >= 1 then self.t = 1 end

		self.x = self.prevX + (self.destX - self.prevX) * self.t
		self.y = self.prevY + (self.destY - self.prevY) * self.t

		if self.movetimer > 1 * self.speed then
			self.ismoving = false
			self.movetimer = 0
			self.t = 0
		end
	end

	self.blood = self.blood - self.bleeding * dt
end