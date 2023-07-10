Controller = class("Controller")

function Controller:initialize(animal, cat_handler, collision_map)
	self.animal = animal  
	self.cat_handler = cat_handler
	self.collision_map = collision_map
end

function Controller:checkCollision(x, y)
	assert(x .. " must be a number")
	assert(y .. " must be a number")
	if self.collision_map[y][x] == 1 then return false end
	return true
end

function Controller:getAnimal() 
	return self.animal 
end

function Controller:getCollisionMap()
	return self.collision_map 
end

function Controller:setCatHandler(cat_handler)
	self.cat_handler = cat_handler
end

function Controller:setCollisionMap(collision_map)
	self.collision_map = collision_map 
end

function Controller:setAnimal(animal)
	self.animal = animal 
end

function Controller:update(dt)

end


Player = class("Player", Controller)

local keypressed_timer_val = .05

function Player:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)
	self.keypressed_timer = keypressed_timer_val
end

function Player:mousepressed(tx, ty, button)
	local message = nil
	for i, animal in self.cat_handler:iterator() do
		local animal_pos = animal:getGamePos()
		if animal_pos[1] == tx and animal_pos[2] == ty then		
			if button == 1 then
				message = self.animal:decide(animal, self.cat_handler)
			elseif button == 2 then

			end
		end
	end
	return message
end

--why dont we send an event to cat handler and it decides what to do einstead of printing 

function Player:keypressed(key)
	if key == 'c' then 
		self.animal:switchClaws()
		print(self.animal:getClaws())
	end
	if key == 'v' then
		self.animal:switchIntent()
		print(self.animal:getIntent())
	end
end

function Player:update(dt)
	if self.animal:isMoving() == false then
		if love.keyboard.isDown("d") or love.keyboard.isDown("a") or love.keyboard.isDown("w") or love.keyboard.isDown("s") then
			local input_x, input_y = 0, 0

			if love.keyboard.isDown("d") then input_x = 1 end
			if love.keyboard.isDown("a") then input_x = -1 end
			if love.keyboard.isDown("w") then input_y = -1 end
			if love.keyboard.isDown("s") then input_y = 1 end

			self.keypressed_timer = self.keypressed_timer - dt
			if self.keypressed_timer < 0 then 
				self.keypressed_timer = keypressed_timer_val

				local coords = self.animal:getGamePos()

				local dest_x = input_x + coords[1]
				local dest_y = input_y + coords[2]

				if self:checkCollision(dest_x, dest_y) then		
					self.animal:setDestination(input_x, input_y)
				end
			end
		else self.keypressed_timer = keypressed_timer_val end
	end
end

AnimalController = class("AnimalController", Controller)

local path_blocked_timer_val = 2

function AnimalController:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)

	self.move_queue = Queue:new()

	self.current_path = nil
	self.num_steps = 0
	self.current_step_num = 1

	self.path_blocked_timer = path_blocked_timer_val
	self.path_blocked = false
end

function AnimalController:update(dt)
	if self.path_blocked == true then 
		self.path_blocked_timer = self.path_blocked_timer - dt
		if self.path_blocked_timer < 0 then
			self:recalculateCurrentPath()
			self.path_blocked_timer = path_blocked_timer_val
		end
	end

	if self.current_step_num <= self.num_steps then
		if self.animal:isMoving() == false then 
			next_move = self.current_path[self.current_step_num]
			if self:checkCollision(next_move[1], next_move[2]) then
				self.path_blocked = false
				self.path_blocked_timer = path_blocked_timer_val

				local coords = self.animal:getGamePos()
				local dest_x, dest_y = 0, 0

				dest_x = next_move[1] - coords[1]
				dest_y = next_move[2] - coords[2]

				self.animal:setDestination(dest_x, dest_y)
				self.current_step_num = self.current_step_num + 1
			else 
				self.path_blocked = true
			end
		end
	else
		self:resetCurrentPath()
	end
end


function AnimalController:queueMove(move)
	self.move_queue:push(move)

	if self.current_path == nil then 
		self:resetCurrentPath()
	end
end

function AnimalController:resetCurrentPath()
	if self.move_queue:size() > 0 then

		local coords = self.animal:getGameDestPos()

		self.current_move_order = self.move_queue:pop()
		self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])
		self.num_steps = #self.current_path
	else 
		self.current_path = nil
		self.num_steps = 0
	end

	self.current_step_num = 1
end

function AnimalController:recalculateCurrentPath()
	local coords = self.animal:getGameDestPos()

	self.current_step_num = 1
	self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])

	self.num_steps = #self.current_path
end

function AnimalController:calculatePath(start_x, start_y, end_x, end_y)
	local walkable = 0 

	local map = {}

	--[[
	for i = 1, #self.collision_map do
		map[i] = {}
		for j = 1, #self.collision_map[1] do
			map[i][j] = self.collision_map[i][j] 
		end
	end

	for i, cat in self.cat_handler:iterator() do
		local coords = cat:getGamePos()
		map[coords[2][coords[1] = 1
	end

	]]


	local _grid = grid(self.collision_map)
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

	--for i, move in ipAnimalControllerrs(path) do
	--	print(move[1], move[2])
	--end

	return path
end