Player = class("Player")

function Player:initialize(cat, cats, map)
	self.cat = cat
	self.cats = cats
	self.map = map
end

function Player:getCat() 
	return self.cat 
end 

function Player:setCat(cat) 
	self.cat = cat
end

function Player:setMap(map)
	self.map = map 
end

function Player:checkCollision(x, y, map)
	local collide = false
	if map[y][x] == 1 then collide = true end

	for i, cat in ipairs(self.cats) do
		if cat:getTileX() == x and cat:getTileY() == y then collide = true end
	end

	return collide
end

function Player:update(dt)
	local inputX = 0
	local inputY = 0
	local direction = ""
	local map = self.map

	if self.cat:isMoving() == false then
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

			local destTileX = inputX + self.cat:getTileX()
			local destTileY = inputY + self.cat:getTileY()

			if self:checkCollision(destTileX, destTileY, self.map) == false then
				self.cat:setIsMoving(true)
				self.cat:getInput(inputX, inputY, direction)
			end
		end
	end

	self.cat:update(dt)

end

CatAi = class("CatAi")

function CatAi:initialize(cat, cats, map)
	self.cat = cat
	self.cats = cats
	self.map = map
	self.path = {}
	self.moves = 0
	self.moveCounter = 0
	self.currentMove = 2
end

function CatAi:update(dt)
	local nextMove = {}
	local destX, destY = 0, 0
	if self.path ~= nil then 
		if self.moveCounter < self.moves then 
			if self.cat:isMoving() == false then
				nextMove = self.path[self.currentMove]
				destX = nextMove[1] - self.cat:getTileX()
				destY = nextMove[2] - self.cat:getTileY()

				self.cat:moveCat(destX, destY)
				self.currentMove = self.currentMove + 1
				self.moveCounter = self.moveCounter + 1
			end
		elseif self.moveCounter > self.moves then 
			self.currentMove = 2
			self.moveCounter = 0
			self.moves = 0
			self.path = nil
		end
	end

	self.cat:update(dt)
end

function CatAi:getCat()
	return self.cat 
end

function CatAi:getMap()
	return self.map 
end

function CatAi:setPath(x, y, map)
	local walkable = 0 
	local map = map 
	local _grid = grid(map)
	local finder = pathfinder(_grid, 'JPS', walkable)
	finder:setMode("ORTHOGONAL")
	local startx, starty = self.cat:getPos()
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