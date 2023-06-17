CatController = class("CatController", AnimalController)

function CatController:initialize(animal, cathandler, game_handler, collision_map)
	AnimalController.initialize(self, animal, cathandler, game_handler, collision_map)

	self.state = Statemachine
end



Idle = class("Idle", State)

function Idle:initialize()
	State.initialize(self)
end

function Idle:update(dt)

end

function Idle:getCurrentLocation()

end

Moving = class("Moving", State)

function Moving:initialize()
	State.initialize(self)

	self.move_queue = Queue:new()

	self.current_path = nil
	self.num_moves = 0
	self.current_move_num = 1

	self.path_blocked_timer = path_blocked_timer_val
	self.path_blocked = false
end

function Moving:update()
	if self.path_blocked == true then 
		self.path_blocked_timer = self.path_blocked_timer - dt
		if self.path_blocked_timer < 0 then
			self:recalculateCurrentPath()
			self.path_blocked_timer = path_blocked_timer_val
		end
	end

	if self.current_move_num <= self.num_moves then
		if self.animal:isMoving() == false then 
			next_move = self.current_path[self.current_move_num]
			if self:checkCollision(next_move[1], next_move[2]) == false then
				self.path_blocked = false
				self.path_blocked_timer = path_blocked_timer_val

				local coords = self.animal:getGamePos()
				local dest_x, dest_y = 0, 0

				dest_x = next_move[1] - coords[1]
				dest_y = next_move[2] - coords[2]

				self.animal:setDestination(dest_x, dest_y)
				self.current_move_num = self.current_move_num + 1
			else 
				self.path_blocked = true
			end
		end
	else
		self:resetCurrentPath()
	end
end

function Moving:resetCurrentPath()
	if self.move_queue:size() > 0 then
		local coords = self.animal:getGameDestPos()

		self.current_move_order = self.move_queue:pop()
		self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])
		self.num_moves = #self.current_path
	else 
		self.current_path = nil
		self.num_moves = 0
	end

	self.current_move_num = 1
end

function Moving:recalculateCurrentPath()
	local coords = self.animal:getGameDestPos()

	self.current_move_num = 1
	self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])
	self.num_moves = #self.current_path
end

function Moving:queueMove(move)
	self.move_queue:push(move)

	print(move[1], move[2])

	if self.current_path == nil then 
		self:resetCurrentPath()
	end
end

function Moving:calculatePath(start_x, start_y, end_x, end_y)
	local walkable = 0 

	local map = {}

	for i = 1, #self.collision_map do
		map[i] = {}
		for j = 1, #self.collision_map[1] do
			map[i][j] = self.collision_map[i][j] 
		end
	end

	for cat in self.cat_handler:iterator() do
		local coords = cat:getGamePos()
		map[coords[2]][coords[1]] = 1
	end

	local _grid = grid(map)
	local finder = pathfinder(_grid, 'ASTAR', walkable)
	finder:setTunnelling(false)

	local path = {}

	for node, count in finder:getPath(start_x, start_y, end_x, end_y):iter() do
		local move = {}
		move[1] = node:getX()
		move[2] = node:getY()
		table.insert(path, move)
	end

	table.remove(path, 1)

	--for i, move in ipMovingrs(path) do
	--	print(move[1], move[2])
	--end

	return path
end