--some sort of animalhandler to handle all the animals and shit ad check with collision and stuff

Handler = class("Handler")

function Handler:initialize(clock)
	self.clock = clock
	self.messages = Array:new()
end

function Handler:handleMessage(message)
	message:print()
	message:logTime(self.clock)
	self.messages:insert(message)
end

function Handler:readMessageAt(index)
	self.messages:at(index):printDetails()
end

function Handler:getMessage(index)
	return self.messages:at(index)
end



GameHandler = class("GameHandler", Handler)

function GameHandler:initialize(clock)
	Handler.initialize(self, clock)
	self.nodes = Map:new()
	self.nodes:insert("thunder_clan_base", GameNode:new(5, 6))
	self.nodes:insert("river_clan_base", GameNode:new(20, 6))
end

function GameHandler:update(dt)
	for key, node in self.nodes:iterator() do
		node:update(dt)
	end
end

function GameHandler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	for key, node in self.nodes:iterator() do
		node:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	end
end

function GameHandler:getNode(name)
	return self.nodes:at(name)
end

function GameHandler:sendCat()

end


--eventualy yoiu will need to havethis keep track of all the cats not just the ones in the clans

CatHandler = class("CatHandler", Handler)

function CatHandler:initialize(clock)
	Handler.initialize(self, clock)

	self.player = player
	self.cats = Array:new()
	self.relationships_handler = RelationshipHandler:new(self)
end

function CatHandler:insertCat(cat)
	self.relationships_handler:insertCat(cat)
	self.cats:insert(cat)
end

function CatHandler:iterator(index)
	return self.cats:iterator(index)
end

function CatHandler:loadCatsFromClan(clan)
	for cat in clan:getCats():iterator() do

		self:insertCat(cat)
		if cat:isPlayer() then self.player = cat end
	end
end

function CatHandler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	for cat in self.cats:iterator() do
		if cat ~= self.player then cat:draw(offset_x, offset_y, firstTile_x, firstTile_y) end
	end
end

function CatHandler:update(dt)
	for cat in self.cats:iterator() do
		cat:update(dt, self)
	end
end

function CatHandler:checkTile(x, y)
	for cat in self.cats:iterator() do
		if cat:getTileX() == x and cat:getTileY() == y then return cat end
	end
	return false
end


function CatHandler:findCat(name)
	for cat in self.cats:iterator() do
		if cat:getName() == name then return cat end
	end
end

function CatHandler:findPlayer()
	for cat in self.cats:iterator() do
		if cat:isPlayer() == true then return cat end
	end
end

function CatHandler:findNonPlayer()
	local cat = self.cats:randomChoice()
	while cat == self:findPlayer() do
		cat = self.cats:randomChoice()
	end
	return cat 
end

function CatHandler:getCatsWithKits()
	local cats = Array:new()
	for cat in self:iterator() do
		if cat:hasKits() then cats:insert(cat) end
	end
	return cats
end

function CatHandler:getCatsGender(gender)
	local cats = Array:new()
	for cat in self:iterator() do
		if cat:getGender() == gender then cats:insert(cat) end
	end
	return cats
end

function CatHandler:getCatsInClan(clan_name)
	local cats = Array:new()
	for cat in self:iterator() do 
		if cat:getClan():getName() == clan_name then cats:insert(cat) end
	end
end

function CatHandler:getCats()
	return self.cats
end

function CatHandler:getNumCats()
	return self.cats:size()
end


function CatHandler:randomCat()
	return lume.randomchoice(self.cats)
end

function CatHandler:printCatDetails()
	for cat in self.cats:iterator() do
		cat:printDetails()
	end
end

function CatHandler:printCatNames()
	for cat in self.cats:iterator() do
		cat:printName()
	end
end

function CatHandler:getRelationships()
	return self.relationships_handler
end


ClanHandler = class("ClanHandler", Handler)

function ClanHandler:initialize(clock)
	Handler.initialize(self, clock)

	self.clans = Array:new()
end

function ClanHandler:loadClans(clans)
	for clan in clans:iterator() do
		self.clans:insert(clan)
	end
end

function ClanHandler:randomClan()
	return self.clans:randomChoice()
end

function ClanHandler:iterator(index)
	return self.clans:iterator(index)
end

function ClanHandler:getNumClans()
	return self.clans:size()
end


Message = class("Message")

--for now we got attack and took damage
function Message:initialize(messagetype, sender, text, visible)
	self.type = messagetype
	self.sender = sender
	self.text = text
	self.visible = visible
	self.time = ""
end

function Message:print()
	if self.visible == true then print(self.text) end
end

function Message:printDetails()
	print("Sender: " .. self.sender)
	print("Type: " .. self.type)
	print("Time: " .. self.time)
	print("Text: " .. self.text)
end

function Message:type()
	return self.type
end

function Message:getSender()
	return self.sender
end

function Message:getText()
	return self.text
end

function Message:getTime()
	return self.time
end

--eventually add in the day and month and stuff
function Message:logTime(clock)
	self.time = clock:getGameTime()
end

GameNode = class("GameNode")

function GameNode:initialize(x, y)
	self.image = love.graphics.newImage("Images/node.png")
	self.x = x
	self.y = y
end

function GameNode:update(dt)
	local d = nil
end

function GameNode:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	love.graphics.draw(self.image, ((self.x-1) * 32 - firstTile_x * 32) - offset_x - 16, ((self.y-1) * 32 - firstTile_y * 32) - offset_y - 16 - 8)
end

function GameNode:getPos()
	return self.x, self.y
end