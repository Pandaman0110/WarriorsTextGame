startup = {}

function startup:init()
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

	love.graphics.print('"The only true borders lie between day and night, life and death." - Brambleberry', 85, 160, 0, scX())
	love.graphics.print("Press space to continue", 260, 260, 0, scX())

end

