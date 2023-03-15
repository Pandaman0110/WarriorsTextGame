Map = class("Map")

--most of the drawing and shit happens here

function Map:initialize(player, clans)
	self.tilemap = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	}

	self.player = player
	self.clans = clans

	self.player:setMap(self.tilemap)
	self.testcat = genRandomCat()
	self.catAi = CatAi:new(self.testcat, self.tilemap)
	self.testtimer = 0

	self.decals = {}

	self.width = #self.tilemap[1]
	self.height = #self.tilemap
	self.mapX = self.player:getCat():getX()
	self.mapY = self.player:getCat():getY() 
	self.displayBuffer = 2
	self.displayX = 20 
	self.displayY = 12
	self.tileSize = 32

	self.catAi:moveCat(15, 6, self.tilemap)
	local x, y = self.catAi:getCat():getPos()

	print(self.catAi:getMap()[1][1] .."  " .. self.tilemap[1][1])
	
	--randomBlood("light", self.player:getCat()):add(self.decals)
end

function Map:draw()
	local offset_x = self.mapX % self.tileSize
	local offset_y = self.mapY % self.tileSize
	local firstTile_x = math.floor(self.mapX / self.tileSize)
	local firstTile_y = math.floor(self.mapY / self.tileSize)

	for y = 1, (self.displayY + self.displayBuffer) do
		for x = 1, (self.displayX + self.displayBuffer) do
			if y + firstTile_y >= 1 and y+firstTile_y <= self.height and x + firstTile_x >= 1 and x + firstTile_x <= self.width then 
				love.graphics.draw(GroundTiles[self.tilemap[y + firstTile_y][x + firstTile_x] + 1], ((x-1) * self.tileSize) - offset_x - self.tileSize/2, ((y-1) * self.tileSize) - offset_y - self.tileSize/2 - 8)
				
			end
		end
	end

	--someone can come in and fix all this to only draw shit in range

	for i, decal in ipairs(self.decals) do 
		love.graphics.draw(decal:getImage(), ((decal:getX()-1)*self.tileSize-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, ((decal:getY()-1)* self.tileSize-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
	end

	for i, clan in ipairs(self.clans) do
		for i, cat in ipairs(clan:getCats()) do
			cat:drawImage((cat:getX()-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, (cat:getY()-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
		end
	end

	--self.testcat:drawImage((self.testcat:getX()-firstTile_x * self.tileSize) - offset_x - self.tileSize/2, (self.testcat:getY()-firstTile_y * self.tileSize) - offset_y - self.tileSize/2 - 8)
	self.player:getCat():drawImage(640 / 2 - 16, 360 / 2 - 12)
end

function Map:update(dt)
	self.player:update(dt)
	self.catAi:update(dt)

	for i, decal in ipairs(self.decals) do 
		decal:update(dt)
	end

	self.mapX = (self.player:getCat():getX() - 10 * self.tileSize)
	self.mapY = (self.player:getCat():getY() - 6 * self.tileSize)
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

function Decal:getImage()
	return self.image 
end

function Decal:getX()
	return self.x 
end

function Decal:getY()
	return self.y
end

function randomBlood(speed, cat)
	local blood
	if speed == "light" then
		blood = Decal:new(cat:getTileX(), cat:getTileY(), lume.randomchoice(Bleeding))
	end
	return blood
end
