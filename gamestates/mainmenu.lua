mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

end

function mainmenu:update(dt)
	Slab.BeginWindow("mainmenu", {NoOutline = true, BgColor = {0,0,0,0}, X = push:getWidth()/2 - 163, Y = push:getHeight()/2 , W = 200, H = 600})
		if Slab.Button("Start a new game", {W = 500, H = 100}) then
			StartButtonPressed = true
		end
		if StartButtonPressed then 
			gamestate.switch()
		end
	Slab.EndWindow()
end

function mainmenu:draw()
	love.graphics.draw(self.background, 0, 0)
end