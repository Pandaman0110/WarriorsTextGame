startup = {}

function startup:init()
	self.a = 255
end

function startup:update(dt)
end

function startup:keypressed(key)
	if key == "space" then
		gamestate.switch(mainmenu)
	end
end

function startup:draw()
	love.graphics.print('"The only true borders lie between day and night, life and death." - Brambleberry', (push:getWidth() / 2) - 250, push:getHeight() / 2, 0)
	love.graphics.print("Press space to continue", (push:getWidth() / 2) - 75, (push:getHeight() / 2) + 200, 0)
end

