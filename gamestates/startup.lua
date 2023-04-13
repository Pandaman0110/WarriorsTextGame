startup = {}

function startup:init()
	self.randQuotes = shuffle(Quotes)
	self.quote = next(self.randQuotes)
end


function startup:keypressed(key)
	if key == "space" then
		gamestate.switch(mainmenu)
	end
	self:changeQuotes(key)
end

function startup:draw()
	self:drawQuotes()
end

----------------------------------------------------------------------------------------------

function startup:changeQuotes(key)
	if key == "left" then 
		if self.quote == 1 then self.quote = #self.randQuotes
		else self.quote = self.quote - 1 end
	end
	if key == "right" then 
		if self.quote == #self.randQuotes then self.quote = 1
		else self.quote = self.quote + 1 end
	end
end

function startup:drawQuotes()
	love.graphics.setFont(EBG_I_Large)

	love.graphics.printf(self.randQuotes[self.quote], 0, 160, windowWidth, "center", 0, scX())

	love.graphics.printf("Press space to continue", 0, 260, windowWidth, "center", 0, scX())

	textSettings()
	love.graphics.setFont(EBG_R_20)
	clear()
end