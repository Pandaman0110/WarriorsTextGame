BehaviorTree = class("BehaviorTree")

function BehaviorTree:initialize(tree, agent, cat_handler, game_handler, clock)
	self.cat_handler = cat_handler
	self.game_handler = game_handler
	self.clock = clock

	self.agent = agent

	self.blackboard = Blackboard:new()

	self.root = nil
	self:loadTree(tree[1], nil)
end

function BehaviorTree:loadTree(tree, parent_node)
	local tree = tree
	local child_node = tree[1]:new()

	if self.root == nil then 
		self.root = child_node
		parent_node = child_node
	else
	  	parent_node:addChild(child_node)
	end

	if child_node:hasChildren() then 
		for i = 2, #tree do
			self:loadTree(tree[i], child_node)
		end
	else 
		child_node:addCatHandler(self.cat_handler)
		child_node:addGameHandler(self.game_handler)
		child_node:setAgent(self.agent)
		for i = 2, #tree do
			local node = tree[i]:new()

			tree[i]:addCatHandler(self.cat_handler)
			tree[i]:addGameHandler(self.cat_handler)
			tree[i]:setAgent(self.agent)

			parent_node:addChild(tree[i]:new())

		end
	end
end

function BehaviorTree:tick(dt)
	self.blackboard:update(dt)
	self.root:tick(dt, self.blackboard)
	self.root:deactivate()
end

function BehaviorTree:printTree()
	self.root:print()
end

function BehaviorTree:getRoot()
	return self.root
end

function BehaviorTree:getBlackboard()
	return self.blackboard
end



Blackboard = class("Blackboard")

function Blackboard:initialize(tree)
	self.time = 0
	self.map = Map:new()
end

function Blackboard:update(dt)
	self.time = self.time + dt
end

function Blackboard:post(name, info)
	local post = {info, self.time}
	self.map:insert(name, post)
end

function Blackboard:delete(name)
	self.map:insert(name, nil)
end

function Blackboard:clear()
	self.map:empty()
end

function Blackboard:getInfo(name)
	return self.map:at(name)[1]
end