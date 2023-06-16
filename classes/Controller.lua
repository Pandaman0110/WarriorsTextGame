Controller = class("Controller")

function Controller:initialize(animal, cathandler, collision_map)
	self.animal = animal  
	self.cat_handler = cathandler
	self.collision_map = collision_map
end

function Controller:checkCollision(x, y)
	if self.collision_map[y][x] == 1 then return true end

	if self.cat_handler:checkTile(x, y) then return true end

	return false
end

function Controller:getAnimal() 
	return self.animal 
end

function Controller:getCollisionMap()
	return self.collision_map 
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
	for animal in self.cat_handler:iterator() do
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

				if self:checkCollision(dest_x, dest_y) == false then		
					self.animal:setDestination(input_x, input_y)
				end
			end
		else self.keypressed_timer = keypressed_timer_val end
	end
end

Ai = class("Ai", Controller)

local path_blocked_timer_val = 2

function Ai:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)

	self.move_queue = Queue:new()

	self.current_path = nil
	self.num_moves = 0
	self.current_move_num = 1

	self.path_blocked_timer = path_blocked_timer_val
	self.path_blocked = false
end

function Ai:update(dt)
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
				--basically if there is something in the way, it just stops, but when that thing moves it will keep going
		end
	else
		self:resetCurrentPath()
	end
end

function Ai:resetCurrentPath()
	local coords = self.animal:getGamePos()

	self.current_move_num = 1

	if self.move_queue:size() > 0 then
		self.current_move_order = self.move_queue:pop()
		self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])
		self.num_moves = #self.current_path
	else 
		self.current_path = nil
		self.num_moves = 0
	end
end

function Ai:recalculateCurrentPath()
	local coords = self.animal:getGamePos()

	self.current_move_num = 1
	self.current_path = self:calculatePath(coords[1], coords[2], self.current_move_order[1], self.current_move_order[2])
	self.num_moves = #self.current_path
end

function Ai:queueMove(move)
	self.move_queue:push(move)

	if self.current_path == nil then self:resetCurrentPath() end
end

function Ai:calculatePath(start_x, start_y, end_x, end_y)
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

	local path = {}

	for node, count in finder:getPath(start_x, start_y, end_x, end_y):iter() do
		local move = {}
		move[1] = node:getX()
		move[2] = node:getY()
		table.insert(path, move)
	end

	table.remove(path, 1)

	return path
end