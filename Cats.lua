--This file contains the base class for all cats, "Cat"

local pairs, ipairs = pairs, ipairs

Animal = class("Animal")

function Animal:initialize()
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

	self.image = image
	self.name = name
	self.gender = gender

	self.combatStrength = 1
	self.combatSpeed = 1
	self.attacking = false
	self.attackTimer = 1
	self.claws = 1 -- sheathed / unsheated

	--medical shit
	self.dead = false
	self.blood = 100
	--check if bleeding light == .2 , medium = .4, heavy = .5

	self.bleeding = 0
end

function Animal:getX()
	return self.x 
end

function Animal:getY()
	return self.y 
end

function Animal:getTileX()
	return self.tileX 
end

function Animal:getTileY()
	return self.tileY 
end

function Animal:getDestX()
	return self.destX
end

function Animal:getDestY()
	return self.destX
end

function Animal:getPos()
	return self.tileX, self.tileY 
end

function Animal:getPixelPos()
	return self.x, self.y
end

function Animal:getMoveTimer()
	return self.movetimer
end

function Animal:isMoving()
	return self.ismoving
end

function Animal:getDest()
	return self.destX, self.destY 
end

function Animal:getImage()
	return CatImages[self.image]
end

function Animal:getImageNum()
	return self.image
end

function Animal:getDirection()
	return self.direction 
end

function Animal:getIsDead()
	return self.dead 
end

function Animal:getBlood()
	return self.blood 
end

function Animal:getBleeding()
	return self.bleeding 
end

function Animal:getSpeed() 
	return self.speed
end

function Animal:getClaws()
	return self.claws 
end

function Animal:getIsAttacking()
	return self.attacking 
end

function Animal:getName()
	return self.name 
end

function Animal:getGender()
	return self.gender 
end

function Animal:setPos(x, y)
	self.tileX = x 
	self.tileY = y
	self.x = self.tileX * 32 - 32
	self.y = self.tileY * 32 - 32
end

function Animal:setPixelPos(x, y)
	self.x = x 
	self.y = y 
end

function Animal:setDest(x, y)
	self.destX = x
	self.destY = y
end

function Animal:setIsMoving(bool)
	self.ismoving = bool
end

function Animal:setMoveTimer(movetimer)
	self.movetimer = self.movetimer
end

function Animal:setX(x)
	self.x = x 
end

function Animal:setY(y)
	self.y = y 
end

function Animal:setTileX(x)
	self.tileX = x
end

function Animal:setTileY(y)
	self.tileY = y
end

function Animal:setImage(num)
	self.image = num
end

function Animal:setImageEVIL(image)
	self.image = image 
end

function Animal:setDirection(direction)
	self.direction = direction 
end

function Animal:kill()
	self.dead = true 
end

function Animal:setBlood(blood)
	self.blood = blood 
end

function Animal:setBleeding(speed)
	self.bleeding = speed 
end

function Animal:setSpeed(speed) 
	self.speed = speed 
end

function Animal:switchClaws(claws)
	if self.claws == 1 then self.claws = 2
	elseif self.claws == 2 then self.claws = 1 end
end

function Animal:setName(name)
	self.name = name
end

function Animal:setGender(gender)
	self.gender = gender 
end

function Animal:drawImage(x, y, s)
	if not s then love.graphics.draw(CatImages[self.image], x + 2, y + 4) end
	if s then love.graphics.draw(CatImages[self.image], x, y, 0, s, s) end
end

function Animal:update(dt)  --just make sure to update the cats
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

	if self.attacking == true then 
		self.attackTimer = self.attackTimer - dt
		if self.attackTimer < 0 then 
			self.attackTimer = 1 / self.combatSpeed
			self.attacking = false 
		end
	end

	self.blood = self.blood - self.bleeding * dt
end

function Animal:draw()
end

function Animal:move(x, y, heading)  -- you probably have no reason to use this 
	if self.ismoving == false then
		self.ismoving = true 
		self:getInput(x, y, heading)
	end
end

function Animal:getInput(x, y, heading) -- or this
	self.prevX = self.tileX * 32 - 32
	self.prevY = self.tileY * 32 - 32
	self.tileX = self.tileX + x 
	self.tileY = self.tileY + y
	self.destX = self.tileX * 32 - 32
	self.destY = self.tileY * 32 - 32
	self.direction = heading
end

Cat = class("Cat", Animal)

function Cat:initialize()
	Animal.initialize(self)

	self.intent = "help" -- help/combat for now

	self.clan = clan
	self.role = role

	self.moons = moons
	self.eyecolor = eyecolor
	self.pelt = pelt
	self.fur_length = fur_length

	self.dad = dad
	self.mom = mom
	self.kits = {}
	self.mate = mate
	self.mentor = mentor 
	self.apprentice = apprentice
	self.nursing = false


	self._isPlayer = false
end

--[[
tile position is gotten by getTileX() or getTileY()
or getPos(). i know this doesnt make sense someone else can go in an fix it
]]--


--accessors
function Cat:isNursing()
	return self.nursing 
end

function Cat:getClan()
	return self.clan 
end

function Cat:getIntent()
	return self.intent 
end

function Cat:isPlayer()
	return self._isPlayer
end

function Cat:getRole()
	return self.role
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
	return Furlengths[self.fur_length]
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
function Cat:setClan(clan)
	self.clan = clan
end

function Cat:setIsPlayer(isplayer) 
	self._isPlayer = isplayer
end

--put the tile positon here
function Cat:setIntent(intent)
	self.intent = intent
end

function Cat:setRole(role)
	self.role = role
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

function Cat:setNursing(nursing)
	self.nursing = nursing 
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
	print("Eyecolor: " .. self:getEyecolor())
	print("Pelt: " .. self:getPelt())
	print("Fur Length: " .. self:getFurlength())
	if self.mate then print("Mate: " .. self.mate:getName()) end
	if self.mentor then print("Mentor: " .. self.mentor:getName()) end
	if self.apprentice then print("Apprentice: " .. self.apprentice:getName()) end
	if self.dad then print("Dad: " .. self.dad:getName()) end
	if self.mom then print("Mom: " .. self.mom:getName()) end
	if self.nursing == true then print("Current Litter: ") printTableCatsNames(self.kits) end
	print("-------------------------")
end

function Cat:printName()
	print(self.name)
end

function Cat:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	-- accessing cat images might be slowing this down
	--self.testcat:drawImage((self.testcat:getX()-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, (self.testcat:getY()-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
	love.graphics.draw(CatImages[self.image], (self.x - firstTile_x * 32) - offset_x - 16, (self.y - firstTile_y * 32) - offset_y - 16 - 8)
end