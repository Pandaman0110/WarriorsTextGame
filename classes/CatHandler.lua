CatHandler = class("CatHandler", Handler)

function CatHandler:initialize(clock)
	Handler.initialize(self, clock)

	self.player = player
	self.cats = Array:new()
	self.relationships_handler = RelationshipHandler:new(self)
end

function CatHandler:insertCat(cat)
	self.cats:insert(cat)
	self.relationships_handler:insertCat(cat)
end

function CatHandler:iterator(index)
	return self.cats:iterator(index)
end

function CatHandler:loadCatsFromClan(clan)
	for i, cat in clan:getCats():iterator() do
		self:insertCat(cat)
		if cat:isPlayer() then 
			self.player = cat
		end
	end
end

function CatHandler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	for i, cat in self.cats:iterator() do
		if cat ~= self.player then cat:draw(offset_x, offset_y, firstTile_x, firstTile_y) end
	end
end

function CatHandler:update(dt)
	for i, cat in self.cats:iterator() do
		cat:update(dt, self)
	end
end

function CatHandler:checkTile(x, y)
	for i,cat in self.cats:iterator() do
		local coords_1 = cat:getGamePos()
		if coords_1[1] == x and coords_1[2] == y then return cat end
	end
	return false
end


function CatHandler:getRandomCat(name)
	for i, cat in self.cats:iterator() do
		if cat:getName() == name then return cat end
	end
end

function CatHandler:getPlayer()
	for i, cat in self.cats:iterator() do
		if cat:isPlayer() == true then return cat end
	end
end

function CatHandler:getRandomNonPlayer()
	local cat = self.cats:randomChoice()
	while cat == self:getPlayer() do
		cat = self.cats:randomChoice()
	end
	return cat 
end

function CatHandler:getCatsWithKits()
	local cats = Array:new()
	for i, cat in self.cats:iterator() do
		if cat:hasKits() then cats:insert(cat) end
	end
	return cats
end

function CatHandler:getCatsGender(gender)
	local cats = Array:new()
	for i, cat in self.cats:iterator() do
		if cat:getGender() == gender then cats:insert(cat) end
	end
	return cats
end

function CatHandler:getCatsInClan(clan_name)
	local cats = Array:new()
	for i, cat in self.cats:iterator() do 
		if cat:getClan():getName() == clan_name then cats:insert(cat) end
	end
end

function CatHandler:getCats()
	return self.cats
end

function CatHandler:getPlayer() 
	return self.player 
end

function CatHandler:getNumCats() 
	return self.cats:size() 
end

function CatHandler:randomCat() 
	return lume.randomchoice(self.cats) 
end

function CatHandler:printCatDetails()
	for i, cat in self.cats:iterator() do
		cat:printDetails()
	end
end

function CatHandler:printCatNames()
	for i, cat in self.cats:iterator() do
		cat:printName()
	end
end

function CatHandler:getRelationships() 
	return self.relationships_handler 
end