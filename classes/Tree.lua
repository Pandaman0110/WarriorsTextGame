local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}


BehaviorTree = class("BehaviorTree")

function BehaviorTree:initialize(tree, agent)
	self.agent = agent
	self.tree = self:loadTree(tree, agent)
end

-- sp i guess we want it to were we just call root:process()

function BehaviorTree:loadTree(tree, agent)

end
 
function BehaviorTree:tick(dt)
	self.tree.root:process(dt, agent)
end





Node = class("Node")

function Node:initialize()
	--"success, running, failure"
	self.status = node_statuses.ready

	self.init = false
end

function Node:process() 
	--check a condition or implemement an action here


	return self.status
end

function Node:getStatus()
	return self.status
end
-----






CompositeNode = class("CompositeNode", Node)

function CompositeNode:initialize(...)
	Node.initialize(self)

	self.num_children = 0

	if ... then 
		for name, child_node in pairs(...) do
			self.children[name] = child_node
			self.num_children = self.num_children + 1
		end
	end

	assert(self.num_children > 0, "must have at least one child")
end

function CompositeNode:addChild(name, child_node)
	self.children[name] = child_node
	self.num_children = self.num_children + 1
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
	self.started = node_statuses.running
end

function LeafNode:started()
	return self.started
end

function LeafNode:start()
	-- do stuff for the for the first tick
	self.started = true
end

function LeafNode:process()
	--do shit
	return self.status
end



Failure = class("Failure", LeafNode)

function Failure:initialize()
	LeafNode.initialize(self)
end

Success = class("Success", LeafNode)

function Success:initialize()
	LeafNode.initialize(self)
end

function Success:process()

end

Wait = class("Wait", LeafNode)














