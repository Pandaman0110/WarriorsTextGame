
local love_max = 100
local love_min = 0

RelationshipHandler = class("RelationshipHandler")

function RelationshipHandler:initialize()
	self.relationships_graph = Graph:new()
end


function RelationshipHandler:newRelationship(cat_1_name, cat_2_name)
	self.relationships_graph:addVertexPair(cat_1_name, cat_2_name)
	self.relationships_graph:addEdge(cat_1_name, cat_2_name, Relationship:new(cat_1, cat_2))
end

function RelationshipHandler:printRelationshipDetails(cat_1, cat_2)
	self.relationships_graph:getEdge(cat_1, cat_2):printRelationshipDetails()
end

function RelationshipHandler:getRelationship(cat_1, cat_2)
	self.relationships_graph:getEdge(cat_1, cat_2)
end

Relationship = class("Relationship")

function Relationship:initialize(cat_1, cat_2)
	self.love = love_min
end

function Relationship:getLove()
	return self.love 
end

function Relationship:printRelationshipDetails()
	print(self.love.." no love")
end