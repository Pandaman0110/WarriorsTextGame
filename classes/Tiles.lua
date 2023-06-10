local pairs, ipairs = pairs, ipairs

Map = class("Map")

--most of the drawing and shit happens here

function Map:initialize(player)
	--use this for rendering floor tiles
	self.tilemap = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	}

	--hashmap to check if a tile is collidable
	self.collidable = {
		[0] = 0,
		[1] = 1
	}

	
	self.collisionmap = {}

	--print(self.collisionmap)


	function Map:checkCollision(x, y)
		return self.collidable[self.tilemap[x][y]]
	end

	for i, row in ipairs (self.tilemap) do
		local t = {}
		table.insert(self.collisionmap, t)
		for k, tile in ipairs (row) do
			local collidable = self:checkCollision(i, k)
			table.insert(self.collisionmap[i], collidable)
		end
	end

	--self.testarr = {
	--	{"a", "b", "c"},
	--	{"d", "e", "f"}, 
	--	{"g", "h", "i"}
	--}

	--for i, row in ipairs(self.testarr) do
	--	for k, tile in ipairs(row) do
	--		print(self.testarr[i][k] .. "")
	--	end
	--end


	self.tiles = {
		love.graphics.newImage("map/grass.png"),
		love.graphics.newImage("map/wall.png")
	}

	self.player = player
	--self.cats = cats

	--self.player:setMap(self.tilemap)
	--self.testcat = genRandomCat()
	--table.insert(self.cats, self.testcat)
	--self.catAi = Ai:new(self.testcat, self.cats, self.tilemap)
	--self.testtimer = 0

	--self.decals = {}

	self.width = #self.tilemap[1]
	self.height = #self.tilemap
	self.mapX = self.player:getX()
	self.mapY = self.player:getY() 
	self.displayBuffer = 2
	self.displayX = 20 
	self.displayY = 12
	self.tileSize = 32

	--self.catAi:setPath(15, 6, self.tilemap)
	--local x, y = self.catAi:getAnimal():getPos()
	
	--randomBlood("light", self.player:getAnimal()):add(self.decals)
end

function Map:draw()
	local offset_x = self.mapX % self.tileSize
	local offset_y = self.mapY % self.tileSize
	local firstTile_x = math.floor(self.mapX / self.tileSize)
	local firstTile_y = math.floor(self.mapY / self.tileSize)

	for y = 1, (self.displayY + self.displayBuffer) do
		for x = 1, (self.displayX + self.displayBuffer) do
			if y + firstTile_y >= 1 and y+firstTile_y <= self.height and x + firstTile_x >= 1 and x + firstTile_x <= self.width then 
				love.graphics.draw(self.tiles[self.tilemap[y + firstTile_y][x + firstTile_x] + 1], ((x-1) * self.tileSize) - offset_x - self.tileSize/2, ((y-1) * self.tileSize) - offset_y - self.tileSize/2 - 8)
				
			end
		end
	end
	
	return offset_x, offset_y, firstTile_x, firstTile_y
end

function Map:update(dt)
	self.mapX = (self.player:getX() - 10 * self.tileSize)
	self.mapY = (self.player:getY() - 6 * self.tileSize)
end

function Map:getRenderMap()
	return self.tilemap 
end

function Map:getCollisionMap()
	return self.collisionmap
end

function Map:getWidth()
	return self.width
end 

function Map:getHeight() 
	return self.height 
end

--use this to draw like blood and shit

DecalHandler = class("DecalHandler")

function DecalHandler:initialize()
	self.decal_queue = Queue:new()
end

function DecalHandler:createDecal(x, y, num)
	local decal = Decal:new(x, y, num)
	self.decal_queue:push(decal)
end

function DecalHandler:remove()
	self.decal_queue:pop()
end

function DecalHandler:update(dt)

	if self.decal_queue:isEmpty() == false then 
		if self.decal_queue:peek():getTime() < 0 then
			local decal = self.decal_queue:pop()
			decal = nil
		end
	end

	self.decal_queue:update(dt)

end


function DecalHandler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	self.decal_queue:drawOffset(offset_x, offset_y, firstTile_x, firstTile_y)
end

function DecalHandler:numDecals()
	return #self.decal_queue
end

function DecalHandler:printDetails()
	print(#self.decal_queue .. " number of decals")
end

Decal = class("Decal")

function Decal:initialize(x, y, imagenum)
	self.imagenum = imagenum
	self.image = Decals[imagenum]
	self.x = x
	self.y = y
	self.timer = 10
end

--hey high mf you need to go make a quee data structure class and then use it to make a qfor the decal showing and shti,
--after that finish decalhandle r and decal, still working on attackin

function Decal:update(dt)
	self.timer = self.timer - dt
end

function Decal:draw(offset_x, offset_y, firstTile_x, firstTile_y) 
	love.graphics.draw(self.image, ((self.x-1) * 32 - firstTile_x * 32) - offset_x - 16, ((self.y - 1) * 32 - firstTile_y * 32) - offset_y - 24)
end

function Decal:getImage()
	return self.image 
end

function Decal:getImageNum()
	return self.imagenum
end

function Decal:getTime()
	return self.timer
end

function Decal:getX()
	return self.x 
end

function Decal:getY()
	return self.y
end

function Decal:printDetails()
	print(self.image)
	print("Image - Decal "..self.imagenum)
	print("Pos - ("..self.x..", "..self.y..")")
	print("Time left - "..self.timer)
end

