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

function Player:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)
end

function Player:mousepressed(tx, ty, button)
	local message = nil
	for i, animal in ipairs(self.cat_handler:getCats()) do
		if animal:getTileX() == tx and animal:getTileY() == ty and animal ~= self.animal then		
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
	local inputX = 0
	local inputY = 0
	local direction = ""

	if self.animal:isMoving() == false then
		if love.keyboard.isDown("d") or love.keyboard.isDown("a") or love.keyboard.isDown("w") or love.keyboard.isDown("s") then
			if love.keyboard.isDown("d") then
				inputX = inputX + 1
				direction = "east"
			elseif love.keyboard.isDown("a") then
				inputX = inputX - 1
				direction = "west"
			elseif love.keyboard.isDown("w") then
				inputY = inputY - 1
				direction = "north"
			elseif love.keyboard.isDown("s") then
				inputY = inputY + 1
				direction = "south"
			end

			local destTileX = inputX + self.animal:getTileX()
			local destTileY = inputY + self.animal:getTileY()

			if self:checkCollision(destTileX, destTileY) == false then		
				self.animal:setIsMoving(true)
				self.animal:getInput(inputX, inputY, direction)
			end
		end
	end
end

Ai = class("Ai", Controller)

function Ai:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)

	self.move_queue = Queue:new()

	self.current_path = nil
	self.num_moves = 0
	self.current_move = 1

	self.path_blocked_timer = 5
	self.path_blocked = false
end

function Ai:update(dt)
	local nextMove = {}
	local destX, destY = 0, 0

	if self.path_blocked == true then 
		print(self.path_blocked_timer)
		self.path_blocked_timer = self.path_blocked_timer - dt
		if self.path_blocked_timer < 0 then 
			self:resetCurrentPath()
			self.path_blocked_timer = 5
		end
	end

	if self.current_move <= self.num_moves then
		if self.animal:isMoving() == false then
			print(self.current_move, self.num_moves)
			nextMove = self.current_path[self.current_move]
			if self:checkCollision(nextMove[1], nextMove[2]) == false then
				self.path_blocked = false
				self.path_blocked_timer = 5
				destX = nextMove[1] - self.animal:getTileX()
				destY = nextMove[2] - self.animal:getTileY()
				self.animal:setDirection(destX, destY)
				self.current_move = self.current_move + 1
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
	self.current_move = 1
	self.path_blocked = false

	if self.move_queue:size() > 0 then
		local move = self.move_queue:pop()
		self.current_path = self:calculatePath(self.animal:getTileX(), self.animal:getTileY(), move[1], move[2])
		self.num_moves = #self.current_path
	else 
		self.current_path = nil
		self.num_moves = 0
	end
end

function Ai:queueMove(x, y)
	local move = {x, y}

	self.move_queue:push(move)

	if self.current_path == nil then self:resetCurrentPath() end
end

function Ai:calculatePath(start_x, start_y, end_x, end_y)
	local walkable = 0 
	local map = self.collision_map
	local _grid = grid(map)
	local finder = pathfinder(_grid, 'JPS', walkable)
	finder:setMode("ORTHOGONAL")

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