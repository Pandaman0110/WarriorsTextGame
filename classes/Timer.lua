Timer = class("Timer")

local seconds_in_day = 86400
local seconds_in_hour = 3600
local seconds_in_minute = 60

function Timer:initialize(daylength)
	self.seconds_in_game_day = daylength
	self.clock_mode = "real"

	self.real_time = 0
	self.game_time = self.real_time * (seconds_in_day / self.seconds_in_game_day)

	self.real_seconds = 0
	self.real_seconds_after_minute = 0
	self.real_minutes = 0
	self.real_minutes_after = 0
	self.real_hours = 0

	self.game_seconds = 0
	self.game_seconds_after_minute = 0
	self.game_minutes = 0
	self.game_minutes_after = 0
	self.game_hours = 0

	self.moon_elapsed = 0
	self.game_day_elapsed = 0
end

function Timer:update(dt)
	if self.game_hours >= 24 then 
		self.real_time = 0
		self.game_day_elapsed = self.game_day_elapsed + 1  
	end

	self.moon_elapsed = math.floor(self.moon_elapsed / 30)

	self.real_time = self.real_time + dt
	self.game_time = self.real_time * (seconds_in_day / self.seconds_in_game_day)

	self.real_seconds = math.floor(self.real_time)
	self.real_seconds_after_minute = math.floor(self.real_seconds % seconds_in_minute)
	self.real_minutes = math.floor(self.real_time / seconds_in_minute)
	self.real_minutes_after = math.floor(self.real_minutes % seconds_in_minute)
	self.real_hours = math.floor(self.real_time / seconds_in_hour)

	self.game_seconds = math.floor(self.game_time)
	self.game_seconds_after_minute = math.floor(self.game_seconds % seconds_in_minute)
	self.game_minutes = math.floor(self.game_time / seconds_in_minute)
	self.game_minutes_after = math.floor(self.game_minutes % seconds_in_minute)
	self.game_hours = math.floor(self.game_time / seconds_in_hour)

end

function Timer:draw(x, y)
	if self.clock_mode == "real" then self:drawRealTime(x, y) end
	if self.clock_mode == "game" then self:drawGameTime(x, y) end 
end

function Timer:keypressed(key)
	if key == "t" then self:switchMode() end
end

function Timer:toReal()
	self.clock_mode = "real"
end

function Timer:toGame()
	self.clock_mode = "game"
end

function Timer:switchMode()
	if self.clock_mode == "real" then self.clock_mode = "game"
	elseif self.clock_mode == "game" then self.clock_mode = "real"
	end
end

function Timer:getRealTime()
	local hours, minutes, seconds_after_minute

	if self.real_hours < 10 then hours = "0" .. self.real_hours else hours = self.real_hours end
	if self.real_minutes_after < 10 then minutes = "0" .. self.real_minutes_after else minutes = self.real_minutes_after end
	if self.real_seconds_after_minute < 10 then seconds_after_minute = "0" .. self.real_seconds_after_minute else seconds_after_minute = self.real_seconds_after_minute end

	return (hours .. ":" .. minutes .. ":" .. seconds_after_minute)
end

function Timer:getGameTime()
	local hours, minutes, seconds_after_minute

	if self.game_hours < 10 then hours = "0" .. self.game_hours else hours = self.game_hours end
	if self.game_minutes_after < 10 then minutes = "0" .. self.game_minutes_after else minutes = self.game_minutes_after end
	if self.game_seconds_after_minute < 10 then seconds_after_minute = "0" .. self.game_seconds_after_minute else seconds_after_minute = self.game_seconds_after_minute end

	return (hours .. ":" .. minutes .. ":" .. seconds_after_minute)
end

function Timer:drawRealTime(x, y)
	local time = self:getRealTime()
	love.graphics.print(time, x, y)
end

function Timer:drawGameTime(x, y)
	local time = self:getGameTime()
	love.graphics.print(time, x, y)
end
