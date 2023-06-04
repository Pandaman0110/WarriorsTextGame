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

			if self.cat_handler:checkTile(destTileX, destTileY) == false then
				self.animal:setIsMoving(true)
				self.animal:getInput(inputX, inputY, direction)
			end
		end
	end
end

Ai = class("Ai", Controller)

function Ai:initialize(animal, cathandler, collision_map)
	Controller.initialize(self, animal, cathandler, collision_map)

	self.path = {}
	self.moves = 0
	self.moveCounter = 0
	self.currentMove = 2
end

function Ai:update(dt)
	local nextMove = {}
	local destX, destY = 0, 0
	if self.path ~= nil then 
		if self.moveCounter < self.moves then 
			if self.animal:isMoving() == false then
				nextMove = self.path[self.currentMove]

				if self.cat_handler:checkTile(nextMove[1], nextMove[2]) == false then 
					destX = nextMove[1] - self.animal:getTileX()
					destY = nextMove[2] - self.animal:getTileY()
					self.animal:setDirection(destX, destY)
					self.currentMove = self.currentMove + 1
					self.moveCounter = self.moveCounter + 1
				end
			end
		elseif self.moveCounter > self.moves then 
			self.currentMove = 2
			self.moveCounter = 0
			self.moves = 0
			self.path = nil
		end
	end
end

function Ai:setPath(x, y)
	local walkable = 0 
	local map = self.collision_map
	local _grid = grid(map)
	local finder = pathfinder(_grid, 'JPS', walkable)
	finder:setMode("ORTHOGONAL")
	local startx, starty = self.animal:getPos()
	local endx = x
	local endy = y
	local path = finder:getPath(startx, starty, endx, endy)
	for node, count in path:iter() do
		local move = {}
		table.insert(move, node:getX())
		table.insert(move, node:getY())
		table.insert(self.path, move)
	end
	--[[for i, move in ipairs(self.path) do
		print(move[1] .. "   " .. move[2])
	end--]]
	self.moves = path:getLength()
end

