Timer = class("Timer")

function Timer:initialize()
	self.time = 0
	self.seconds = 0 
	self.secondsAfter = 0
	self.minutes = 0
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

function Timer:drawTimeActual(x, y)
	love.graphics.print(self.time, x, y, 0, scX())
end

function Timer:drawSeconds(x, y)
	love.graphics.print(self.seconds, x, y, 0, scX())
end

function Timer:drawTime(x, y)
	if self.minutes < 10 and self.secondsAfter < 10 then love.graphics.print("0"..self.minutes..":0"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter >= 10 then love.graphics.print("0"..self.minutes..":"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter < 10 then love.graphics.print("0"..self.minutes..":0"..self.secondsAfter, x, y, 0, scX()) end
	if self.minutes < 10 and self.secondsAfter >= 10 then love.graphics.print("0"..self.minutes..":"..self.secondsAfter, x, y, 0, scX()) end
end

--time is seconds
function Timer:isBefore(time)
	return time < self.seconds
end

function Timer:isAfter(time)
	return time > self.seconds
end