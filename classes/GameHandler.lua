GameHandler = class("GameHandler", Handler)

function GameHandler:initialize(clock, collision_map)
	Handler.initialize(self, clock)
	self.map_handler = collision_map
	self.locations = Map:new()
	self.locations:insert("thunder_clan_base", Location:new(5, 6, 10, 10))
	self.locations:insert("river_clan_base", Location:new(30, 15, 10, 10))
	self.world = hardon_collider(128)
end

function GameHandler:update(dt)
	for key, node in self.locations:iterator() do
		node:update(dt)
	end
end

function GameHandler:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	for key, node in self.locations:iterator() do
		node:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	end
end

function GameHandler:getLocation(location_name)
	return self.locations:at(location_name)
end

function GameHandler:sendCat(cat, location_name)
	cat:getController():queueMove(self.locations:at(location_name):getOrigin())
end

function GameHandler:getMap()
	return self.collisionmap
end

function GameHandler:at(coords)
	for location_name, location in self.locations:iterator() do
		local pos = location:inside(coords)
		if coords[1] == pos[1] and coords[2] == pos[2] then return location end
	end
	return false
end
