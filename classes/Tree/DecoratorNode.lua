local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}


DecoratorNode = class("DecoratorNode", Node)

function DecoratorNode:initialize()
	Node.initialize(self)
	self.status = node_statuses.ready
	self.child = child
end

function DecoratorNode:activate(blackboard) self.status = node_statuses.running end

function DecoratorNode:deactivate(blackboard) self.status = node_statuses.running end

function DecoratorNode:tick(dt, blackboard)

end

function DecoratorNode:numChildren()
	return 1
end

function DecoratorNode:hasChildren()
	return true
end

function DecoratorNode:setChild(child)
	self.child = child
end

function DecoratorNode:print()
	print("DecoratorNode node")
	self.child:print()
end



Inverter = class("Inverter", DecoratorNode)

function Inverter:initialize()
	Node.initialize(self)
	self.child = child
end

function Inverter:activate(blackboard) self.status = node_statuses.running end

function Inverter:deactivate(blackboard) self.status = node_statuses.running end

function Inverter:tick(dt, blackboard) 

end

function DecoratorNode:print()
	print("Inverter node")
	self.child:print()
end
