charactercreate = {}

function charactercreate:init()
	--buttons
	self.buttons = {}
	local nextButtonImage = love.graphics.newImage("Images/Next.png")
	self.nextBox = Button:new(imageCenterX(nextButtonImage) + 16, imageCenterY(nextButtonImage) +  150, nextButtonImage)
	table.insert(self.buttons, self.nextBox)
	
end

function charactercreate:update(dt)
	
end


function charactercreate:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	if button == 1 then
		for i, _button in ipairs(self.buttons) do
			if _button:mouseInside(mx, my) == true then
				if _button == self.nextBox then gamestate.switch() end
			end
		end
	end
end


function charactercreate:draw()
	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

end