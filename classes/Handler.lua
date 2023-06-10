--some sort of animalhandler to handle all the animals and shit ad check with collision and stuff

CatHandler = class("CatHandler")

function CatHandler:initialize(clans, clock)
	self.clock = clock

	self.clans = clans

	self.player = player
	self.cats = Array:new()
	self.cat_messages = Array:new()

	self:loadCats()
end

function CatHandler:loadCats()
	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			self.cats:insert(cat)
			if cat:isPlayer() then self.player = cat end
		end
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

function CatHandler:getCats()
	return self.cats
end

function CatHandler:getNumCats()
	return self.cats:size()
end

function CatHandler:randomCat()
	return lume.randomchoice(self.cats)
end

function CatHandler:iterator(index)
	return self.cats:iterator(index)
end

--prints the table of cats passed in
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







function CatHandler:handleMessage(message)
	message:print()
	message:logTime(self.clock)
	self.cat_messages:insert(message)
end

function CatHandler:readMessageAt(index)
	self.cat_messages:at(index):printDetails()
end

function CatHandler:getMessage(index)
	return self.cat_messages:at(index)
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

