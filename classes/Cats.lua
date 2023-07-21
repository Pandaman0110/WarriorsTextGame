local pairs, ipairs = pairs, ipairs

local sqrt2 = math.sqrt(2)

Animal = class("Animal")


function Animal:initialize()
	self.image = image
	self.image_num = num

	self.controller = controller
	self.body = nil
	self.behavior_tree = behavior_tree

	--self.behavior = BehaviorTree:new(CatBehaviorTree, self)

	self.name = name
	self.gender = gender

	self.combatStrength = 1
	self.combatSpeed = 1
	self.attacking = false
	self.attackTimer = 1
	self.claws = "sheathed" -- sheathed / unsheathed
end

function Animal:getController()
	return self.controller
end

function Animal:getImage()
	return self.image
end

function Animal:isSheathed()
	if self.claws == 1 then return true elseif self.claws == 2 then return false end
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

function Animal:setBehavior(tree)
	self.behavior_tree = tree
end

function Animal:setController(controller)
	self.controller = controller
end

function Animal:setImage(num)
	self.image_num = num
	self.image = CatImages[self.image_num]
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
	if not s then love.graphics.draw(self.image, x + 2, y + 4) end
	if s then love.graphics.draw(self.image, x, y, 0, s, s) end
end

function Animal:update(dt, cathandler)  --just make sure to update the cats
	if self.behavior then self.behavior_tree:tick(dt) end
	self.controller:update(dt, cathandler)

	if self.attacking == true then
		self.attackTimer = 1 / self.combatSpeed
		self.attackTimer = self.attackTimer - dt
		if self.attackTimer < 0 then 
			self.attackTimer = 1 / self.combatSpeed
			self.attacking = false 
		end
	end

	--update controllers last
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

	self.dad = dad --move this to some sort of family tree thing
	self.mom = mom
	self.kits = Array:new()
	self.mate = mate
	self.mentor = mentor 
	self.apprentice = apprentice
	self.nursing = false

	self.is_real = true
	self.is_player = false
end

function Cat:isReal()
	return self.is_real()
end

function Cat:real(real)
	self.is_real = real
end

function Cat:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	-- accessing cat images might be slowing this down
	--self.testcat:drawImage((self.testcat:getX()-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, (self.testcat:getY()-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
	love.graphics.draw(self.image, (self.real_x - firstTile_x * 32) - offset_x - 16, (self.real_y - firstTile_y * 32) - offset_y - 16 - 8)
end

function Cat:setImage(num)
	self.image_num = num
	self.image = CatImages[self.image_num]
end

--combat functions

--do the actual attack somewhere else probably

--do an event for the attack and the taking damage

function Cat:attack(cat, cathandler)
	if self:isSheathed() then 
		Message:new("claws sheathed", self, self:getName() .. " tried to hit " .. cat:getName() .. " but their claws were sheathed!", true)
	end

	--send the attack here ig
	local attack = {
		["Type"] = "swiped",
		["Bleed"] = .5
	}
	cat:takeHit(self, attack, cathandler)
	return Message:new("attack", self, cat:getName() .. " was " .. attack["Type"] .. " by " .. self:getName() .."!", true)
end

function Cat:tap(cat, cathandler)
	local tap = {
		["Type"] = "tapped"
	} 
	cat:takeHit(self, tap, cathandler)
	Message:new("tap", self, cat:getName() .. " was " .. tap["Type"] .. " by " .. self:getName() .."!", true)
end

--check hit if damage < 0 print message basdew on damage
--this attack message

function Cat:takeHit(cat, hit, cathandler)
	if hit["Type"] == "swiped" then 
		self:setBleeding(hit["Bleed"])
	elseif hit["Type"] == "tapped" then

	end
	Message:new("took damage", self, self:getName() .. " was " .. hit["Type"] .. " by " .. cat:getName() .. "!", false)
end

--cat is the animal you clicked on
function Cat:decide(cat, cathandler)
	if cat == self then return nil end
	local message = nil
	if self.intent == "help" then
		message = self:tap(cat, cathandler)
	elseif self.intent == "combat" then
		message = self:attack(cat, cathandler)
	end
	return message
end


--accessors
function Cat:getName(format)
	if format then return (self.name .. " (you)") 
	else return self.name end
end

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

function Cat:setIsPlayer(is_player) 
	self.is_player = is_player
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
	for i, kit in kits:iterator() do
		self.kits:insert(kit)
	end
end

function Cat:setNursing(nursing)
	self.nursing = nursing 
end

-- other functions
function Cat:age()
	self.moons = self.moons + 1
end

function Cat:hasKits()
	if self.kits:isEmpty() then return false
	else return true end
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
	if self.nursing == true then print("Current Litter: ") printCatNames(self.kits) end
	print("-------------------------")
end

--prints the table of cats passed in
function printCatDetails(cats)
	for i, cat in cats:iterator() do
		cat:printDetails()
	end
end

function printCatNames(cats)
	for i, cat in cats:iterator() do
		cat:printName()
	end
end

function matchCats(t1, t2)
	local cats = Array:new()

	for i, cat_1 in t1:iterator() do
		if t2:contains(cat_1) then 
			cats:insert(cat_1)
		end
	end

	return cats 
end

function removeDuplicateCats(t1, t2)
	local cats = Array:new()

	for i, cat_1 in t1:iterator() do
		if not t2:contains(cat_1) then 
		 	cats:insert(cat_1)
		end
	end

	return cats
end