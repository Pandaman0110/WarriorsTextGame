warning = class("warning")



function warning:enter(from, text)
	self.from = from
	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.warning = love.graphics.newImage("Images/warning.png")

	self.text = text

	self.buttons = Array:new()

	self.yes_button = ImageButton:new(640/2 - 80, 272, love.graphics.newImage("Images/yes.png"), self.buttons)
	self.no_button = ImageButton:new(640/2 + 16, 272, love.graphics.newImage("Images/no.png"), self.buttons)
end

function warning:mousepressed(x, y, button)
	local mx, my = push:toGame(x, y)

	for i, _button in self.buttons:iterator() do
		if _button:mouseInside(mx, my, _button) then
			return gamestate.pop(_button)
		end
	end
end

function warning:update(dt)

end

function warning:draw()
	self.from:draw()

	love.graphics.draw(self.brown_box, 640/2 - self.brown_box:getWidth()/2, 360/2 - self.brown_box:getHeight()/2)
	love.graphics.draw(self.warning, 640/2 - self.warning:getWidth()/2, 80)

	for i, button in self.buttons:iterator() do
		button:draw()
	end

	love.graphics.setFont(EBG_I_Large)

	love.graphics.printf(self.text, 0, 360/2, windowWidth, "center", 0, scX())
end