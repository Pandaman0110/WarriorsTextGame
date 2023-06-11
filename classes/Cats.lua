--This file contains the base class for all cats, "Cat"

local pairs, ipairs = pairs, ipairs

Animal = class("Animal")

function Animal:initialize()
	-- all this shit has to do with movement and stuff

	self.image = image

	self.controller = controller

	self.body = nil

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

	self.name = name
	self.gender = gender

	self.combatStrength = 1
	self.combatSpeed = 1
	self.attacking = false
	self.attackTimer = 1
	self.claws = "sheathed" -- sheathed / unsheathed

	--medical shit
	self.dead = false
	self.unconcious = false
	self.blood = 500
	self.bleedpulsetimer = 10
	--check if bleeding light == .2 , medium = .4, heavy = .5

	self.bleeding = 0
end

function Animal:getController()
	return self.controller
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

function Animal:isSheathed()
	if self.claws == 1 then return true elseif self.claws == 2 then return false end
end

function Animal:isDead()
	return self.dead 
end

function Animal:isUnconcious()
	return self.unconcious
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

function Animal:setBody(body)
	self.body = body
end

function Animal:setController(controller)
	self.controller = controller
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
	self.image = self.image + 1
end

function Animal:knockout()
	self.unconcious = true
	self.image = self.image + 1
end

function Animal:wake()
	self.unconcious = false
	self.image = self.image + 1
end

function Animal:setBlood(blood)
	self.blood = blood 
end

function Animal:setBleeding(speed)
	self.bleeding = speed 
end

function Animal:checkBleeding()
	return self.bleeding
end

function Animal:checkBlood()
	return self.blood
end

function Animal:setSpeed(speed) 
	self.speed = speed 
end

function Animal:switchClaws()
	if self.claws == "sheathed" then self.claws = "unsheathed"
	elseif self.claws == "unsheathed" then self.claws = "sheathed" 
	end
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



function Animal:update(dt, cathandler)  --just make sure to update the cats
	self:updatePosition(dt)

	if self.attacking == true then
		self.attackTimer = 1 / self.combatSpeed
		self.attackTimer = self.attackTimer - dt
		if self.attackTimer < 0 then 
			self.attackTimer = 1 / self.combatSpeed
			self.attacking = false 
		end
	end


	--update medical stuff

	self.blood = self.blood - self.bleeding * dt
	--both of these flags will be true be careful maybe 
	if self.blood <= 200 then self.unconcious = true end
	if self.blood <= 0 then self.dead = true end

	if self.bleeding > 0 then
		self.bleedpulsetimer = 10 * self.bleeding
		self.bleedpulsetimer = self.bleedpulsetimer - dt
		if self.bleedpulsetimer < 0 then
			self.bleedpulsetimer = 10 * self.bleeding
		end
	end


	--update controllers last
	self.controller:update(dt, cathandler)
end

function Animal:updatePosition(dt)
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
end

function Animal:setDirection(x, y, heading)  -- you probably have no reason to use this 
	if self.ismoving == false then
		self.ismoving = true 
		self:getInput(x, y, heading)
	end
end

function Animal:move(x, y)
	self.controller:setPath(x, y)
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

	--"help" and "combat"

	self.clan = clan
	self.role = role

	self.moons = moons
	self.eyecolor = eyecolor
	self.pelt = pelt

	self.dad = dad
	self.mom = mom
	self.kits = {}
	self.mate = mate
	self.mentor = mentor 
	self.apprentice = apprentice
	self.nursing = false


	self.is_player = false
end

function Cat:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	-- accessing cat images might be slowing this down
	--self.testcat:drawImage((self.testcat:getX()-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, (self.testcat:getY()-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
	love.graphics.draw(CatImages[self.image], (self.x - firstTile_x * 32) - offset_x - 16, (self.y - firstTile_y * 32) - offset_y - 16 - 8)
end

--[[
tile position is gotten by getTileX() or getTileY()
or getPos(). i know this doesnt make sense someone else can go in an fix it
]]--

--combat functions

--do the actual attack somewhere else probably

--do an event for the attack and the taking damage

function Cat:attack(cat, cathandler)
	if self:isSheathed() then 
		if self.is_player == true then return Message:new("claws sheathed", self, "Your claws are sheathed!", true) 
		elseif self.is_player == false then return Message:new("claws sheathed", self, self.name .. " tried to hit " .. cat:getName() .. " but their claws were sheathed!", true)
		end
	end

	--send the attack here ig
	local attack = {
		["Type"] = "swiped",
		["Bleed"] = .5
	}
	cat:takeHit(self, attack, cathandler)
	if self.is_player == true then return Message:new("attack", self, "You " .. attack["Type"] .. " " .. cat:getName() .."!", true)
	elseif self.is_player == false then return Message:new("attack", self, cat:getName() .. " was " .. attack["Type"] .. " by " .. self.name .."!", true)
	end
end

function Cat:tap(cat, cathandler)
	local tap = {
		["Type"] = "tapped"
	} 
	cat:takeHit(self, tap, cathandler)
	if self.is_player == true then return Message:new("tap", self, "You " .. tap["Type"] .. " " .. cat:getName() .."!", true)
	elseif self.is_player == false then return Message:new("tap", self, cat:getName() .. " was " .. tap["Type"] .. " by " .. self.name .."!", true)
	end
end

--check hit if damage < 0 print message basdew on damage
--this attack message

function Cat:takeHit(cat, hit, cathandler)
	if hit["Type"] == "swiped" then 
		self:setBleeding(hit["Bleed"])
	elseif hit["Type"] == "tapped" then

	end
	if self.is_player == true then return Message:new("took damage", self, "You were " .. hit["Type"] .. " by " .. cat:getName() .. "!", true)
	elseif self.is_player == false then return Message:new("took damage", self, self.name .. " was " .. hit["Type"] .. " by " .. cat:getName() .. "!", false)
	end
end

--cat is the animal you clicked on
function Cat:decide(cat, cathandler)
	local message = nil
	if self.intent == "help" then
		message = self:tap(cat, cathandler)
	elseif self.intent == "combat" then
		message = self:attack(cat, cathandler)
	end
	return message
end


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
	return self.is_player
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
	self.is_player = isplayer
end

--put the tile positon here
function Cat:setIntent(intent)
	self.intent = intent
end

function Cat:switchIntent()
	if self.intent == "help" then self.intent = "combat" 
	elseif self.intent == "combat" then self.intent = "help"
	end
end

function Cat:setRole(role)
	self.role = role
end

function Cat:setMoons(moons)
	self.moons = moons 
end

function Cat:setAppearence(eyecolor, pelt)
	self.eyecolor = eyecolor
	self.pelt = pelt 
end

function Cat:setEyecolor(eyecolor)
	self.eyecolor = eyecolor
end

function Cat:setPelt(pelt)
	self.pelt = pelt
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
	if self.mate then print("Mate: " .. self.mate:getName()) end
	if self.mentor then print("Mentor: " .. self.mentor:getName()) end
	if self.apprentice then print("Apprentice: " .. self.apprentice:getName()) end
	if self.dad then print("Dad: " .. self.dad:getName()) end
	if self.mom then print("Mom: " .. self.mom:getName()) end
	if self.nursing == true then print("Current Litter: ") CatHandler.printTableCatsNames(self.kits) end
	print("-------------------------")
end

function Cat:printName()
	print(self.name)
end

--prints the table of cats passed in
function printCatDetails(cats)
	for i, cat in pairs(cats) do
		cat:printDetails()
	end
end

function printCatNames(cats)
	for i, cat in pairs(cats) do
		cat:printName()
	end
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