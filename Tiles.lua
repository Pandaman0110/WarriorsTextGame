local pairs, ipairs = pairs, ipairs

Map = class("Map")

--most of the drawing and shit happens here

function Map:initialize(player)
	self.tilemap = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
	}

	self.tiles = {
		love.graphics.newImage("map/grass.png"),
		love.graphics.newImage("map/wall.png")
	}

	self.player = player
	self.player:setMap(self.tilemap)
	self.player:getAnimal():setPos(10, 6)
	--self.cats = cats

	--self.player:setMap(self.tilemap)
	--self.testcat = genRandomCat()
	--table.insert(self.cats, self.testcat)
	--self.catAi = Ai:new(self.testcat, self.cats, self.tilemap)
	--self.testtimer = 0

	--self.decals = {}

	self.width = #self.tilemap[1]
	self.height = #self.tilemap
	self.mapX = self.player:getAnimal():getX()
	self.mapY = self.player:getAnimal():getY() 
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
	self.mapX = (self.player:getAnimal():getX() - 10 * self.tileSize)
	self.mapY = (self.player:getAnimal():getY() - 6 * self.tileSize)
end

function Map:getTileMap()
	return self.tilemap 
end

function Map:getWidth()
	return self.width
end 

function Map:getHeight() 
	return self.height 
end

--use this to draw like blood and shit

Decal = class("Decal")

function Decal:initialize(x, y, image)
	self.image = image
	self.x = x
	self.y = y
	self.pos = pos
	self.table = table
	self.timer = 3600
end

function Decal:add(t)
	table.insert(t, self)
	self.pos = #t
	self.table = t
end

function Decal:delete()
	table.remove(self.table, self.pos)
end

function Decal:update(dt)
	self.timer = self.timer - dt

	if self.timer < 0 then
		self:delete()
	end
end

function Decal:draw(offset_x, offset_y, firstTile_x, firstTile_y) 
	love.graphics.draw(self.image, ((self.x-1) * 32 - firstTile_x * 32) - offset_x - 16, ((self.y - 1) * 32 - firstTile_y * 32) - offset_y - 8)
end

function Decal:getImage()
	return self.image 
end

function Decal:getX()
	return self.x 
end

function Decal:getY()
	return self.y
end

