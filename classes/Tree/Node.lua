local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}

Node = class("Node")

function Node:initialize()
	self.status = node_statuses.ready
end

function Node:activate(blackboard) end

function Node:deactivate(blackboard) 
	self.status = node_statuses.ready
end

function Node:tick(dt, blackboard)
	--check a condition or implemement an action here


	return self.status
end

function Node:getStatus()
	return self.status
end

function Node:hasChildren()
	return false
end

function Node:print()
	print("Node node")
end