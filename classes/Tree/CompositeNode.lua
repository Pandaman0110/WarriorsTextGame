local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}

CompositeNode = class("CompositeNode", Node)

function CompositeNode:initialize()
	Node.initialize(self)
	self.has_children = true
	self.children = {}
end

function CompositeNode:activate(blackboard) self.status = node_statuses.running end

function CompositeNode:deactivate(blackboard)
	if self.children then 
		for i, child in ipairs(self.children) do
			child:deactivate()
		end
	end
	self.status = node_statuses.ready 
end

function CompositeNode:addChild(child_node)
	self.children[#self.children+1] = child_node
end

function CompositeNode:getChildren()
	return self.children
end

function CompositeNode:hasChildren()
	return true
end

function CompositeNode:numChildren()
	return #self.children
end

function CompositeNode:getStatus()
	return self.status
end

Sequence = class("Sequence", CompositeNode)

function Sequence:initialize(...)
	CompositeNode.initialize(self, ...)
	self.status = node_statuses.ready
	self.current_child_num = 1
end

function Sequence:activate(blackboard) self.status = node_statuses.running end


--gets called once every frame

function Sequence:deactivate(blackboard) 
	if self.children then 
		for i, child in ipairs(self.children) do
			child:deactivate()
		end
	end
	self.status = node_statuses.ready 
end

function Sequence:tick(dt, blackboard)
	local any_child_running = false

	for i = self.current_child_num, #self.children do
		local child = self.children[i]
		local child_status = child:getStatus()

		if child_status == node_statuses.ready then
			child:activate(blackboard)
		end
		self.status = child:tick(dt, blackboard)

		if self.status == node_statuses.success then 
			goto continue
		elseif self.status == node_statuses.failure then 
			return self.status
		elseif self.status == node_statuses.running then 
			return self.status
		end
		::continue::
	end
	if any_child_running == true then self.status = node_statuses.running end
	return self.status
end

function Sequence:print()
	print("Sequence node")
	print("Number of child nodes: " .. #self.children)
	for i, child in ipairs(self.children) do
		child:print()
	end
end

Fallback = class("Fallback", CompositeNode)

function Fallback:initialize()
	CompositeNode.initialize(self)
	self.status = node_statuses.ready
	self.current_child_num = 1
end

function Fallback:activate(blackboard) self.status = node_statuses.running end

function Fallback:deactivate(blackboard) 
	if self.children then 
		for i, child in ipairs(self.children) do
			child:deactivate()
		end
	end
	self.status = node_statuses.ready
end

function Fallback:tick(dt, blackboard)
	for i = self.current_child_num, #self.children do
		local child = self.children[i]
		local child_status = child:getStatus()

		if child_status == node_statuses.ready then
			child:activate(blackboard)
		end
		self.status = child:tick(dt, blackboard)

		if self.status == node_statuses.failure then goto continue
		elseif self.status == node_statuses.success then return self.status
		elseif self.status == node_statuses.running then return self.status
		end

		::continue::

		self.current_child_num = self.current_child_num + 1
	end

	return self.status
end

function Fallback:print()
	print("Fallback node")
	print("Number of child nodes: " .. #self.children)
	for i, child in ipairs(self.children) do 
		child:print()
	end
end



ReactiveFallback = class("ReactiveFallback", CompositeNode)

function ReactiveFallback:initialize()
	CompositeNode.initialize(self)
	self.status = node_statuses.ready
	self.current_child_num = 1
end

function ReactiveFallback:activate(blackboard) self.status = node_statuses.running end

function ReactiveFallback:deactivate(blackboard) 
	if self.children then 
		for i, child in ipairs(self.children) do
			child:deactivate()
		end
	end
	self.status = node_statuses.ready 
end


function ReactiveFallback:tick(dt, blackboard)
	self.current_child_num = 1
	for i = self.current_child_num, #self.children do
		local child = self.children[i]
		local child_status = child:getStatus()

		if child_status == node_statuses.ready then
			child:activate(blackboard)
		end
		self.status = child:tick(dt, blackboard)

		if self.status == node_statuses.failure then goto continue
		elseif self.status == node_statuses.success then return self.status
		elseif self.status == node_statuses.running then return self.status
		end

		::continue::

		self.current_child_num = self.current_child_num + 1
	end

	return self.status
end

function ReactiveFallback:print()
	print("Fallback node")
	print("Number of child nodes: " .. #self.children)
	for i, child in ipairs(self.children) do 
		child:print()
	end
end

