Timer = class("Timer")

function Timer:initialize(running)
	self.time = 0
	self.seconds = 0 
	self.secondsAfter = 0
	self.minutes = 0
	if running then self.running = 1 end
end

function Timer:update(dt)
	self.time = self.time + dt
	self.seconds = lume.round(self.time)
	self.secondsAfter = lume.round(self.time % 60)
	self.minutes = lume.round(self.time / 60)
end

function Timer:getTime()
	return self.time
end

function Timer:getSeconds() 
	return self.seconds
end

function Timer:getSecondsAfter()
	return self.secondsAfter
end

function Timer:getMinutes()
	return self.minutes
end

function Timer:getCallback()
	return self.callback
end

function Timer:quit()
	self.running = 0
end

function Timer:isRunning()
	return self.running == 1 
 end

function Timer:drawTimeActual(x, y)
	love.graphics.print(self.time, x, y, 0, scX())
end

function Timer:drawSeconds(x, y)
	love.graphics.print(self.seconds, x, y, 0, scX())
end

--time is seconds
function Timer:isBefore(time)
	return time < self.seconds
end

function Timer:isAfter(time)
	return time > self.seconds
end

function Timer:isAt(time)

end