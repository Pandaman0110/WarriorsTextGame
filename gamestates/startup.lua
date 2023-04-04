startup = {}

function startup:init()
	self.canContinue = false
	self.quote = math.floor(lume.random(1, #Quotes + 1))
end

function startup:update(dt)
end

function startup:keypressed(key)
	if key == "space" then
		gamestate.switch(mainmenu)
	end
	if key == "left" then 
		if self.quote == 1 then self.quote = #Quotes
		else self.quote = self.quote - 1 end
	end
	if key == "right" then 
		if self.quote == #Quotes then self.quote = 1
		else self.quote = self.quote + 1 end
	end
end

function startup:draw()
	love.graphics.setFont(EBG_I_Large)

	love.graphics.printf(Quotes[self.quote], 0, 160, 1920, "center", 0, scX())

	love.graphics.printf("Press space to continue", 0, 260, 1920, "center", 0, scX())

	textSettings()
	love.graphics.setFont(EBG_R_20)
	clear()
end

