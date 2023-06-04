--some sort of animalhandler to handle all the animals and shit ad check with collision and stuff

CatHandler = class("CatHandler")

function CatHandler:initialize(clans, clock)
	self.clock = clock
	self.clans = clans
	self.cats = {}
	self.cat_messages = Stack:new()
	self:updateCats()
end

function CatHandler:updateCats()
	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			table.insert(self.cats, cat)
		end
	end
end

function CatHandler:update(dt)
	for i, cat in ipairs(self.cats) do
		cat:update(dt, self)
	end
end

function CatHandler:readMessage(message)
	message:print()
	self.cat_messages:push(message)
end

function CatHandler:checkTile(x, y)
	for i, cat in ipairs(self.cats) do
		if cat:getTileX() == x and cat:getTileY() == y then return cat end
	end
	return false
end

function CatHandler:findCat(name)
	for i, cat in ipairs(self.cats) do
		if cat:getName() == name then return cat end
	end
end

function CatHandler:findPlayer()
	for i, cat in ipairs(self.cats) do
		if cat:isPlayer() == true then return cat end
	end
end

function CatHandler:getCats()
	return self.cats
end

function CatHandler:randomCat()
	return lume.randomchoice(self.cats)
end

Message = class("Message")

--for now we got attack and took damage
function Message:initialize(messagetype, sender, text, visible)
	self.type = messagetype
	self.sender = sender
	self.text = text
	self.visible = visible
	self.time = time
end

function Message:print()
	if self.visible == true then print(self.text) end
end

function Message:printDetails()
	print("Sender: " .. self.sender)
	print("Type: " .. self.type)
	print("Time" .. self.time)
	print("Text:" .. self.text)
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
