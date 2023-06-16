Location = class("Location")

function Location:initialize(x, y)
	self.image = love.graphics.newImage("Images/node.png")
	self.x = x
	self.y = y
end

function Location:update(dt)
	local d = nil
end

function Location:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	love.graphics.draw(self.image, ((self.x-1) * 32 - firstTile_x * 32) - offset_x - 16, ((self.y-1) * 32 - firstTile_y * 32) - offset_y - 16 - 8)
end

function Location:getPos()
	return {self.x, self.y}
end