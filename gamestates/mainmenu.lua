mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

end

function mainmenu:update(dt)


end

function mainmenu:draw()
	love.graphics.draw(self.background, 0, 0)
end