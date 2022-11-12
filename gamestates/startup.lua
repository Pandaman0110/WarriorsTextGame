startup = {}

function startup:init()
	self.a = 255
end

function startup:update(dt)
end

function startup:draw()
	timer.after(5, printText('"The only true border lie between day and night, life and death."'))
	timer.after(10, gamestate.switch(mainmenu))
end

function printText(text)
	love.graphics.print(text, push:getWidth() / 2, push:getHeight() / 2)
end