startup = {}

function startup:init()
	self.canContinue = false
	self.randQuotes = shuffle(Quotes)
	print(#self.randQuotes.. "  ".. #Quotes)
	self.quote = 1
end

function startup:update(dt)
end

function startup:keypressed(key)
	if key == "space" then
		gamestate.switch(mainmenu)
	end
	if key == "left" then 
		if self.quote == 1 then self.quote = #self.randQuotes
		else self.quote = self.quote - 1 end
	end
	if key == "right" then 
		if self.quote == #self.randQuotes then self.quote = 1
		else self.quote = self.quote + 1 end
	end
end

function startup:draw()
	love.graphics.setFont(EBG_I_Large)

	love.graphics.printf(self.randQuotes[self.quote], 0, 160, windowWidth, "center", 0, scX())

	love.graphics.printf("Press space to continue", 0, 260, windowWidth, "center", 0, scX())

	textSettings()
	love.graphics.setFont(EBG_R_20)
	clear()
end

