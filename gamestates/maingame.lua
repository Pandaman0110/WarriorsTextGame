maingame = {}

function maingame:init()
	self.background = love.graphics.newImage("Images/BrownBackground.png")
	self.timer = Timer:new()

	self.buttons = {}

end

function maingame:enter()

end

function maingame:update(dt)
	self.timer:update(dt)
end

function maingame:mousepressed(x, y, button)

end

function maingame:draw()
	love.graphics.draw(self.background, 0, 0)

	for i, _button in ipairs(self.buttons) do
		_button:draw()
	end

	textSettings()
	love.graphics.setFont(EBG_R_20)

	self.timer:drawTime(10, 10)

	clear()
end