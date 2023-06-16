Location = class("Location")

function Location:initialize(x, y, w, h)
	self.image = love.graphics.newImage("Images/node.png")
	self.x = x
	self.y = y
	self.width = w
	self.height = h
	self.origin_x = math.floor(self.x + self.width / 2)
	self.origin_y = math.floor(self.y + self.height / 2)
end

function Location:update(dt)
	local d = nil
end

function Location:draw(offset_x, offset_y, firstTile_x, firstTile_y)
	love.graphics.draw(self.image, ((self.origin_x-1) * 32 - firstTile_x * 32) - offset_x - 16, ((self.origin_y-1) * 32 - firstTile_y * 32) - offset_y - 16 - 8)
end

function Location:getPos()
	return {self.x, self.y}
end

function Location:getOrigin()
	return {self.origin_x, self.origin_y}
end

function Location:getRandomPoint()
	local x = random(self.x, self.x + self.width)
	local y = random(self.y, self.y + self.height)
	
	return {x, y}
end

function Location:inside(coords)
	if coords[1] > self.x and coords[1] < (self.x + self.width) and coords[2] > self.y and coords[2] < (self.y + self.height) then return true
	else return false end
end