local pairs, ipairs = pairs, ipairs

local tile_set_directory = "Map/"

MapHandler = class("MapHandler")

--most of the drawing and shit happens here

local tile_size = 32
local display_x = 20 
local display_y = 12
local display_buffer = 2

--MapHandler:initialize(map, tileset)

function MapHandler:initialize(camera, map, tile_set)
	self.camera = camera

	if map then self.tile_map = map
	else self.tile_map = fileHandler:loadLevel("OldForest") end

	if tile_set then self.tile_set = tile_set
	else self.tile_set = fileHandler:loadTileSet("default") end

	self.collidable = {
		[0] = 0,
		[1] = 1
	}
	
	self.collision_map = {}

	function MapHandler:checkCollision(x, y)
		return self.collidable[self.tile_map[x][y]]
	end

	for i = 1, #self.tile_map do
		self.collision_map[i] = {}
		for k = 1, #self.tile_map[i] do
			self.collision_map[i][k] = self:checkCollision(i, k)
		end
	end

	--self.tile_set = {
	--	love.graphics.newImage("map/grass.png"),
	--	love.graphics.newImage("map/wall.png")
	--}

	self.width = #self.tile_map[1]
	self.height = #self.tile_map
	
	local camera_coords = self.camera:getRealPos()

	self.mapX = (camera_coords[1])
	self.mapY = (camera_coords[2])
end

function MapHandler:draw()
	local offset_x = self.mapX % tile_size
	local offset_y = self.mapY % tile_size
	local firstTile_x = math.floor(self.mapX / tile_size)
	local firstTile_y = math.floor(self.mapY / tile_size)

	for y = 1, (display_y + display_buffer) do
		for x = 1, (display_x + display_buffer) do
			if y + firstTile_y >= 1 and y+firstTile_y <= self.height and x + firstTile_x >= 1 and x + firstTile_x <= self.width then 
				love.graphics.draw(self.tile_set[self.tile_map[y + firstTile_y][x + firstTile_x] + 1], ((x-1) * tile_size) - offset_x - tile_size/2, ((y-1) * tile_size) - offset_y - tile_size/2 - 8)
				
			end
		end
	end
	
	return offset_x, offset_y, firstTile_x, firstTile_y
end

function MapHandler:update(dt)
	local camera_coords = self.camera:getRealPos()

	self.mapX = (camera_coords[1] - 10 * tile_size)
	self.mapY = (camera_coords[2] - 6 * tile_size)
end

function MapHandler:getRenderMap()
	return self.tile_map 
end

function MapHandler:getCollisionMap()
	return self.collision_map
end

function MapHandler:validPos(tile_x, tile_y)
	if tile_x > #self.tile_map[1] or tile_x <= 0 then return false end
	if tile_y > #self.tile_map or tile_y <= 0 then return false end
	return true
end

function MapHandler:changeTile(tx, ty, new_tile)
	self.tile_map[ty][tx] = new_tile
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
	if not self.decal_queue:isEmpty() then 
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
	return self.decal_queue:size()
end

function DecalHandler:printDetails()
	print(self.decal_queue:size() .. " decals")
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
