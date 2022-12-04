Button = class("Button")


function Button:initialize(x, y, image)
	self.image = image
	self.x = x
	self.y = y
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

end

function Button:update(dt)
	local mx, my = love.mouse.getPosition()


end

function Button:draw()
	love.graphics.draw(self.image, self.x, self.y)
end 

function Button:getX()
	return self.x 
end

function Button:getY()
	return self.y 
end

function Button:getWidth()
	return self.width
end

function Button:getHeight()
	return self.height
end




