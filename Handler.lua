--some sort of animalhandler to handle all the animals and shit ad check with collision and stuff

CatHandler = class("CatHandler")

function CatHandler:initialize(clans)
	self.clans = clans
	self.cats = {}
	self:updateCats()
end

function CatHandler:updateCats()
	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			table.insert(self.cats, cat)
		end
	end
end

function CatHandler:getCats()
	return self.cats
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

function CatHandler:randomCat()
	return lume.randomchoice(self.cats)
end

function CatHandler:update(dt)
	for i, cat in ipairs(self.cats) do
		cat:update(dt, self)
	end
end

MessageHandler = class("MessageHandler")

function MessageHandler:initialize()
	self.message_queue = Queue:new()
end

function MessageHandler:update(dt)

end

function MessageHandler:clearMessages()
	self.message_queue:empty()
end

function MessageHandler:printMessage(message)
	message:print()
end

