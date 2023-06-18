local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}

--[[
so this blackboard thing is supposed to be like a place you can post 
informationn apprently thats pretty cool I guess like other nodes can use it

]]


BehaviorTree = class("BehaviorTree")

function BehaviorTree:initialize(tree, agent)
	self.agent = agent
	self.blackboard = Array:new()
	self.root = tree[1][1]
	self:loadTree(tree, self.root)
end

-- sp i guess we want it to were we just call root:process()

function BehaviorTree:loadTree(tree, node)
	if #tree == 
	for i = 2, #tree do 
		node:addChild(self:loadTree(tree[1], node))
	end --tree[1] should be the root node
end
 
function BehaviorTree:tick(dt)
	--self.root:process(dt)
end

function BehaviorTree:printTree()
end


Node = class("Node")

function Node:initialize()
	--"success, running, failure"
	self.status = node_statuses.ready
		self.has_children = false
	self.init = false
end

function Node:process(dt)
	--check a condition or implemement an action here


	return self.status
end

function Node:getStatus()
	return self.status
end

function Node:hasChildren()
	return self.has_children
end

function Node:print()

end



-----




CompositeNode = class("CompositeNode", Node)

function CompositeNode:initialize(...)
	Node.initialize(self)
	self.has_children = true
	self.children = {}
	if ... then 
		for i, child_node in ipairs(...) do 
			self.children[i] = child_node
		end
	end
end

function CompositeNode:addChild(child_node)
	self.children[#self.children+1] = child_node
end

function CompositeNode:getChildren()

end

function CompositeNode:print()
	print(self)
	print("Number of child nodes: " .. #self.children)
end


--[[
Processes children until one returns success or running


]]


Selector = class("Selector", CompositeNode)

function Selector:initialize(...)
	CompositeNode.initialize(self, ...)
end

function Selector:process() 
	for name, child in ipairs(self.children) do
		self.status = child:process()
		if self.status == node_statuses.failure then goto continue
		elseif self.status == node_statuses.success then return self.status
		elseif self.status == node_statuses.running then return self.status
		end
		::continue::
	end
	self.status = node_statuses.failure
	return self.status
end



--[[
Processes children until one returns failure; if none return failure it 


]]



Sequence = class("Sequence", CompositeNode)

function Sequence:initialize(...)
	CompositeNode.initialize(self, ...)
end

function Sequence:process()
	local any_child_running = false
	for name, child in ipairs(self.children) do
		if not child:started() then child:start() end
		self.status = child:process()
		if self.status == node_statuses.failure then return self.status 
		elseif self.status == node_statuses.success then self.status = node_statuses.running; goto continue 
		elseif self.status == node_statuses.running then any_child_running = true; goto continue
		end
		::continue::
	end
	if any_child_running == true then self.status = node_statuses.running end
	return self.status
end







Decorator = class("Decorator", Node)

function Decorator:initialize()
	Node.initialize(self)
end






LeafNode = class("LeafNode", Node)

function LeafNode:initialize(agent)
	Node.initialize(self)
	self.agent = agent
	self.initialize = node_statuses.running
end

function LeafNode:started()
	return self.started
end

function LeafNode:init()
	-- do stuff for the for the first tick
	self.initialized = true
end

function LeafNode:process()
	--do shit
	return self.status
end

function LeafNode:getAgent()
	return self.agent
end

function LeafNode:setAgent(agent)
	self.agent = agent
end



Failure = class("Failure", LeafNode)

function Failure:initialize(agent)
	LeafNode.initialize(self, agent)
end

Success = class("Success", LeafNode)

function Success:initialize(agent)
	LeafNode.initialize(self, agent)
end

function Success:process()

end

Wait = class("Wait", LeafNode)













