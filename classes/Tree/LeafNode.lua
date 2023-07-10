local node_statuses = {
	ready = 1,
	success = 2,
	failure = 3,
	running = 4,
}

LeafNode = class("LeafNode", Node)

function LeafNode:initialize(agent)
	Node.initialize(self)
	self.agent = agent
	self.status = node_statuses.ready
end

function LeafNode:activate(blackboard) end

function LeafNode:deactivate(blackboard) self.status = node_statuses.ready end

function LeafNode:tick(dt, blackboard)

	--do shit
	return self.status
end

function LeafNode:getAgent()
	return self.agent
end

function LeafNode:setAgent(agent)
	self.agent = agent
end

function LeafNode:numChildren()
	return 0
end

function LeafNode:getStatus()
	return self.status
end





MoveTo = class("MoveTo", LeafNode)


function MoveTo:initialize()
	LeafNode.initialize(self)
	self.status = node_statuses.ready
end

function MoveTo:activate(blackboard)  
	self.status = node_statuses.running 
	self.agent:getController():queueMove()
end

function MoveTo:deactivate(blackboard) self.status = node_statuses.ready end

function MoveTo:tick(dt, blackboard)
	local target = blackboard:getInfo("current_target")
	local target_pos = target:getGamePos()

	if self.agent:isAt(target_pos) then 
		self.status = node_statuses.success
	else self.status = node_statuses.running 
	end

	return self.status
end

function MoveTo:hasChildren() return false end

function MoveTo:print()
	print("MoveTo node")
end

function MoveTo:addCatHandler(cat_handler)
	self.cat_handler = cat_handler
end

function MoveTo:addGameHandler(game_handler)
	self.game_handler = game_handler
end



LookAround = class("LookAround", LeafNode)

function LookAround:initialize()
	LeafNode.initialize(self)
	self.status = node_statuses.ready
	self.nearby_cats = Array:new()
end

function LookAround:activate(blackboard)
	local points = {}
	local self_pos = self.agent:getGamePos()
	local vision_distance = self.agent:getVisionDistance()

	for i = self_pos[1] - vision_distance, self_pos[1] + vision_distance do
		for k = self_pos[2] - vision_distance, self_pos[2] + vision_distance do
			if i == self_pos[1] - vision_distance or i == self_pos[1] + vision_distance 
				or k == self_pos[2] - vision_distance or k == self_pos[2] + vision_distance
			then 
				local temp = self:bresenham(self_pos[1], self_pos[2], i, k)
				for i, point in ipairs(temp) do
					points[#points + 1] = point
				end
			end
		end
	end

	-- this entire class can be improved

	for i, point in ipairs(points) do
		local cat = self.cat_handler:checkTile(point[1], point[2])
		if cat and not self.nearby_cats:contains(cat) then 
			self.nearby_cats:insert(cat)
		end
	end

	blackboard:post("nearby_cats", nearby_cats)
	blackboard:getInfo("nearby_cats")
end

function LookAround:deactivate(blackboard)
	self.nearby_cats:clear()
	self.status = node_statuses.ready
end

function LookAround:tick(dt, blackboard)
	if blackboard:getInfo("nearby_cats") then self.status = node_statuses.success 
	else self.status = node_statuses.failure
	end

	return self.status
end

function LookAround:checkTile(x, y)
	local result = self.agent:getController():checkCollision(x, y)
	result = self.cat_handler:checkTile(x, y)
	if result then 
		table.insert(self.nearby_cats, result)
		result = true
	end
	return result
end

function LookAround:bresenham(x0, y0, x1, y1)
  local points = {}
  local dx, dy = math.abs(x1-x0), math.abs(y1-y0)
  local err = dx - dy
  local sx, sy= (x0 < x1) and 1 or -1, (y0 < y1) and 1 or -1

  while true do
    points[#points + 1] = {x0, y0}

    if (x0 == x1 and y0 == y1) or not self.agent:getController():checkCollision(x0, y0) then
    	break 
    end

    local e2 = 2 * err
    if e2 > -dy then
      err = err - dy
      x0 = x0 + sx
    end
    if e2 < dx then
      err = err + dx
      y0 = y0 + sy
    end
  end
  table.remove(points, 1)
  return points
end

function LookAround:hasChildren() return false end

function LookAround:print() print("LookAround node") end

function LookAround:addCatHandler(cat_handler)
	self.cat_handler = cat_handler
end

function LookAround:addGameHandler(game_handler)
	self.game_handler = game_handler
end





FollowCat = class("FollowCat", LeafNode)

function FollowCat:initialize()
	LeafNode.initialize(self)
	self.status = node_statuses.ready
end

function FollowCat:activate(blackboard)
	self.status = node_statuses.running
end

function FollowCat:deactivate(blackboard)
	self.status = node_statuses.ready
end

function FollowCat:tick(dt, blackboard)
	local target = blackboard:getInfo("current_target")


	return self.status
end

function FollowCat:hasChildren() return false end