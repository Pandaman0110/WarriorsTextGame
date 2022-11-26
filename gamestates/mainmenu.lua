mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")
	self.start_game = love.graphics.newImage("Images/StartGame.png")

end

function mainmenu:update(dt)
	
end

function mainmenu:draw()
	love.graphics.draw(self.background, 0, 0)
	love.graphics.draw(self.start_game, imageCenterX(self.start_game), imageCenterY(self.start_game))
	love.graphics.draw(self.start_game, imageCenterX(self.start_game), imageCenterY(self.start_game) - self.start_game:getHeight() - 2)
end