
local love_max = 100
local love_min = 0

RelationshipHandler = class("RelationshipHandler")

function RelationshipHandler:initialize(CatHandler)
	self.cat_handler = CatHandler
	self.relationships_graph = Graph:new(500)
end

function RelationshipHandler:newRelationship(cat_1, cat_2)
	local cat_1_name, cat_2_name = cat_1:getName(), cat_2:getName()
	self.relationships_graph:addEdge(cat_1_name, cat_2_name, Relationship:new(cat_1, cat_2))
	self.relationships_graph:addEdge(cat_2_name, cat_1_name, Relationship:new(cat_2, cat_1))
end

function RelationshipHandler:insertCat(new_cat)
	if self:getCats():size() > 2 then 
		for cat in self:getCats():range(1, self:getNumCats()) do
			self:newRelationship(new_cat, cat)
		end
	else return true end
end

function RelationshipHandler:printRelationshipDetails(cat_1, cat_2)
	local cat_1_name, cat_2_name = cat_1:getName(), cat_2:getName()
	self.relationships_graph:getEdge(cat_1, cat_2):printRelationshipDetails()
end

function RelationshipHandler:getRelationship(cat_1, cat_2)
	local cat_1_name, cat_2_name = cat_1:getName(), cat_2:getName()
	return self.relationships_graph:getEdge(cat_1, cat_2)
end

function RelationshipHandler:getCatRelationships(cat)
	return self.relationships_graph:touching(cat:getName())
end

function RelationshipHandler:printCatRelationships(cat)
	for relationship in self:getCatRelationships(cat):iterator() do
		relationship:printRelationshipDetails()
	end
end

function RelationshipHandler:printAllCatRelationships(cat)
	for cat in self:getCats():iterator() do
		self:printCatRelationships(cat)
	end
end

function RelationshipHandler:getCats()
	return self.cat_handler:getCats()
end

function RelationshipHandler:getNumCats()
	return self.cat_handler:getNumCats()
end

Relationship = class("Relationship")

function Relationship:initialize(cat_1, cat_2)
	self.cat_1 = cat_1
	self.cat_2 = cat_2
	self.love = love_min
end

function Relationship:getLove()
	return self.love 
end

function Relationship:printRelationshipDetails()
	print(self.cat_1:getName() .. " relationship towards " .. self.cat_2:getName())
	print(self.love.." no love")
end