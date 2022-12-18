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
	love.graphics.setFont(EBG_I_Large)

	love.graphics.pop()
		love.graphics.print('"The only true borders lie between day and night, life and death." - Brambleberry', 320 / xScale, 480 / yScale)
		love.graphics.print("Press space to continue", 800 / xScale, 800 / yScale)
	love.graphics.push()
	
	--love.graphics.print('"The only true borders lie between day and night, life and death." - Brambleberry', 320 / 3, 480 /3)
	--love.graphics.print("Press space to continue", 800 / 3, 800 / 3)
	
end

