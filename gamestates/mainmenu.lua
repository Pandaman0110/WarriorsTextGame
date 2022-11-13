mainmenu = {}

function mainmenu:init()
	self.background = love.graphics.newImage("Images/Mapwarriors.png")

end

function mainmenu:update(dt)
	Slab.BeginWindow("mainmenu", {NoOutline = true, BgColor = {0,0,0,0}, X = push:getWidth()/2 - 63, Y = push:getHeight()/2, W = 500, H = 600})
		if Slab.Button("Start a new game", {W = 300, H = 50}) then
			ButtonPressed = true
		end

		if ButtonPressed then 
			
		end
	Slab.EndWindow()
end

function mainmenu:draw()
	love.graphics.draw(self.background, 0, 0)
end