--[[

warning = class("warning")



function warning:enter(from, text)
	self.from = from
	self.brown_box = love.graphics.newImage("Images/large_brown_box.png")
	self.warning = love.graphics.newImage("Images/warning.png")

	self.font = love.graphics.newFont(10, "mono")
	self.font:setFilter("nearest")

	self.text = text


	self.buttons = Array:new()

	self.yes_button = ImageButton:new(640/2 - 96, 256, love.graphics.newImage("Images/yes.png"), self.buttons)
	self.no_button = ImageButton:new(640/2 + 32, 256, love.graphics.newImage("Images/no.png"), self.buttons)

	print(gamestate.current())
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
	print("here")
	love.graphics.draw(self.brown_box, 640/2 - self.brown_box:getWidth()/2, 360/2 - self.brown_box:getHeight()/2)
	love.graphics.draw(self.warning, 640/2 - self.warning:getWidth()/2, 128)

	love.graphics.setFont(font)
	love.graphics.print (self.text, 640/2, 360/2)

	for i, button in self.buttons:iterator() do
		button:draw()
	end
end

]]