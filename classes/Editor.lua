local ipairs, pairs = ipairs, pairs
local sqrt2 = math.sqrt(2)


LevelEditorController = class("LevelEditorController")



function LevelEditorController:initialize()
	self.speed = 300
	self.x = 0
	self.y = 0
end

function LevelEditorController:getRealPos()
	return {self.x, self.y}
end

function LevelEditorController:keypressed(key)
	if key == "r" then
		self.speed = self.speed + 300
		if self.speed > 600 then self.speed = 300 end
	end
	if key == "z" then
		if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
			return "undo"
		end
	end
end

function LevelEditorController:update(dt)
	local vx, vy = 0, 0

	if love.keyboard.isDown("d") then 
		vx = vx + 1
	end
	if love.keyboard.isDown("a") then
		vx = vx - 1
	end
	if love.keyboard.isDown("s") then
		vy = vy + 1
	end
	if love.keyboard.isDown("w") then
		vy = vy - 1
	end

	if vx ~= 0 and vy ~= 0 then 
		vx = vx / sqrt2
		vy = vy / sqrt2
	end



	self.x = self.x + vx * self.speed * dt
	self.y = self.y + vy * self.speed * dt
end

function LevelEditorController:mousepressed(tx, ty, button)


end