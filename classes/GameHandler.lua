GameHandler = class("GameHandler", Handler)

function GameHandler:initialize(clock)
	Handler.initialize(self, clock)
	self.locations = Map:new()
	self.locations:insert("thunder_clan_base", Location:new(5, 6))
	self.locations:insert("river_clan_base", Location:new(20, 15))
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

function GameHandler:getLocation(name)
	return self.locations:at(name)
end

function GameHandler:sendCat(cat, location)
	cat:move(self.locations:at(location):getPos())
end
