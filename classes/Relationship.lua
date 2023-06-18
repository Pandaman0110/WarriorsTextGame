
local love_max = 100
local love_min = 0

--[[
Relationships handled from cat_1 --> cat_2 so read it like "how cat_1 feels towards cat_2" :)


]]


RelationshipHandler = class("RelationshipHandler")

function RelationshipHandler:initialize(CatHandler)
	self.cat_handler = CatHandler
	self.relationships_graph = Graph:new(500)
end

function RelationshipHandler:newRelationship(cat_1, cat_2)
	--local cat_1_name, cat_2_name = cat_1:getName(), cat_2:getName()
	self.relationships_graph:addEdge(cat_1, cat_2, Relationship:new(cat_1, cat_2))
	self.relationships_graph:addEdge(cat_2, cat_1, Relationship:new(cat_2, cat_1))
end

function RelationshipHandler:insertCat(new_cat)
	for i, cat in self.cat_handler:iterator() do
		if new_cat ~= cat then self:newRelationship(new_cat, cat) end
	end
end

function RelationshipHandler:printRelationshipDetails(cat_1, cat_2)
	self.relationships_graph:getEdge(cat_1, cat_2):printDetails()
end

function RelationshipHandler:getRelationship(cat_1, cat_2)
	return self.relationships_graph:getEdge(cat_1, cat_2)
end
	
function RelationshipHandler:getCatRelationships(cat)
	print(self.relationships_graph:touching(cat))
	--return self.relationships_graph:touching(cat)
end

function RelationshipHandler:printCatRelationships(cat)
	print(cat)
	for i, relationship in self.relationships_graph:touching(cat):iterator() do
		print(i, relationship)
		relationship:printDetails()
	end
end


function RelationshipHandler:getGraph()
	return self.relationships_graph
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

function Relationship:printDetails()
	print(self.cat_1:getName() .. " relationship towards " .. self.cat_2:getName())
	print(self.love.." no love")
end