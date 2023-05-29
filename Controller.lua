Controller = class("Controller")

function Controller:initialize(animal, animals, map, controllerTable)
	self.animal = animal 
	self.animals = animals 
	self.map = map
	table.insert(controllerTable, self)
end

function Controller:checkCollision(x, y)
	if self.map:checkCollision(x, y) == true then return true end

	for i, animal in ipairs(self.animals) do
		if animal:getTileX() == x and animal:getTileY() == y then return true end
	end

	return false
end

function Controller:getAnimal() 
	return self.animal 
end

function Controller:getMap()
	return self.map 
end

function Controller:setMap(map)
	self.map = map 
end

function Controller:setAnimal(animal)
	self.animal = animal 
end

function Controller:checkTile(x, y)
	for i, animal in ipairs(self.animals) do
		if animal:getTileX() == tx and animal:getTileY() == ty then end
	end
end


Player = class("Player", Controller)

function Player:initialize(cat, animals, map, controllerTable)
	Controller.initialize(self, cat, animals, map, controllerTable)
end

function Player:mousepressed(tx, ty, button)
	for i, animal in ipairs(self.animals) do
		if animal:getTileX() == tx and animal:getTileY() == ty then 
			print(animal:getName())				
			if button == 1 then

			elseif button == 2 then

			end
		end
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

function Ai:initialize(animal, animals, map, controllerTable)
	Controller.initialize(self, animal, animals, map, controllerTable)

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

				if self:checkCollision(nextMove[1], nextMove[2]) == false then 
					destX = nextMove[1] - self.animal:getTileX()
					destY = nextMove[2] - self.animal:getTileY()
					self.animal:move(destX, destY)
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
	local map = self.map:getCollisionMap()
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