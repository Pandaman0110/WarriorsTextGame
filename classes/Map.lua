local pairs, ipairs, print = pairs, ipairs, print

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

	self.tile_map, self.width, self.height = fileHandler:loadLevel(map)

	self.width = tonumber(self.width)
	self.height = tonumber(self.height)

	if tile_set then self.tile_set = tile_set
	else self.tile_set = fileHandler:loadTileSet("default") end

	self.collidable = {
		[1] = 0,
		[2] = 1
	}
	
	self.nav_map = {}

	self.collision_map = {}
	self.collision_map_2d = {}


	for i = 1, #self.tile_map do
		self.collision_map[i] = self.collidable[self.tile_map[i]]
	end

	for i = 1, #self.collision_map / self.width do
		self.collision_map_2d[i] = {} 
		for k = 1, self.width do
			self.collision_map_2d[i][k] = self.collision_map[self.width * (i-1) + k]
		end
	end

	
	local camera_x, camera_y = self.camera:getPos()

	self.mapX = (camera_x)
	self.mapY = (camera_y)
end

function MapHandler:draw()
	local offset_x = self.mapX % tile_size
	local offset_y = self.mapY % tile_size
	local firstTile_x = math.floor(self.mapX / tile_size)
	local firstTile_y = math.floor(self.mapY / tile_size)

	for y = 1, (display_y + display_buffer) do
		for x = 1, (display_x + display_buffer) do
			if y + firstTile_y >= 1 and y+firstTile_y <= self.height and x + firstTile_x >= 1 and x + firstTile_x <= self.width then 
				--print(self.width * ((x + firstTile_x) -1) + (y + firstTile_y))
				--print(x, y, firstTile_x, firstTile_y)
				--print("break\n") 

				love.graphics.draw(self.tile_set[self.tile_map[self.width * ((x + firstTile_x) -1) + (y + firstTile_y)]], ((x-1) * tile_size) - offset_x - tile_size/2, ((y-1) * tile_size) - offset_y - tile_size/2 - 8)
			end
		end
	end
	--error()
	return offset_x, offset_y, firstTile_x, firstTile_y
end

function MapHandler:update(dt)
	local camera_x, camera_y = self.camera:getPos()

	self.mapX = (camera_x - 10 * tile_size)
	self.mapY = (camera_y - 6 * tile_size)
end

function MapHandler:getRenderMap()
	local map = {}

	for i = 1, #self.tile_map do
		map[i] = self.tile_map[i]
	end

	return map
end

function MapHandler:getNavMap()
	return self.nav_map
end

function MapHandler:getCollisionMap()
	return self.collision_map
end

function MapHandler:get2dCollisionMap()
	return self.collision_map_2d
end


function MapHandler:getWidth()
	return self.width
end

function MapHandler:getHeight()
	return self.height
end

function MapHandler:validPos(tile_x, tile_y)
	if tile_x > self.width or tile_x <= 0 then return false end
	if tile_y > self.height or tile_y <= 0 then return false end
	return true
end

function MapHandler:changeTile(tx, ty, new_tile)
	self.tile_map[self.width * (tx-1) + ty] = new_tile
end

function MapHandler:getTile(tx, ty)
	return self.tile_map[self.width * (tx-1) + ty]
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




NavigationMesh = class("NavigationMesh")

function NavigationMesh:initialize(collision_map)
	self.collision_map = collision_map
	self.rectangles = AdjacencyList:new()
end

function NavigationMesh:addRectangle(rectangle)
	self.rectangles:addVertex(rectangle)
end

function NavigationMesh:connectRectangles(rect_1, rect_2)
	self.rectangles:addEdge(rect_1, rect_2, 1)
end

function NavigationMesh:findRectangle(tx, ty)
	for rectangle, adjacent_rectangles in self.rectangles:iterator() do

	end
end



Rectangle = class("Rectangle")

function Rectangle:initialize(x, y, w, h)
	self.x = x 
	self.y = y 
	self.w = w 
	self.h = h
end

function Rectangle:inside(x, y)
	if x > self.x and x < (self.x + self.w) and y > self.y and y < (self.y + self.h) then
		return true
	else return false end
end