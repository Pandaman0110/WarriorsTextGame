--Action LeafNodes


FindPath = class ("FindPath", LeafNode)

function FindPath:initialize(agent)
	LeafNode.initialize(self, agent)
end

function FindPath:start()
	
	self.started = true
end


function FindPath:process(destination)
	self.agent:getController():calculatePath()

end






MoveTo = class("MoveTo", LeafNode)

function MoveTo:initialize(agent)
	LeafNode.initialize(self, agent)
end

function MoveTo:start()
	self.agent:getController():queueMove(move)
	self.started = true
end

function MoveTo:process(move)
	if self.agent:isAt(move) then self.status = node_states.success
	--elseif  then fail conditiont
	else self.status = node_states.running --continue running
	end
	return self.status
end





LookAround = class("LookAround", LeafNode)

function LookAround:initialize(agent)
	LeafNode.initialize(self,agent)
end

function LookAround:start()


	self.started = true
end

function LookAround:process()
	
	return self.status
end



--Condition leafnodes


DistanceToCat = class("DistanceTo", LeafNode)